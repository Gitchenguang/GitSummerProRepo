% �ó���λ����Ϊ3��Landmark��վ 10��Blind��վ
% 2014 08 17 16:12 ȷ��վַ�����������min������ȥ��min����ֻȡ����min��bug
% 2014 08 20 10:34 ���ĵ���ʱ��δʹ����ʵ����Ĵ���( Line 114)

% ***************************��ʼ��������(��ʼ)*****************************

% ��λ�����С landmark��վ��Ŀ  blind��վ��Ŀ
Aerawidth=100; LandBSNum=3;BlinBSNum=10;

% ���ѡȡ��վʱ��վ��ľ���
LandBSspace=50;BlinBSspace=10;

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

% loopNum Ϊ�������µĴ���
loopNum=10;

% BlindBSpos�������ÿ�ε������º󣬸�����վ�����ꡣ�����������������������������
% ��վ��id
BlinBSpos=zeros(loopNum+1,BlinBSNum*2);


% ******************************�������***********************************

% ��������Land mark BSC��Blind BSC����
for i=1:1:BlinBSNum
    
    iBSxy=BBSbroadinfo(i,xpos:ypos);
    
    LBSbroadinfo(:,angle)=generangle( iBSxy , LBSbroadinfo);
    [estimX,estimY,BSbanned]=lslocation( LBSbroadinfo );
    
    xy=[estimX,estimY];
    
    BBSbroadinfo(i,xpos:ypos)=xy;
    
end

% ��¼������Landmark BSC ���� Blind BSC��Blind BSC������
LandlocaBlinBSinfo=BBSbroadinfo;
BlinBSpos( 1 ,:)=[(LandlocaBlinBSinfo(:,xpos))',(LandlocaBlinBSinfo(:,ypos))'];


% ��ʼloopNum�εĵ�������

for ind=1:1:loopNum
    
    % ��ɶ�10��Blind BSC��һ��λ����Ϣ����
    for i=1:1:BlinBSNum
        
        % �õ�Blind BSC����Ϣ
        iBSxy=BBSbroadinfo(i,xpos:ypos);
        tmpBSbroadinfo=BBSbroadinfo;
        tmpTruepos=TrueBlinBSpos;
        % �޳�tmpBSbroadinfo��Ҫ��λ��Blind BSC����Ϣ,�޳�BlinBSC��ʵվַ��ϢtmpTruepos�е��ض���Ϣ
        tmpBSbroadinfo(i,:)=[];
        tmpTruepos(i,:)=[];
        % ʣ���վ������Blind BSC���з��Ƕ�λ
        LBSbroadinfo(:,angle)=generangle( iBSxy , LBSbroadinfo);
        tmpBSbroadinfo(:,angle)=generangle( iBSxy , tmpTruepos);% 
        
        % ���� Landmark BSC ��ʣ��Blind BSC�ķ��Ƕ�λ��Ϣ
        mergeBSbroadinfo=[LBSbroadinfo;tmpBSbroadinfo];
        
        % ��������λ��Blind BSC��λ��
        [estimX,estimY,BSbanned]=lslocation( mergeBSbroadinfo );
        xy=[estimX,estimY];
        
        % ����Blind BSC���εĶ�λ������Ϣ��¼��BBSbroadinfo��
        BBSbroadinfo(i,xpos:ypos)=xy;
    end
    
    % ��¼10��Blind BSCһ�ָ��º��λ��
    BlinBSpos( ind+1 ,:)=[(BBSbroadinfo(:,xpos))',(BBSbroadinfo(:,ypos))'];
    
end

errordat=zeros(loopNum+1,BlinBSNum);
for i=1:1:BlinBSNum
    errordat(:,i)=(sqrt((BlinBSpos(:,i)-TrueBlinBSpos(i,xpos)).^2+(BlinBSpos(:,i+BlinBSNum)-TrueBlinBSpos(i,ypos)).^2));
end



















