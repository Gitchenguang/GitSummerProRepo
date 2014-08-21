% 本程序只计算定位网格中心点的误差,定位范围为50m*50m的区域

% 首先对区域划分网格
Aerawidth=70;
step=0.5;Axy=[0,Aerawidth];Bxy=[0,0];Cxy=[Aerawidth,0];
meaerror=zeros(1,(Aerawidth/step).^2);
index=1;

for i=step/2:step:(Aerawidth-step/2)
    for j=step/2:step:(Aerawidth-step/2)
    % 在这两个循环里计算网格中心点定位的平均误差、最大误差
        xy(1,1)=i;xy(1,2)=j;
        [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy);
        [ setX,setY]=filterpoints( thetaA,thetaB,thetaC,Axy,Bxy,Cxy);
        estimXY(1,1)= sum(setX)/length(setX); %算是加权均值
        estimXY(1,2)= sum(setY)/length(setY);
        
    % 找到了估计值，接下来为计算平均误差、最大误差记录数据，计算偏差距离
        meaerror(index)=sqrt( sum((xy-estimXY).^2) );
        index=index+1;
    end
end

errorMax=max( meaerror );
errorMean=mean( meaerror);
meapic=zeros( Aerawidth/step,Aerawidth/step);
for i=1:1:Aerawidth/step
    meapic(:,i)=meaerror( ((i-1)*Aerawidth/step+1):i*Aerawidth/step);
end
