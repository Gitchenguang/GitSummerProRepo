% ������ֻ���㶨λ�������ĵ�����,��λ��ΧΪ�߳�Ϊ50m��������������

% ���ȶ����򻮷�����

step=0.5;R=50;len=round(50*sqrt(3)/2);
Axy=[0,0];Bxy=[2*len,0];Cxy=[len,1.5*R];

[ X,Y]=pointsset(step,Axy,Bxy,Cxy);

num=length(X);
meaerror=zeros(1,num);

for i=1:1:num
    
    xy(1,1)=X(i);xy(1,2)=Y(i);
    [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy);
    [Xpset,Ypset]=pointsset(0.5,Axy,Bxy,Cxy);
    [setX,setY]=filterpoints(Xpset,Ypset,thetaA,thetaB,thetaC,Axy,Bxy,Cxy);
    estimXY(1,1)= sum(setX)/length(setX); 
    estimXY(1,2)= sum(setY)/length(setY);
    estimX(i)=estimXY(1,1);estimY(i)=estimXY(1,2);
    meaerror(i)=sqrt( sum((xy-estimXY).^2) );
end

errorMax=max( meaerror );
errorMean=mean( meaerror);

meapic=zeros( len/step ,len/step);
i=1;
while i<=length(X)
    xind=(X(i)+step/2)/step;
    yind=(Y(i)+step/2)/step;
    meapic(yind,xind)=meaerror(i);
    i=i+1;
end






