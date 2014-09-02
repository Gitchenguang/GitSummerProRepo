% �ó���λ����Ϊ3��Landmark��վ 10��Blind��վ
% 2014 08 17 16:12 ȷ��վַ�����������min������ȥ��min����ֻȡ����min��bug
% 2014 08 20 10:17 
% 2014 08 21 10:14 ���˽ű���Ϊ��Blind BSC������������λ��
% 2014 08 23 10:31 �˽ű���Ϊ���3landmark��3land+1approximatelyland��3land+1landmark
% 2014 08 25 20:15 �޸�Blind BSCѡַ������� �߼���Ϊ�� && ��Ϊ ||


% ��processing....��
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
Aerawidth=100; LandBSNum=4;BlinBSNum=50;

% ���ѡȡ��վʱ��վ��ľ���
LandBSspace=40;BlinBSspace=10;

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

% TrueBlinBSpos ��¼Blind BSC��ʵֵ
TrueBlinBSpos=BBSbroadinfo;
% Blind BSC ������Landmark BSC����ʵ����   Blind BSC�Թ�������Ϊ���ղ�������Landmark BSC�ķ���
Realangle=ones(1,LandBSNum); Falseangle=ones(1,LandBSNum);   
% ��¼bearing�ǶȲ�ĺ͵ı���
AngleDiff=zeros(1,BlinBSNum);
% ��¼Blind BSC�������ı���
BlindDiff=zeros(1,BlinBSNum);

% ******************************�������***********************************

% ������һ��landmark BSC�в�������(�����������ַ��ѡ��һ��������)
percent=0.0;
errorampli=Aerawidth*percent;
NoisLandxy=[LBSbroadinfo(1,xpos)+errorampli*sin(2*pi*rand(1,1)),LBSbroadinfo(1,ypos)+errorampli*cos(2*pi*rand(1,1))];
NoisLBSbroadinfo=LBSbroadinfo; NoisLBSbroadinfo(1,xpos:ypos)=NoisLandxy;

for i=1:1:BlinBSNum
    
    % Landmark BSC��������ֵ
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
    
     % *-*�������Ϣ����һ��ͳ��
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




