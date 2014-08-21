function [estimX,estimY,BSbanned]=lslocationdistmax( BSbroadinfo )
% [estimX,estimY��BSbanned]=lslocationdistmax( BSbroadinfo )
%  BSbroadinfo=[ BSid , postionX,positionY,heading,radial]

BSid=1;posX=2;posY=3;heading=4;radial=5;

% ��������Ϣ���ػ�

angle=BSbroadinfo(:,heading)+BSbroadinfo(:,radial);
Xposition=BSbroadinfo(:,posX);Yposition=BSbroadinfo(:,posY);

rowNum=size(BSbroadinfo,1); len=1;
BSbanned=zeros(1,rowNum+1);pointsX=zeros(1,rowNum+1); pointsY=zeros(1,rowNum+1); pointsEorr=zeros(1,rowNum+1);
pointsX(len)=0;pointsY(len)=0;pointsEorr(len)=0;BSbanned(len)=0;

% 1�� �ж���ֱ�߹�ϵȷ�����㣨ƽ�е�����ˮƽ���򲻴�ֱ ��ˮƽ����ֱ���ǹ��� ƽ������ˮƽ����ֱ���ǲ����� �����ཻ���д�ֱ�����޴�ֱ�����֣� ��
for i=1:1:rowNum-1  
    for j=(i+1):1:rowNum
        % ����Ҫ����ֱ�ߵĽ��㣬��Ҫ��һЩ�ж�
        % 1���ж��Ƿ�ƽ�л����Ƿ�Ϊx=c��ֱ�� flagΪ�Ǹ�����ƽ�е�ȨֵΪ1����ֱΪ2
        flag=0;
        if abs(mod(angle(i,1),180))==abs(mod(angle(j,1),180))
            flag=flag+1;
        end
        if (abs(mod(angle(i,1)+90,360))==90) || (abs(mod(angle(i,1)+90,360))==270)||(abs(mod(angle(j,1)+90,360))==90) || (abs(mod(angle(j,1)+90,360))==270)
            flag=flag+2;
        end
        % 2������flag���ֱ�߷���
        switch flag
            case 1
                %���Ϊͬһ���ߣ����ý�ֹ��BS��������һ��
                ki=tan(angle(i,1)*pi/180+pi/2);kj=tan(angle(j,1)*pi/180+pi/2);
                x0i=Xposition(i,1);y0i=Yposition(i,1);
                x0j=Xposition(j,1);y0j=Yposition(j,1);
                if abs((y0i-x0i*ki)-(y0j-x0j*kj))>=10^(-2)
                    BSbanned(len)=BSbanned(len)+1;BSbanned(BSbanned(len)+1)=BSbroadinfo(i,BSid);
                end
            case 2
                  %ȷ����ֱ�������ߣ���������
                    x0i=Xposition(i,1);y0i=Yposition(i,1);
                    x0j=Xposition(j,1);y0j=Yposition(j,1);
                    if (abs(mod(angle(i,1)+90,360))==90) || (abs(mod(angle(i,1)+90,360))==270)
                        pointsX(len)=1+pointsX(len);pointsY(len)=1+pointsY(len);pointsEorr(len)=1+pointsEorr(len);
                        
                        pointsX(pointsX(len)+1)=x0i;
                        pointsY(pointsY(len)+1)=y0j+tan(angle(j,1)*pi/180+pi/2)*(x0i-x0j);
                        
                        % ���㽻������뽻��Ͻ���BS֮��ľ��� �õ����Ʒ���
                        pointsEorr( pointsEorr(len)+1 )=(pi/24)^2*0.25*max((x0i-pointsX(pointsX(len)+1)).^2+ (y0i-pointsY(pointsY(len)+1)).^2 ,(x0j-pointsX(pointsX(len)+1)).^2+ (y0j-pointsY(pointsY(len)+1)).^2 );
                    else
                        pointsX(len)=1+pointsX(len);pointsY(len)=1+pointsY(len);pointsEorr(len)=1+pointsEorr(len);
                        
                        pointsX(pointsX(len)+1)=x0j;
                        pointsY(pointsY(len)+1)=y0i+tan(angle(i,1)*pi/180+pi/2)*(x0j-x0i);
                        
                        % ���㽻������뽻��Ͻ���BS֮��ľ��� �õ����Ʒ���
                        pointsEorr( pointsEorr(len)+1 )= (pi/24)^2*0.25*max( (x0i-pointsX(pointsX(len)+1)).^2+ (y0i-pointsY(pointsY(len)+1)).^2 , (x0j-pointsX(pointsX(len)+1)).^2+ (y0j-pointsY(pointsY(len)+1)).^2 );
                    end
            case 3
                %������������ֹ���i��BS
                x0i=Xposition(i,1);x0j=Xposition(j,1);
                if abs(x0i-x0j)>=10^(-2)
                    BSbanned(len)=BSbanned(len)+1;BSbanned(BSbanned(len)+1)=BSbroadinfo(i,BSid);
                end
            case 0
           %������Է�����
                    ki=tan(angle(i,1)*pi/180+pi/2);kj=tan(angle(j,1)*pi/180+pi/2);
                    x0i=Xposition(i,1);x0j=Xposition(j,1);
                    y0i=Yposition(i,1);y0j=Yposition(j,1);

                    pointsX(len)=1+pointsX(len);pointsY(len)=1+pointsY(len);pointsEorr(len)=1+pointsEorr(len);

                    tmp=inv([1,-ki;1,-kj])*[-x0i*ki+y0i,-x0j*kj+y0j]';
                    pointsX(pointsX(len)+1)=tmp(2,1);pointsY(pointsY(len)+1)=tmp(1,1);
                    
                    % ���㽻������뽻��Ͻ���BS֮��ľ��� �õ����Ʒ���
                    pointsEorr( pointsEorr(len)+1 )= (pi/24)^2*0.25*max( (x0i-pointsX(pointsX(len)+1)).^2+ (y0i-pointsY(pointsY(len)+1)).^2 , (x0j-pointsX(pointsX(len)+1)).^2+ (y0j-pointsY(pointsY(len)+1)).^2 );
                    
            otherwise
        end
    end
end

% ��LS������Ƶ�����ֵ
if pointsX(len)==0
    flase=1
else
    pointsEorr((len+1):pointsEorr(len)+1)=1./pointsEorr(len+1:pointsEorr(len)+1);
    
    estimX=sum(pointsX((len+1):(pointsX(len)+1)).*pointsEorr( (len+1):(pointsEorr(len)+1) ) )/sum( pointsEorr( (len+1):pointsEorr( len)+1));
    estimY=sum(pointsY((len+1):(pointsY(len)+1)).*pointsEorr( (len+1):(pointsEorr(len)+1) ) )/sum( pointsEorr( (len+1):pointsEorr( len)+1));
end


