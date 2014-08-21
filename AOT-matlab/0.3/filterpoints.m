function [Xset,Yset]=filterpoints( Xpset,Ypset,thetaA, thetaB,thetaC,thetaD,thetaE,thetaF,Axy,Bxy,Cxy,Dxy,Exy,Fxy)
% [X,Y]=filterpoints( thetaA, thetaB,thetaC,thetaD,thetaE,thetaF,Axy,Bxy,Cxy,Dxy,Exy,Fxy )
% thetaA thetaB thetaD �ֱ�Ϊ�ڵ�A,B,C,D�ŽǵĽ�ƽ������ڵ�heading�ļнǣ�����ٶ������ڵ��heading������ͬ��
% B�ٶ���Ϊ����ԭ��
% Axy Bxy Cxy DxyΪ1*2�������ֱ���A��B��C,D������
% X,Y �ֱ�Ϊ���������Ľڵ�ĺ�������������ֵ��������ά������


% Ϊ������㣬���Ƚ��Ƕ�ֵ�任Ϊ���Ƚ�
thetaA0=(thetaA-7.5)*pi/180; thetaA1=(thetaA+7.5)*pi/180;
thetaB0=(thetaB-7.5)*pi/180; thetaB1=(thetaB+7.5)*pi/180;
thetaC0=(thetaC-7.5)*pi/180; thetaC1=(thetaC+7.5)*pi/180; 
thetaD0=(thetaD-7.5)*pi/180; thetaD1=(thetaD+7.5)*pi/180;
thetaE0=(thetaE-7.5)*pi/180; thetaE1=(thetaE+7.5)*pi/180; 
thetaF0=(thetaF-7.5)*pi/180; thetaF1=(thetaF+7.5)*pi/180;

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
    if kB0<0 && kB1<0
        if (kB1*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))<=0 &&(kB0*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))>=0
            X2(index)=X1(i);Y2(index)=Y1(i);
            index=index+1;  
        end
    elseif kB0>0 && kB1<0
        if (kB1*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))<=0 &&(kB0*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))<=0
            X2(index)=X1(i);Y2(index)=Y1(i);
            index=index+1;  
        end
    elseif kB0>0 && kB1>0
        if (kB1*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))>=0 &&(kB0*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))<=0
            X2(index)=X1(i);Y2(index)=Y1(i);
            index=index+1;  
        end
    elseif kB0<0 && kB1>0
        if (kB1*(X1(i)-Bxy(1,1))+Bxy(1,2)-Y1(i))>=0 
            X2(index)=X1(i);Y2(index)=Y1(i);
            index=index+1;
        end
    end
end

% ��C�ڵ���е����ε���

kC1=tan(pi/2+thetaC1);
kC0=tan(pi/2+thetaC0);


num=index-1;
index=1;

for i=1:1:num
    if kC0>0 && kC1>0
        if (kC1*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0 &&(kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))<=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    elseif kC0>0 && kC1<0
        if (kC1*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))<=0 &&(kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))<=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    elseif kC0<0 && kC1<0
        if (kC1*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))<=0 &&(kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    elseif kC0<0 && kC1>0
        if (kC0*(X2(i)-Cxy(1,1))+Cxy(1,2)-Y2(i))>=0
            X3(index)=X2(i);Y3(index)=Y2(i);
            index=index+1;  
        end
    end
end
% ��D�ڵ���е�����ɸѡ

kD1=tan(pi/2+thetaD1);
kD0=tan(pi/2+thetaD0);

num=index-1;
index=1;

for i=1:1:num
    if (kD1*(X3(i)-Dxy(1,1))+Dxy(1,2)-Y3(i))<=0 &&(kD0*(X3(i)-Dxy(1,1))+Dxy(1,2)-Y3(i))>=0
        X4(index)=X3(i);Y4(index)=Y3(i);
        index=index+1;
    end
end

% �ýڵ�E���е�����ɸѡ

kE1=tan(pi/2+thetaE1);
kE0=tan(pi/2+thetaE0);


num=index-1;
index=1;

for i=1:1:num
    if kE0<0 && kE1>0
        if (kE1*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))<=0 
            X5(index)=X4(i);Y5(index)=Y4(i);
            index=index+1; 
        end
    
    elseif kE0>0 && kE1>0
        if (kE1*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))<=0 &&(kE0*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))>=0
            X5(index)=X4(i);Y5(index)=Y4(i);
            index=index+1;  
        end
    elseif kE0>0 && kE1<0
        if (kE1*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))>=0 &&(kE0*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))>=0
            X5(index)=X4(i);Y5(index)=Y4(i);
            index=index+1;  
        end
    elseif kE0<0 && kE1<0
        if (kE1*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))>=0 &&(kE0*(X4(i)-Exy(1,1))+Exy(1,2)-Y4(i))<=0
            X5(index)=X4(i);Y5(index)=Y4(i);
            index=index+1;  
        end 
    end
end

% ��F�ڵ���е����ε���

kF1=tan(pi/2+thetaF1);
kF0=tan(pi/2+thetaF0);


num=index-1;
index=1;

for i=1:1:num
    if kF0>0 && kF1>0
        if (kF1*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))<=0 &&(kF0*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))>=0
            X6(index)=X5(i);Y6(index)=Y5(i);
            index=index+1;  
        end
    elseif kF0>0 && kF1<0
        if (kF1*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))>=0 &&(kF0*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))>=0
            X6(index)=X5(i);Y6(index)=Y5(i);
            index=index+1;  
        end
    elseif kF0<0 && kF1<0
        if (kF1*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))>=0 &&(kF0*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))<=0
            X6(index)=X5(i);Y6(index)=Y5(i);
            index=index+1;  
        end
    elseif kF0<0 && kF1>0
        if (kF0*(X5(i)-Fxy(1,1))+Fxy(1,2)-Y5(i))<=0
            X6(index)=X5(i);Y6(index)=Y5(i);
            index=index+1;  
        end
    end
end


if isempty(X6)
    Xset=-1;Yset=-1;
else
    Xset=X6;Yset=Y6;
end

