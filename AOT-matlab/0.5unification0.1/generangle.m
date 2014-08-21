function [ angleMatrix]=generangle(xy ,BSbroadinfo )
% [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy)
% 

% 

len=size(BSbroadinfo,1);
BSnewpos=zeros(len,2);
for i=1:1:len
    
    XY=[ cos(BSbroadinfo(i,4)) , cos(BSbroadinfo(i,4));sin(BSbroadinfo(i,4)),-sin(BSbroadinfo(i,4))]*xy';
    BSnewpos(i,:)=[ cos(BSbroadinfo(i,4)) , cos(BSbroadinfo(i,4));sin(BSbroadinfo(i,4)),-sin(BSbroadinfo(i,4))]*[BSbroadinfo(i,2),BSbroadinfo(i,3)]';
    
    
end










AU=xy-Axy;
thetaA=quanangle(AU)-90;

BU=xy-Bxy;
thetaB=quanangle(BU)+90;

CU=xy-Cxy;
thetaC=quanangle(CU)+90;

DU=xy-Dxy;
thetaD=quanangle(DU)-90;   


