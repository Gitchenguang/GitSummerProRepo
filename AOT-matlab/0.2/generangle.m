function [ thetaA,thetaB,thetaC,thetaD]=generangle(xy,Axy,Bxy,Cxy,Dxy)
% [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy)
% �˺�����unknown nodes ������Ϊ���룬����ĵ������A,B,C������ĸ���
% �˺�����Ϊ�˼���AOT�ļ�������д�ĸ�������

% ����A�㣬���ȼ�������AU�ķ��� UΪδ֪�㣬Ȼ�����A��������ļн�
AU=xy-Axy;
thetaA=quanangle(AU)-90;

BU=xy-Bxy;
thetaB=quanangle(BU)-90;

CU=xy-Cxy;
thetaC=quanangle(CU)+90;

DU=xy-Dxy;
thetaD=quanangle(DU)+90;

    


