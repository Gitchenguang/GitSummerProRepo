% 该程序定位环境为3个Landmark基站 10个Blind基站
% 2014 08 17 16:12 确定站址处添加了两个min函数以去除min函数只取得列min的bug
% 2014 08 20 10:17 
% 2014 08 21 10:14 将此脚本改为在Blind BSC自身修正自身位置
% 2014 08 23 10:31 此脚本改为获得3landmark、3land+1approximatelyland、3land+1landmark
% 2014 08 25 20:15 修复Blind BSC选址间距问题 逻辑改为由 && 改为 ||


% （processing....）
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
Aerawidth=100; LandBSNum=4;BlinBSNum=50;

% 随机选取基站时基站间的距离
LandBSspace=40;BlinBSspace=10;

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

% TrueBlinBSpos 记录Blind BSC真实值
TrueBlinBSpos=BBSbroadinfo;
% Blind BSC 测量各Landmark BSC的真实辐角   Blind BSC以估计坐标为参照测量各个Landmark BSC的辐角
Realangle=ones(1,LandBSNum); Falseangle=ones(1,LandBSNum);   
% 记录bearing角度差的和的变量
AngleDiff=zeros(1,BlinBSNum);
% 记录Blind BSC距离误差的变量
BlindDiff=zeros(1,BlinBSNum);

% ******************************计算过程***********************************

% 在其中一个landmark BSC中掺入噪声(由于是随机定址，选第一个就行了)
percent=0.0;
errorampli=Aerawidth*percent;
NoisLandxy=[LBSbroadinfo(1,xpos)+errorampli*sin(2*pi*rand(1,1)),LBSbroadinfo(1,ypos)+errorampli*cos(2*pi*rand(1,1))];
NoisLBSbroadinfo=LBSbroadinfo; NoisLBSbroadinfo(1,xpos:ypos)=NoisLandxy;

for i=1:1:BlinBSNum
    
    % Landmark BSC给出估计值
    iBSxy=BBSbroadinfo(i,xpos:ypos);
    
    NoisLBSbroadinfo(:,angle)=generangle( iBSxy , LBSbroadinfo);
    [estimX,estimY,BSbanned]=lslocation( NoisLBSbroadinfo );
    BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
    
    for landind=1:1:LandBSNum
        Realangle(1,landind)= generangle( LBSbroadinfo(landind,xpos:ypos), TrueBlinBSpos(i,:) );
        Falseangle(1,landind)= generangle( NoisLBSbroadinfo(landind,xpos:ypos), BBSbroadinfo(i,:) );
    end
    
    % Adjust the position

    %
    FinalbearingToLBS=zeros(1,LandBSNum);
        
     while max(mod(Realangle-Falseangle,360)>0)==1 
           innerind=find(mod(Realangle-Falseangle,360)>0 ,1 ,'first');
           if (Realangle(1,innerind)-Falseangle(1,innerind))>180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)-360;    
           elseif (Realangle(1,innerind)-Falseangle(1,innerind))<-180

               theta=Realangle(1,innerind)-Falseangle(1,innerind)+360;
           else

                theta=Realangle(1,innerind)-Falseangle(1,innerind);  
           end 
           vector=[estimX-LBSbroadinfo(innerind,xpos) ,estimY-LBSbroadinfo(innerind,ypos)];
           newvec=([ cos(0.1*theta*pi/180/abs(theta)) ,-sin(0.1*theta*pi/180/abs(theta)); sin(0.1*theta*pi/180/abs(theta)),cos(0.1*theta*pi/180/abs(theta))]*vector')';
           estimX=newvec(1,1)+LBSbroadinfo(innerind,xpos);estimY=newvec(1,2)+LBSbroadinfo(innerind,ypos);
           
           BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
           
           for landind=1:1:LandBSNum
                Falseangle(1,landind)= generangle( NoisLBSbroadinfo(landind,xpos:ypos), BBSbroadinfo(i,:) );
           end
                
     end
    
     % *-*对误差信息进行一下统计
     % Distance
     BlindDiff(1,i)=sqrt((BBSbroadinfo(i,xpos)-TrueBlinBSpos(i,xpos)).^2+(BBSbroadinfo(i,ypos)-TrueBlinBSpos(i,ypos)).^2);
     
     % Angle
     %for landind=1:1:LandBSNum
     %      FinalbearingToLBS(1,landind)= generangle( LBSbroadinfo(landind,xpos:ypos), BBSbroadinfo(i,:) );
     %end
     %FinalbearingToLBS=sort(FinalbearingToLBS);
     %tmp=FinalbearingToLBS(1,1);
     %FinalbearingToLBS(1,(1:LandBSNum-1))=FinalbearingToLBS(1,2:LandBSNum)-FinalbearingToLBS(1,1:LandBSNum-1);
     %FinalbearingToLBS(1,LandBSNum)=tmp-FinalbearingToLBS(1,1);%
     %AngleDiff(1,i)=sum(FinalbearingToLBS);
  
end

meanerror= mean(sqrt((BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2));
meanmin= min(sqrt((BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2));




