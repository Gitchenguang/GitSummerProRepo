% ������ֻ���㶨λ�������ĵ�����,��λ��ΧΪ50m*50m������

% ���ȶ����򻮷�����
Aerawidth=70;
step=0.5;Axy=[0,Aerawidth];Bxy=[0,0];Cxy=[Aerawidth,0];
meaerror=zeros(1,(Aerawidth/step).^2);
index=1;

for i=step/2:step:(Aerawidth-step/2)
    for j=step/2:step:(Aerawidth-step/2)
    % ��������ѭ��������������ĵ㶨λ��ƽ����������
        xy(1,1)=i;xy(1,2)=j;
        [ thetaA,thetaB,thetaC]=generangle(xy,Axy,Bxy,Cxy);
        [ setX,setY]=filterpoints( thetaA,thetaB,thetaC,Axy,Bxy,Cxy);
        estimXY(1,1)= sum(setX)/length(setX); %���Ǽ�Ȩ��ֵ
        estimXY(1,2)= sum(setY)/length(setY);
        
    % �ҵ��˹���ֵ��������Ϊ����ƽ�����������¼���ݣ�����ƫ�����
        meaerror(index)=sqrt( sum((xy-estimXY).^2) );
        index=index+1;
    end
end

errorMax=max( meaerror );
errorMean=mean( meaerror);
meapic=zeros( Aerawidth/step,Aerawidth/step);
for i=1:1:Aerawidth/step
    meapic(:,i)=meaerror( ((i-1)*Aerawidth/step+1):i*Aerawidth/step);
end
