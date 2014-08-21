% 对BSC基站进行了loopnum次随机选址
% BSCs的间隔问题还没有更正
%*****************************************************************************
step=1;Aerawidth=100;loopnum=10;

% 基站定标
BSNum=3;
%基站与基站之间的最小距离为space=30m
space=10;

BSbroadinfo=zeros( BSNum ,5);

BSs=zeros( BSNum , 3);

meaerror=zeros(2,(Aerawidth/step)*(Aerawidth/step));
% 随机基站拓扑情况下 loopnum次
for ind=1:1:loopnum
    
for BSid=1:1:BSNum
    BSs(BSid,1)=BSid;
    BSs( BSid,2:3 )=100*rand( 1,2);
    for checkid=1:1:BSid-1     
        while min(sqrt(( repmat(BSs( BSid,2 ),checkid,1)-BSs( 1:checkid , 2 )).^2+( repmat(BSs( BSid,3 ),checkid,1)-BSs( 1:checkid , 3 )).^2 ))<space
            BSs( BSid,2:3 )=100*rand( 1,2);
       end
    end    
end


BSbroadinfo(:,1:3)=BSs;

% 组装BSbroadinfo的headings

BSbroadinfo(:,4)=(rand(BSNum,1)-0.5)*360;

tmperror=zeros(2,(Aerawidth/step)*(Aerawidth/step));

    index=1;
    for i=step/2:step:Aerawidth-step/2
        for j=step/2:step:Aerawidth-step/2

            % 计算各个BS的辐角
            BSbroadinfo(:,5)=generangle([i,j],BSbroadinfo);

            [estimAX,estimAY,ABSbanned]=lslocation( BSbroadinfo );
            [estimDX,estimDY,DBSbanned]=lslocationdistmax( BSbroadinfo );
            
            tmperror(1,index)=sqrt( (i-estimAX).^2+(j-estimAY).^2);
            tmperror(2,index)=sqrt( (i-estimDX).^2+(j-estimDY).^2);
            
            index=index+1;
        end
    end
    meaerror=tmperror+meaerror;
end

meaerror=meaerror/loopnum;
Ameamax=max(meaerror(1,:));
Ameamean=mean(meaerror(1,:));

Dmeamax=max(meaerror(2,:));
Dmeamean=mean(meaerror(2,:));

Ameapic=zeros( Aerawidth/step,Aerawidth/step);
Dmeapic=zeros( Aerawidth/step,Aerawidth/step);
for i=1:1:Aerawidth/step
    Ameapic(:,i)=meaerror(1, ((i-1)*Aerawidth/step+1):i*Aerawidth/step);
    Dmeapic(:,i)=meaerror(2, ((i-1)*Aerawidth/step+1):i*Aerawidth/step);
end

