function [X,Y]=filterpoints( thetaA, thetaB,thetaC,thetaD,Axy,Bxy,Cxy,Dxy)
% [X,Y]=filterpoints( thetaA, thetaB,thetaC,thetaD,Axy,Bxy,Cxy,Dxy)
% thetaA thetaB thetaD �ֱ�Ϊ�ڵ�A,B,C,D�ŽǵĽ�ƽ������ڵ�heading�ļнǣ�����ٶ������ڵ��heading������ͬ��
% B�ٶ���Ϊ����ԭ��
% Axy Bxy Cxy DxyΪ1*2�������ֱ���A��B��C,D������
% X,Y �ֱ�Ϊ���������Ľڵ�ĺ�������������ֵ��������ά������


% Ϊ������㣬���Ƚ��Ƕ�ֵ�任Ϊ���Ƚ�
thetaA0=(thetaA-7.5)*pi/180; thetaA1=(thetaA+7.5)*pi/180;
thetaB0=(thetaB-7.5)*pi/180; thetaB1=(thetaB+7.5)*pi/180;
thetaC0=(thetaC-7.5)*pi/180; thetaC1=(thetaC+7.5)*pi/180; 
thetaD0=(thetaD-7.5)*pi/180; thetaD1=(thetaD+7.5)*pi/180;

%��������ʱ��step
step=0.5; Aerawidth=70;

% ���ýڵ�B��̽��Ƕ���������������ɸѡ������ʱ�ɽ�tan�Ƴ������ټ�������

index=1;
kB1=tan(pi/2+thetaB1);
kB0=tan(pi/2+thetaB0);
for i=step/2:step:(Aerawidth-step/2)
    for j=step/2:step:(Aerawidth-step/2)
        if kB1<0
            if (i*kB0-j)<=0                  %��Ӷ�thetaBΪ��ʱthetaB1�ж�ʧЧ�����
                X1(index)=i;Y1(index)=j;
                index=index+1;
            end
        else
            if (i*kB1-j)>=0 &&(i*kB0-j)<=0 %��������̽����ǽ�ƽ����������������н�����Ҫ��һ��
                X1(index)=i;Y1(index)=j;
                index=index+1;
            end
        end
    end
end

%�õ�X��Y�����ĳ���
index=index-1; 

%�ýڵ�A��̽��ǶԴ�B��ɸѡ�ĵ���еڶ���ɸѡ
num=index;
index=1;
kA1=tan(pi/2+thetaA1);
kA0=tan(pi/2+thetaA0);
for ind=1:1:num
    if kA0>0
        if ((X1(ind)-Axy(1,1))*kA1+Axy(1,2)-Y1(ind))>=0
            X2(index)=X1(ind);Y2(index)=Y1(ind);
            index=index+1;
        end
    else
        if ((X1(ind)-Axy(1,1))*kA1+Axy(1,2)-Y1(ind))>=0 && ((X1(ind)-Axy(1,1))*kA0+Axy(1,2)-Y1(ind))<=0
            X2(index)=X1(ind);Y2(index)=Y1(ind);
            index=index+1;
        end
    end
end

%�õ�X��Y�����ĳ���
index=index-1; 
%�ýڵ�C��̽��Ǵӵڶ���ɸѡ�Ľ���м���������ɸѡ(���ڷ��򣬾�����ʱ��Ϊ�������������ᶼһ��)

num=index;
index=1;
kC1=tan(pi/2+thetaC1);
kC0=tan(pi/2+thetaC0);
for ind=1:num
    if kC0>0
        if ((X2(ind)-Cxy(1,1))*kC1+Cxy(1,2)-Y2(ind))<=0
            X3(index)=X2(ind);Y3(index)=Y2(ind);
            index=index+1;
        end
    else
        if (((X2(ind)-Cxy(1,1))*kC1+Cxy(1,2)-Y2(ind))<=0) && (((X2(ind)-Cxy(1,1))*kC0+Cxy(1,2)-Y2(ind))>=0)
            X3(index)=X2(ind);Y3(index)=Y2(ind);
            index=index+1;
        end
    end
end
%
%�õ�X��Y�����ĳ���
index=index-1; 
%�ýڵ�D��̽��Ǵӵ�����ɸѡ�Ľ���м���������ɸѡ(���ڷ��򣬾�����ʱ��Ϊ�������������ᶼһ��)

num=index;
index=1;
kD1=tan(pi/2+thetaD1);
kD0=tan(pi/2+thetaD0);
for ind=1:num
    if kD1<0
        if ((X3(ind)-Dxy(1,1))*kD0+Dxy(1,2)-Y3(ind))>=0
            X4(index)=X3(ind);Y4(index)=Y3(ind);
            index=index+1;
        end
    else
        if (((X3(ind)-Dxy(1,1))*kD1+Dxy(1,2)-Y3(ind))<=0) && (((X3(ind)-Dxy(1,1))*kD0+Dxy(1,2)-Y3(ind))>=0)
            X4(index)=X3(ind);Y4(index)=Y3(ind);
            index=index+1;
        end
    end
end
%

if isempty( X4)
    X=-1;Y=-1;
else
    X=X4;Y=Y4;
end




