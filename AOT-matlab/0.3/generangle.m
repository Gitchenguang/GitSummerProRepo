function [ thetaA,thetaB,thetaC,thetaD,thetaE,thetaF]=generangle(xy,Axy,Bxy,Cxy,Dxy,Exy,Fxy)
% [ thetaA,thetaB,thetaC,thetaD,thetaE,thetaF]=generangle(xy,Axy,Bxy,Cxy,Dxy,Exy,Fxy)
% �˺�����unknown nodes ������Ϊ���룬����ĵ������A,B,C������ĸ���
% �˺�����Ϊ�˼���AOT�ļ�������д�ĸ�������

% ����A�㣬���ȼ�������AU�ķ��� UΪδ֪�㣬Ȼ�����A��������ļн�
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



    


