function [ thetaA,thetaB,thetaC,thetaD,thetaE,thetaF]=generangle(xy,Axy,Bxy,Cxy,Dxy,Exy,Fxy)
% [ thetaA,thetaB,thetaC,thetaD,thetaE,thetaF]=generangle(xy,Axy,Bxy,Cxy,Dxy,Exy,Fxy)
% 此函数以unknown nodes 的坐标为输入，输出改点相对于A,B,C量化后的俯角
% 此函数是为了计算AOT的计算误差而写的辅助函数

% 对于A点，首先计算向量AU的辐角 U为未知点，然后换算成A关于纵轴的夹角
AU=xy-Axy;
angleA=quanangle(AU);
thetaA=angleA-90;

BU=xy-Bxy;
angleB=quanangle(BU);
if angleB>=0
    thetaB=angleB-90;
else
    thetaB=angleB+90;
end

CU=xy-Cxy;
angleC=quanangle(CU);
if angleC>0
    angleC=quanangle(CU);
    thetaC=angleC-90;
else
    thetaC=angleC+90;
end

DU=xy-Dxy;
angleD=quanangle(DU);
thetaD=angleD+90;

EU=xy-Exy;
angleE=quanangle(EU);
if angleE>=0
    thetaE=angleE+90;
else
    thetaE=angleE-90;
end


FU=xy-Fxy;
angleF=quanangle(FU);
if angleF<=0
    thetaF=angleF-90;
else
    thetaF=angleF+90;
end



    


