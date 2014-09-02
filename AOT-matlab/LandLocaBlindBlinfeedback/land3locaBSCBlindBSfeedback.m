% �ó���λ����Ϊ3��Landmark��վ 10��Blind��վ
% 2014 08 17 16:12 ȷ��վַ�����������min������ȥ��min����ֻȡ����min��bug
% 2014 08 20 10:17 
% 2014 08 21 10:14 ���˽ű���Ϊ��Blind BSC������������λ��
% 2014 08 23 10:31 �˽ű���Ϊ���3landmark��3land+1approximatelyland��3land+1landmark
% 2014 08 25 20:15 �޸�Blind BSCѡַ������� �߼���Ϊ�� && ��Ϊ ||


% ʵ������ʱ�����޽�����
%  �����޸��У���ʱע������������Landmark BSC��λʱҪע��ʹ������ʵ���������
% ��������Rules��
% 1��ֱ��
%       ������ = Real landmark BSC position
%       ���   = Noisy landmark BSC position 
% 2���ز�
%       Realangle = Real landmark BSC angle + Real Blind BSC position
%       Flaseangle= Noisy landmark BSC angle+ Estimed Blind BSC position



% ***************************��ʼ��������(��ʼ)*****************************

% ��λ�����С landmark��վ��Ŀ  blind��վ��Ŀ
Aerawidth=100; LandBSNum=4;BlinBSNum=100;

% ���ѡȡ��վʱ��վ��ľ���
LandBSspace=50;BlinBSspace=5;

% ��վ�㲥����Ϣ�趨
% BSbroadinfo 1:id 2:flag( Landmark/Blind )  3:xposition  4:yposition 5:headings 6:angle  
id=1; flag=2; xpos=3; ypos=4; headings=5; angle=6;  
LBSbroadinfo=zeros(LandBSNum,6);BBSbroadinfo=zeros(BlinBSNum,6);

% ��վ��Ϣ�趨 
LBSs=zeros( LandBSNum , 4 );BBSs=zeros(BlinBSNum ,4);

% Landmark BSCsվַѡȡ
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


% Blind BSCs ��ʵվַѡȡ

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



% ��װҪ�㲥�Ļ�վϵͳ��Ϣ
LBSbroadinfo(:,id:ypos)=LBSs;BBSbroadinfo(:,id:ypos)=BBSs;

% Landmark BSC �� Blind BSC headings���趨
LBSbroadinfo(:,headings)=(rand(LandBSNum,1)-0.5)*360;
BBSbroadinfo(:,headings)=(rand(BlinBSNum,1)-0.5)*360;


% ******************************��Ҫ�ı���*********************************

% Landmark��վ���ϸ�ֵ
LBS3broadinfo=LBSbroadinfo(1:(LandBSNum-1),:);
LBS4broadinfo=LBSbroadinfo;
LBS3plus1broadinfo=LBSbroadinfo;

% TrueBlinBSpos ��¼Blind BSC��ʵֵ
TrueBlinBSpos=BBSbroadinfo;
LBS3BBSbroadinfo=BBSbroadinfo;
LBS4BBSbroadinfo=BBSbroadinfo;
LBS3plus1BBSbroadinfo=BBSbroadinfo;

% Blind BSC ������Landmark BSC����ʵ����   Blind BSC�Թ�������Ϊ���ղ�������Landmark BSC�ķ���
Realangle=ones(1,LandBSNum); Falseangle=ones(1,LandBSNum);   

% ******************************�������***********************************
% 3 landmark BSC
for i=1:1:BlinBSNum
    
    % Landmark BSC��������ֵ
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
    
    % Landmark BSC��������ֵ
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
% ������һ��landmark BSC�в�������(�����������ַ��ѡ���һ��������)
final3plus1error=0;
for errind=1:1:100
percent=0.02;
errorampli=Aerawidth*percent;
NoisLandxy=[LBS3plus1broadinfo(LandBSNum,xpos)+errorampli*sin(2*pi*rand(1,1)),LBS3plus1broadinfo(LandBSNum,ypos)+errorampli*cos(2*pi*rand(1,1))];
NoisLBS3plus1broadinfo=LBS3plus1broadinfo; NoisLBS3plus1broadinfo(LandBSNum,xpos:ypos)=NoisLandxy;


for i=1:1:BlinBSNum
    
    % Landmark BSC��������ֵ
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


