function [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy)
% [ thetaA,thetaB,thetaC,thetaD,thetaE,thetaF]=generangle(xy,Axy,Bxy,Cxy,Dxy,Exy,Fxy)
% �˺�����unknown nodes ������Ϊ���룬����ĵ������A,B,C������ĸ���
% �˺�����Ϊ�˼���AOT�ļ�������д�ĸ�������

% ����A�㣬���ȼ�������AU�ķ��� UΪδ֪�㣬Ȼ�����A��������ļн�
AU=xy-Axy;
angleA=quanangle(AU);
thetaA=angleA-90;

BU=xy-Bxy;
thetaB=quanangle(BU)+90;

CU=xy-Cxy;
angleC=quanangle(CU);
if angleC>0
    thetaC=angleC+90;
else
    thetaC=angleC-90;
end



    


