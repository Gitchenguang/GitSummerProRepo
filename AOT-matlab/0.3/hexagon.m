% 本程序只计算定位网格中心点的误差,定位范围为边长为50m的正六边形区域

% 首先对区域划分网格

step=0.5;len=50;
Axy=[0,len/2*sqrt(3)];Bxy=[len/2,0];Cxy=[len*1.5,0];Dxy=[len*2,len/2*sqrt(3)];Exy=[ len*1.5,len*sqrt(3)];Fxy=[ len/2,len*sqrt(3)];

[ X,Y]=pointsset(step,Axy,Bxy,Cxy,Dxy,Exy,Fxy);

num=length(X);
meaerror=zeros(1,num);

for i=1:1:num
    
    xy(1,1)=X(i);xy(1,2)=Y(i);
    [ thetaA,thetaB,thetaC,thetaD,thetaE,thetaF]=generangle(xy,Axy,Bxy,Cxy,Dxy,Exy,Fxy);
    [Xpset,Ypset]=pointsset(0.5,Axy,Bxy,Cxy,Dxy,Exy,Fxy);
    [setX,setY]=filterpoints(Xpset,Ypset,thetaA,thetaB,thetaC,thetaD,thetaE,thetaF,Axy,Bxy,Cxy,Dxy,Exy,Fxy);
    estimXY(1,1)= sum(setX)/length(setX); 
    estimXY(1,2)= sum(setY)/length(setY);
    estimX(i)=estimXY(1,1);estimY(i)=estimXY(1,2);
    meaerror(i)=sqrt( sum((xy-estimXY).^2) );
end

errorMax=max( meaerror );
errorMean=mean( meaerror);

meapic=zeros( 2*len/step ,2*len/step);
i=1;
while i<=length(X)
    xind=(X(i)+step/2)/step;
    yind=(Y(i)+step/2)/step;
    meapic(yind,xind)=meaerror(i);
    i=i+1;
end






