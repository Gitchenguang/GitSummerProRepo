function [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy)
% [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy)
% 此函数以unknown nodes 的坐标为输入，输出改点相对于A,B,C量化后的俯角
% 此函数是为了计算AOT的计算误差而写的辅助函数

% 对于A点，首先计算向量AU的辐角 U为未知点，然后换算成A关于纵轴的夹角
AU=xy-Axy;
thetaA=quanangle(AU)-90;

BU=xy-Bxy;
thetaB=quanangle(BU)-90;

CU=xy-Cxy;
thetaC=180+quanangle(CU)-90;

    


