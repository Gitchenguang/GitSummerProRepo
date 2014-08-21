function [X,Y]=filterpoints( thetaA, thetaB,thetaC,Axy,Bxy,Cxy)
% [X,Y]=filterpoints( thetaa, thetab,thetac)
% thetaa thetab thetac 分别为节点A,B,C张角的角平分线与节点heading的夹角（这里假定三个节点的heading方向相同）
% B为定点，假定其为坐标原点
% Axy Bxy Cxy 为1*2的向量分别存放A，B，C的坐标
% X,Y 分别为符合条件的节点的横坐标与纵坐标值，其向量维数不定


% 为方便计算，首先将角度值变换为弧度角
thetaA0=(thetaA-7.5)*pi/180; thetaA1=(thetaA+7.5)*pi/180;
thetaB0=(thetaB-7.5)*pi/180; thetaB1=(thetaB+7.5)*pi/180;
thetaC0=(thetaC-7.5)*pi/180; thetaC1=(thetaC+7.5)*pi/180; 

%划分网格时的step
step=1; Aerawidth=50;

% 先用节点B的探测角对区域内坐标点进行筛选（计算时可将tan移出来减少计算量）

index=1;
kB1=tan(pi/2+thetaB1);
kB0=tan(pi/2+thetaB0);
for i=step/2:step:(Aerawidth-step/2)
    for j=step/2:step:(Aerawidth-step/2)
        if kB1<0
            if (i*kB0-j)<=0                  %添加对thetaB为零时thetaB1判断失效的情况
                X1(index)=i;Y1(index)=j;
                index=index+1;
            end
        else
            if (i*kB1-j)>=0 &&(i*kB0-j)<=0 %这里由于探测角是角平分线与纵轴正方向夹角所以要变一下
                X1(index)=i;Y1(index)=j;
                index=index+1;
            end
        end
    end
end

%得到X，Y向量的长度
index=index-1; 

%用节点A的探测角对从B中筛选的点进行第二轮筛选
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

%得到X，Y向量的长度
index=index-1; 
%用节点C的探测角从第二轮筛选的结果中继续第三轮筛选(对于方向，就以逆时针为正，横纵坐标轴都一样)

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

if length(X3)==0
    X=-1;Y=-1;
else
    X=X3;Y=Y3;
end




