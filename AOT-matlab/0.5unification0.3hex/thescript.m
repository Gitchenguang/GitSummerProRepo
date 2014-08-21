step=1;Aerawidth=50;
% 基站定标 
BS1=[0,Aerawidth/2*sqrt(3)];BS2=[Aerawidth/2,0];BS3=[1.5*Aerawidth,0];
BS4=[2*Aerawidth,Aerawidth/2*sqrt(3)];BS5=[1.5*Aerawidth,Aerawidth*sqrt(3)];BS6=[Aerawidth/2,Aerawidth*sqrt(3)];

BSNum=6;
loopnum=100;

% 组装BSbroadinfo
BSbroadinfo=zeros( BSNum ,5);
BSbroadinfo(1,1:3)=[ 1,BS1(1,1),BS1(1,2)];
BSbroadinfo(2,1:3)=[ 2,BS2(1,1),BS2(1,2)];
BSbroadinfo(3,1:3)=[ 3,BS3(1,1),BS3(1,2)];
BSbroadinfo(4,1:3)=[ 4,BS4(1,1),BS4(1,2)];
BSbroadinfo(5,1:3)=[ 5,BS5(1,1),BS5(1,2)];
BSbroadinfo(6,1:3)=[ 6,BS6(1,1),BS6(1,2)];

% 得到方格坐标
[Xpset,Ypset]=pointsset(step, BSbroadinfo );
pointnum=length(Xpset);
meaerror=zeros(1,pointnum);

for ind=1:1:loopnum

BSbroadinfo(:,4)=(rand(BSNum,1)-0.5)*360;

% 大循环，多测求平均
tmperror=zeros(1,pointnum);

    for index=1:1:pointnum
            % 计算各个BS的辐角
            BSbroadinfo(:,5)=generangle([Xpset(index),Ypset(index)],BSbroadinfo);

            [estimX,estimY,BSbanned]=lslocation( BSbroadinfo );
            tmperror(index)=sqrt( (Xpset(index)-estimX).^2+(Ypset(index)-estimY).^2);
    end
    meaerror=tmperror+meaerror;
end

meaerror=meaerror/loopnum;
meamax=max(meaerror);
meamean=mean(meaerror);
meapic=zeros( 2*Aerawidth/step ,2*Aerawidth/step);

for ind=1:1:length(meaerror)
    Xind=(Xpset(ind)+step/2)/step;
    Yind=(Ypset(ind)+step/2)/step;
    meapic(Yind,Xind)=meaerror(ind);
end
