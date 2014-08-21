% �ó���λ����Ϊ3��Landmark��վ 10��Blind��վ
% 2014 08 17 16:12 ȷ��վַ�����������min������ȥ��min����ֻȡ����min��bug
% 2014 08 20 10:17 ����3Landmark BSC��λ10 Blind BSC ����˷�������


% ***************************��ʼ��������(��ʼ)*****************************

% ��λ�����С landmark��վ��Ŀ  blind��վ��Ŀ
Aerawidth=100; LandBSNum=3;BlinBSNum=100;

% ���ѡȡ��վʱ��վ��ľ���
LandBSspace=50;BlinBSspace=0;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��վ�㲥����Ϣ�趨
% BSbroadinfo 1:id 2:flag( Landmark/Blind )  3:xposition  4:yposition 5:headings 6:angle  
id=1; flag=2; xpos=3; ypos=4; headings=5; angle=6;  
LBSbroadinfo=zeros(LandBSNum,6);BBSbroadinfo=zeros(BlinBSNum,6);

% ��վ��Ϣ�趨 
LBSs=zeros( LandBSNum , 4 );BBSs=zeros(BlinBSNum ,4);

loopNum=100;errordat=zeros(1,BlinBSNum);
for looper=1:1:loopNum

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
        while min(min( sqrt((repmat(BBSs( BBSid,xpos),checkid,1)-BBSs(1:checkid,xpos)).^2+(repmat(BBSs( BBSid,ypos),checkid,1)-BBSs(1:checkid,ypos)).^2 ) ))<BlinBSspace&& ...
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

% ******************************�������***********************************


for i=1:1:BlinBSNum
    
    iBSxy=BBSbroadinfo(i,xpos:ypos);
    
    LBSbroadinfo(:,angle)=generangle( iBSxy , LBSbroadinfo);
    [estimX,estimY,BSbanned]=lslocation( LBSbroadinfo );
        
    % Adjust the position
    
    flags=ones(1,LandBSNum);tmpangle=generangle( [estimX,estimY] , LBSbroadinfo);
    tmpindex=1;
    while max(flags)==1
  
        % Landmark BSC������������
            while max(mod(LBSbroadinfo(1:tmpindex,angle)-tmpangle(1:tmpindex,1),360)>0)==1 
                
                innerind=find(mod(LBSbroadinfo(1:tmpindex,angle)-tmpangle(1:tmpindex,1),360)>0 ,1 ,'first');
                % ����heading�ǲ���ʱ��180�ȴ����������� ����mod����ȥ��theta=-360��360�����   
                if (LBSbroadinfo(innerind,angle)-tmpangle(innerind,1))>180
                    
                    theta=LBSbroadinfo(innerind,angle)-tmpangle(innerind,1)-360;    
                elseif (LBSbroadinfo(innerind,angle)-tmpangle(innerind,1))<-180
                    
                    theta=LBSbroadinfo(innerind,angle)-tmpangle(innerind,1)+360;
                else
                    
                    theta=LBSbroadinfo(innerind,angle)-tmpangle(innerind,1);  
                end 
                
                vector=[estimX-LBSbroadinfo(innerind,xpos) ,estimY-LBSbroadinfo(innerind,ypos)];
                newvec=([ cos(0.1*theta*pi/180/abs(theta)) ,-sin(0.1*theta*pi/180/abs(theta)); sin(0.1*theta*pi/180/abs(theta)),cos(0.1*theta*pi/180/abs(theta))]*vector')';
                estimX=newvec(1,1)+LBSbroadinfo(innerind,xpos);estimY=newvec(1,2)+LBSbroadinfo(innerind,ypos);
                tmpangle=generangle( [estimX,estimY] , LBSbroadinfo); 
            end
                
    
            flags(1,tmpindex)=0;
            tmpindex=tmpindex+1;
    end
    BBSbroadinfo(i,xpos:ypos)=[estimX,estimY];
    
end

errordat=errordat+(sqrt( (BBSbroadinfo(:,xpos)-TrueBlinBSpos(:,xpos)).^2+(BBSbroadinfo(:,ypos)-TrueBlinBSpos(:,ypos)).^2 ))';

end
errordat=errordat/loopNum;
meanError=mean(errordat);
