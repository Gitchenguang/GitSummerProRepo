function [Xset,Yset]=filterpoints( Xpset,Ypset,thetaA, thetaB,thetaC,Axy,Bxy,Cxy)
% [X,Y]=filterpoints( Xpset,Ypset,thetaA, thetaB,thetaC,Axy,Bxy,Cxy )
% thetaA thetaB thetaD �ֱ�Ϊ�ڵ�A,B,C,D�ŽǵĽ�ƽ������ڵ�heading�ļнǣ�����ٶ������ڵ��heading������ͬ��
% B�ٶ���Ϊ����ԭ��
% Axy Bxy Cxy DxyΪ1*2�������ֱ���A��B��C,D������
% X,Y �ֱ�Ϊ���������Ľڵ�ĺ�������������ֵ��������ά������


% Ϊ������㣬���Ƚ��Ƕ�ֵ�任Ϊ���Ƚ�
thetaA0=(thetaA-7.5)*pi/180; thetaA1=(thetaA+7.5)*pi/180;
thetaB0=(thetaB-7.5)*pi/180; thetaB1=(thetaB+7.5)*pi/180;
thetaC0=(thetaC-7.5)*pi/180; thetaC1=(thetaC+7.5)*pi/180; 

% ���ýڵ�A��̽��Ƕ��������������е�һ��ɸѡ

kA1=tan(pi/2+thetaA1);
kA0=tan(pi/2+thetaA0);

index=1;
num=length(Xpset);

for i=1:1:num
    if (kA1*(Xpset(i)-Axy(1,1))+Axy(1,2)-Ypset(i))>=0 &&(kA0*(Xpset(i)-Axy(1,1))+Axy(1,2)-Ypset(i))<=0
        X1(index)=Xpset(i);Y1(index)=Ypset(i);
        index=index+1;
    end
end


% �ýڵ�B���еڶ���ɸѡ

kB1=tan(pi/2+thetaB1);
kB0=tan(pi/2+thetaB0);


num=index-1;
index=1;

for i=1:1:num
        if (kB1*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))<=0 &&(kB0*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))>=0
            X2(index)=X1(i);Y2(index)=Y1(i);
            index=index+1;  
        end
end

% ��C�ڵ���е����ε���

kC1=tan(pi/2+thetaC1);
kC0=tan(pi/2+thetaC0);


num=index-1;
index=1;

for i=1:1:num
    if kC0>0 && kC1>0
        if (kC1*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))<=0 &&(kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    elseif kC0>0 && kC1<0
        if (kC1*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0 &&(kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    elseif kC0<0 && kC1<0
        if (kC1*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0 &&(kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))<=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    end
end

if isempty(X3)
    Xset=-1;Yset=-1;
else
    Xset=X3;Yset=Y3;
end

