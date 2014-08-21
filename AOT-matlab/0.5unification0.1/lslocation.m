function [estimX,estimY,BSbanned]=lslocation( BSbroadinfo )
% [estimX,estimY��BSbanned]=lslocation( BSbroadinfo )
%  BSbroadinfo=[ BSid , postionX,positionY,heading,radial]

BSid=1;posX=2;posY=3;angle=4;

% 1�����������վ�ľ��ԽǶ�
BSbroadinfo(:,angle)=BSbroadinfo(:,angle)+BSbroadinfo(:,5);

% �ж��Ƿ���ƽ�еĽǶȣ�����ж����������������վ�����ϵĵ��û�а취��λ�ˣ�
% ��ʱ���û����ں�������ж�
len=1;
rowNum=size(BSbroadinfo,1); 
BSbanned=zeros(1,rowNum+1);pointsX=zeros(1,rowNum+1); pointsY=zeros(1,rowNum+1);
pointsX(len)=0;pointsY(len)=0;BSbanned(len)=0;
index=2;
for i=1:1:rowNum-1  
    for j=(i+1):1:rowNum
        % ����Ҫ����ֱ�ߵĽ��㣬��Ҫ��һЩ�ж�
        % 1���ж��Ƿ�ƽ�л����Ƿ�Ϊx=c��ֱ�� flagΪ�Ǹ�����ƽ�е�ȨֵΪ1����ֱΪ2
        flag=0;
        if abs(mod(BSbroadinfo(i,angle),180))==abs(mod(BSbroadinfo(j,angle),180))
            flag=flag+1;
        end
        if (abs(mod(BSbroadinfo(i,angle)+90,360))==90) || (abs(mod(BSbroadinfo(i,angle)+90,360))==270)||(abs(mod(BSbroadinfo(j,angle)+90,360))==90) || (abs(mod(BSbroadinfo(j,angle)+90,360))==270)
            flag=flag+2;
        end
        % 2������flag���ֱ�߷���
        switch flag
            case 1
                %���Ϊͬһ���ߣ����ý�ֹ��BS��������һ��
                ki=tan(BSbroadinfo(i,angle)*pi/180+pi/2);kj=tan(BSbroadinfo(i,angle)*pi/180+pi/2);
                x0i=BSbroadinfo(i,posX);y0i=BSbroadinfo(i,posY);
                x0j=BSbroadinfo(j,posX);y0j=BSbroadinfo(j,posY);
                if abs((y0i-x0i*ki)-(y0j-x0j*kj))>=10^(-2)
                    BSbanned(len)=BSbanned(len)+1;BSbanned(BSbanned(len)+1)=BSbroadinfo(i,BSid);
                end
            case 2
                %ȷ����ֱ�������ߣ���������
                if (abs(mod(BSbroadinfo(i,angle)+90,360))==90) || (abs(mod(BSbroadinfo(i,angle)+90,360))==270)
                    pointsX(index)=BSbroadinfo(i,posX);
                    pointsY(index)=BSbroadinfo(j,posY)+tan(BSbroadinfo(j,angle)*pi/180+pi/2)*(BSbroadinfo(i,posX)-BSbroadinfo(j,posX));
                else
                    pointsX(index)=BSbroadinfo(j,posX);
                    pointsY(index)=BSbroadinfo(i,posY)+tan(BSbroadinfo(i,angle)*pi/180+pi/2)*(BSbroadinfo(j,posX)-BSbroadinfo(i,posX));
                end
                pointsX(len)=1+pointsX(len);pointsY(len)=1+pointsY(len);
                index=index+1;
            case 3
                %ֱ�ӽ�ֹ���i��BS
                x0i=BSbroadinfo(i,posX);x0j=BSbroadinfo(j,posX);
                if abs(x0i-x0j)>=10^(-2)
                    BSbanned(len)=BSbanned(len)+1;BSbanned(BSbanned(len)+1)=BSbroadinfo(i,BSid);
                end
            case 0
                %������Է�����
                ki=tan(BSbroadinfo(i,angle)*pi/180+pi/2);kj=tan(BSbroadinfo(j,angle)*pi/180+pi/2);
                x0i=BSbroadinfo(i,posX);x0j=BSbroadinfo(j,posX);
                y0i=BSbroadinfo(i,posY);y0j=BSbroadinfo(j,posY);
                
                tmp=inv([1,-ki;1,-kj])*[-x0i*ki+y0i,-x0j*kj+y0j]';
                pointsX(index)=tmp(2,1);pointsY(index)=tmp(1,1);
                
                pointsX(len)=1+pointsX(len);pointsY(len)=1+pointsY(len);
                index=index+1;
            otherwise
        end
    end
end

% ��LS������Ƶ�����ֵ
if pointsX(len)==1
    flase=1
else
    estimX=sum(pointsX(2:pointsX(len)+1))/pointsX(len);
    estimY=sum(pointsY(2:pointsY(len)+1))/pointsY(len);
end


