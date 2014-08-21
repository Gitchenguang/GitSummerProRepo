% 该程序定位环境为3个Landmark基站 10个Blind基站
% 2014 08 17 16:12 确定站址处添加了两个min函数以去除min函数只取得列min的bug
% 2014 08 20 10:34 更改迭代时，未使用真实坐标的错误( Line 114)

% ***************************初始环境设置(开始)*****************************

% 定位区域大小 landmark基站数目  blind基站数目
Aerawidth=100; LandBSNum=3;BlinBSNum=10;

% 随机选取基站时基站间的距离
LandBSspace=50;BlinBSspace=10;

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
        while min(min( sqrt((repmat(BBSs( BBSid,xpos),checkid,1)-BBSs(1:checkid,xpos)).^2+(repmat(BBSs( BBSid,ypos),checkid,1)-BBSs(1:checkid,ypos)).^2 ) ))<BlinBSspace&& ...
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

% loopNum 为迭代更新的次数
loopNum=10;

% BlindBSpos用来存放每次迭代更新后，各个基站的坐标。行索引代表迭代次数，列索引代表
% 基站的id
BlinBSpos=zeros(loopNum+1,BlinBSNum*2);


% ******************************计算过程***********************************

% 第零轮用Land mark BSC对Blind BSC定标
for i=1:1:BlinBSNum
    
    iBSxy=BBSbroadinfo(i,xpos:ypos);
    
    LBSbroadinfo(:,angle)=generangle( iBSxy , LBSbroadinfo);
    [estimX,estimY,BSbanned]=lslocation( LBSbroadinfo );
    
    xy=[estimX,estimY];
    
    BBSbroadinfo(i,xpos:ypos)=xy;
    
end

% 记录初次用Landmark BSC 估计 Blind BSC后Blind BSC的坐标
LandlocaBlinBSinfo=BBSbroadinfo;
BlinBSpos( 1 ,:)=[(LandlocaBlinBSinfo(:,xpos))',(LandlocaBlinBSinfo(:,ypos))'];


% 开始loopNum次的迭代过程

for ind=1:1:loopNum
    
    % 完成对10个Blind BSC的一轮位置信息更新
    for i=1:1:BlinBSNum
        
        % 得到Blind BSC的信息
        iBSxy=BBSbroadinfo(i,xpos:ypos);
        tmpBSbroadinfo=BBSbroadinfo;
        tmpTruepos=TrueBlinBSpos;
        % 剔除tmpBSbroadinfo中要定位的Blind BSC的信息,剔除BlinBSC真实站址信息tmpTruepos中的特定信息
        tmpBSbroadinfo(i,:)=[];
        tmpTruepos(i,:)=[];
        % 剩余基站对欲测Blind BSC进行辐角定位
        LBSbroadinfo(:,angle)=generangle( iBSxy , LBSbroadinfo);
        tmpBSbroadinfo(:,angle)=generangle( iBSxy , tmpTruepos);% 
        
        % 汇总 Landmark BSC 与剩余Blind BSC的辐角定位信息
        mergeBSbroadinfo=[LBSbroadinfo;tmpBSbroadinfo];
        
        % 估计欲定位的Blind BSC的位置
        [estimX,estimY,BSbanned]=lslocation( mergeBSbroadinfo );
        xy=[estimX,estimY];
        
        % 将该Blind BSC本次的定位估计信息记录到BBSbroadinfo中
        BBSbroadinfo(i,xpos:ypos)=xy;
    end
    
    % 记录10个Blind BSC一轮更新后的位置
    BlinBSpos( ind+1 ,:)=[(BBSbroadinfo(:,xpos))',(BBSbroadinfo(:,ypos))'];
    
end

errordat=zeros(loopNum+1,BlinBSNum);
for i=1:1:BlinBSNum
    errordat(:,i)=(sqrt((BlinBSpos(:,i)-TrueBlinBSpos(i,xpos)).^2+(BlinBSpos(:,i+BlinBSNum)-TrueBlinBSpos(i,ypos)).^2));
end



















