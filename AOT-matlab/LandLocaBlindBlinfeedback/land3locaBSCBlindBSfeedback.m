% 该程序定位环境为3个Landmark基站 10个Blind基站
% 2014 08 17 16:12 确定站址处添加了两个min函数以去除min函数只取得列min的bug
% 2014 08 20 10:17 
% 2014 08 21 10:14 将此脚本改为在Blind BSC自身修正自身位置
% 2014 08 23 10:31 此脚本改为获得3landmark、3land+1approximatelyland、3land+1landmark
% 2014 08 25 20:15 修复Blind BSC选址间距问题 逻辑改为由 && 改为 ||


% 实际运行时出现无解的情况
%  正在修改中，届时注意用有噪声的Landmark BSC定位时要注意使用其真实坐标求辐角
% 加入两条Rules：
% 1）直测
%       解析角 = Real landmark BSC position
%       求解   = Noisy landmark BSC position 
% 2）回测
%       Realangle = Real landmark BSC angle + Real Blind BSC position
%       Flaseangle= Noisy landmark BSC angle+ Estimed Blind BSC position



% ***************************初始环境设置(开始)*****************************

% 定位区域大小 landmark基站数目  blind基站数目
Aerawidth=100; LandBSNum=4;BlinBSNum=100;

% 随机选取基站时基站间的距离
LandBSspace=50;BlinBSspace=5;

% 基站广播的消息设定
% BSbroadinfo 1:id 2:flag( Landmark/Blind )  3:xposition  4:yposition 5:headings 6:angle  
id=1; flag=2; xpos=3; ypos=4; headings=5; angle=6;  
LBSbroadinfo=zeros(LandBSNum,6);BBSbroadinfo=zeros(BlinBSNum,6);

% 基站信息设定 
LBSs=zeros( LandBSNum , 4 );BBSs=zeros(BlinBSNum ,4);

% Landmark BSCs站址选取
for LBSid=1:1:LandBSNum
    LBSs(LBSid,id)=LBSid;
    LBSs( LBSid,xpos:ypos )=100*rand( 1,2);
    for checkid=1:1:LBSid-1     
        while min(min(sqrt((repmat(LBSs( LBSid,xpos),checkid,1)-LBSs( 1:checkid , xpos)).^2+(repmat(LBSs( LBSid,ypos),checkid,1)-LBSs( 1:checkid , ypos)).^2)))<LandBSspace
            LBSs( LBSid,xpos:ypos )=100*rand( 1,2);
       end
    end    
end

LBSs(:,flag)=ones(LandBSNum,1);


% Blind BSCs 真实站址选取

for BBSid=1:1:BlinBSNum
    BBSs( BBSid ,id )=BBSid;
    BBSs( BBSid ,xpos:ypos )=100*rand(1,2);
    for checkid=1:1:BBSid-1
        while min(min( sqrt((repmat(BBSs( BBSid,xpos),checkid,1)-BBSs(1:checkid,xpos)).^2+(repmat(BBSs( BBSid,ypos),checkid,1)-BBSs(1:checkid,ypos)).^2 ) ))<BlinBSspace || ...
        min(min(sqrt((repmat(BBSs( BBSid,xpos),LandBSNum,1)-LBSs(: , xpos )).^2+(repmat(BBSs( BBSid,ypos),LandBSNum,1)-LBSs(: , ypos )).^2)))<BlinBSspace
        
            BBSs( BBSid,xpos:ypos)=100*rand(1,2);
        end
    end
end

BBSs(:,flag)=zeros(BlinBSNum,1);



% 组装要广播的基站系统信息
LBSbroadinfo(:,id:ypos)=LBSs;BBSbroadinfo(:,id:ypos)=BBSs;

% Landmark BSC 与 Blind BSC headings角设定
LBSbroadinfo(:,headings)=(rand(LandBSNum,1)-0.5)*360;
BBSbroadinfo(:,headings)=(rand(BlinBSNum,1)-0.5)*360;


% ******************************需要的变量*********************************

% Landmark基站集合赋值
LBS3broadinfo=LBSbroadinfo(1:(LandBSNum-1),:);
LBS4broadinfo=LBSbroadinfo;
LBS3plus1broadinfo=LBSbroadinfo;

% TrueBlinBSpos 记录Blind BSC真实值
TrueBlinBSpos=BBSbroadinfo;
LBS3BBSbroadinfo=BBSbroadinfo;
LBS4BBSbroadinfo=BBSbroadinfo;
LBS3plus1BBSbroadinfo=BBSbroadinfo;

% Blind BSC 测量各Landmark BSC的真实辐角   Blind BSC以估计坐标为参照测量各个Landmark BSC的辐角
Realangle=ones(1,LandBSNum); Falseangle=ones(1,LandBSNum);   

% ******************************计算过程***********************************
% 3 landmark BSC
for i=1:1:BlinBSNum
    
    % Landmark BSC给出估计值
    iBSxy=LBS3BBSbroadinfo(i,xpos:ypos);
    
    LBS3broadinfo(:,angle)=generangle( iBSxy , LBS3broadinfo);
    [estimX,estimY,BSbanned]=lslocation( LBS3broadinfo );
    LBS3BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
    
    for landind=1:1:(LandBSNum-1)
        Realangle(1,landind)= generangle( LBS3broadinfo(landind,xpos:ypos), TrueBlinBSpos(i,:) );
        Falseangle(1,landind)= generangle( LBS3broadinfo(landind,xpos:ypos), LBS3BBSbroadinfo(i,:) );
    end
    
    % Adjust the position
     counter=1;
     while max(mod(Realangle-Falseangle,360)>0)==1 && counter<LandBSNum*360
           innerind=find(mod(Realangle-Falseangle,360)>0 ,1 ,'first');
           if (Realangle(1,innerind)-Falseangle(1,innerind))>180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)-360;    
           elseif (Realangle(1,innerind)-Falseangle(1,innerind))<-180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)+360;
           else

                theta=Realangle(1,innerind)-Falseangle(1,innerind);  
           end 
           vector=[estimX-LBS3broadinfo(innerind,xpos) ,estimY-LBS3broadinfo(innerind,ypos)];
           newvec=([ cos(0.1*theta*pi/180/abs(theta)) ,-sin(0.1*theta*pi/180/abs(theta)); sin(0.1*theta*pi/180/abs(theta)),cos(0.1*theta*pi/180/abs(theta))]*vector')';
           estimX=newvec(1,1)+LBS3broadinfo(innerind,xpos);estimY=newvec(1,2)+LBS3broadinfo(innerind,ypos);
           
           LBS3BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
           
           for landind=1:1:(LandBSNum-1)
                Falseangle(1,landind)= generangle( LBS3broadinfo(landind,xpos:ypos), LBS3BBSbroadinfo(i,:) );
           end
           counter=counter+1;  
     end

end
tmp3BS=sqrt((LBS3BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(LBS3BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2);%%%%
LBS3meanerror= mean(sqrt((LBS3BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(LBS3BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2));

% 3 landmark +1 landmark
for i=1:1:BlinBSNum
    
    % Landmark BSC给出估计值
    iBSxy=LBS4BBSbroadinfo(i,xpos:ypos);
    
    LBS4broadinfo(:,angle)=generangle( iBSxy , LBS4broadinfo);
    [estimX,estimY,BSbanned]=lslocation( LBS4broadinfo );
    LBS4BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
    
    for landind=1:1:LandBSNum
        Realangle(1,landind)= generangle( LBS4broadinfo(landind,xpos:ypos), TrueBlinBSpos(i,:) );
        Falseangle(1,landind)= generangle( LBS4broadinfo(landind,xpos:ypos), LBS4BBSbroadinfo(i,:) );
    end
    
    % Adjust the position
     counter=1;   
     while max(mod(Realangle-Falseangle,360)>0)==1 && counter<LandBSNum*3600
           innerind=find(mod(Realangle-Falseangle,360)>0 ,1 ,'first');
           if (Realangle(1,innerind)-Falseangle(1,innerind))>180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)-360;    
           elseif (Realangle(1,innerind)-Falseangle(1,innerind))<-180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)+360;
           else

                theta=Realangle(1,innerind)-Falseangle(1,innerind);  
           end 
           vector=[estimX-LBS4broadinfo(innerind,xpos) ,estimY-LBS4broadinfo(innerind,ypos)];
           newvec=([ cos(0.1*theta*pi/180/abs(theta)) ,-sin(0.1*theta*pi/180/abs(theta)); sin(0.1*theta*pi/180/abs(theta)),cos(0.1*theta*pi/180/abs(theta))]*vector')';
           estimX=newvec(1,1)+LBS4broadinfo(innerind,xpos);estimY=newvec(1,2)+LBS4broadinfo(innerind,ypos);
           
           LBS4BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
           
           for landind=1:1:LandBSNum
                Falseangle(1,landind)= generangle( LBS4broadinfo(landind,xpos:ypos), LBS4BBSbroadinfo(i,:) );
           end
           counter=counter+1;     
     end
     
end
tmp4BS=sqrt((LBS4BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(LBS4BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2);%%%%
LBS4meanerror= mean(sqrt((LBS4BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(LBS4BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2));

% 3 landmark + 1 noisy landmark
% 在其中一个landmark BSC中掺入噪声(由于是随机定址，选最后一个就行了)
final3plus1error=0;
for errind=1:1:100
percent=0.02;
errorampli=Aerawidth*percent;
NoisLandxy=[LBS3plus1broadinfo(LandBSNum,xpos)+errorampli*sin(2*pi*rand(1,1)),LBS3plus1broadinfo(LandBSNum,ypos)+errorampli*cos(2*pi*rand(1,1))];
NoisLBS3plus1broadinfo=LBS3plus1broadinfo; NoisLBS3plus1broadinfo(LandBSNum,xpos:ypos)=NoisLandxy;


for i=1:1:BlinBSNum
    
    % Landmark BSC给出估计值
    iBSxy=LBS3plus1BBSbroadinfo(i,xpos:ypos);
    
    NoisLBS3plus1broadinfo(:,angle)=generangle( iBSxy , LBS3plus1broadinfo);
    [estimX,estimY,BSbanned]=lslocation( NoisLBS3plus1broadinfo );
    LBS3plus1BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
    
    for landind=1:1:LandBSNum
        Realangle(1,landind)= generangle( LBS3plus1broadinfo(landind,xpos:ypos), TrueBlinBSpos(i,:) );
        Falseangle(1,landind)= generangle( NoisLBS3plus1broadinfo(landind,xpos:ypos), LBS3plus1BBSbroadinfo(i,:) );
    end
    
    % Adjust the position
     counter=1;   
     while max(mod(Realangle-Falseangle,360)>0)==1 && counter<LandBSNum*3600
           innerind=find(mod(Realangle-Falseangle,360)>0 ,1 ,'first');
           if (Realangle(1,innerind)-Falseangle(1,innerind))>180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)-360;    
           elseif (Realangle(1,innerind)-Falseangle(1,innerind))<-180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)+360;
           else

                theta=Realangle(1,innerind)-Falseangle(1,innerind);  
           end 
           vector=[estimX-LBS3plus1broadinfo(innerind,xpos) ,estimY-LBS3plus1broadinfo(innerind,ypos)];
           newvec=([ cos(0.1*theta*pi/180/abs(theta)) ,-sin(0.1*theta*pi/180/abs(theta)); sin(0.1*theta*pi/180/abs(theta)),cos(0.1*theta*pi/180/abs(theta))]*vector')';
           estimX=newvec(1,1)+LBS3plus1broadinfo(innerind,xpos);estimY=newvec(1,2)+LBS3plus1broadinfo(innerind,ypos);
           
           LBS3plus1BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
           
           for landind=1:1:LandBSNum
                Falseangle(1,landind)= generangle( NoisLBS3plus1broadinfo(landind,xpos:ypos), LBS3plus1BBSbroadinfo(i,:) );
           end
           counter=counter+1;      
     end
     
end
onetime3plus1=sqrt((LBS3plus1BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(LBS3plus1BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2);%%%%
LBS3plus1meanerror= mean(sqrt((LBS3plus1BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(LBS3plus1BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2));
final3plus1error=final3plus1error+LBS3plus1meanerror;
end
final3plus1error=final3plus1error/100;


