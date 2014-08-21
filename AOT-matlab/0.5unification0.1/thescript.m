step=0.5;Aerawidth=70;

% 基站定标 
BS1=[0,0];heading1=0;   BS2=[Aerawidth,0];heading2=0; BS3=[Aerawidth,Aerawidth];heading3=0; BS4=[0,Aerawidth];heading4=0;
BSNum=4;

meaerror=zeros(1,(Aerawidth/step)*(Aerawidth/step));
%这里先以正方形为例

% 组装BSbroadinfo
BSbroadinfo=zeros( BSNum ,5);
BSbroadinfo(1,1:4)=[ 1,BS1(1,1),BS1(1,2),heading1];
BSbroadinfo(2,1:4)=[ 2,BS2(1,1),BS2(1,2),heading2];
BSbroadinfo(3,1:4)=[ 3,BS3(1,1),BS3(1,2),heading3];
BSbroadinfo(4,1:4)=[ 4,BS4(1,1),BS4(1,2),heading4];

index=1;
for i=step/2:step:Aerawidth-step/2
    for j=step/2:step:Aerawidth-step/2
        
        % 计算各个BS的辐角
        [ thetaA,thetaB,thetaC,thetaD]=generangle([i,j],BS1,BS2,BS3,BS4);
        BSbroadinfo(1,5)=[ thetaA-heading1];
        BSbroadinfo(2,5)=[ thetaB-heading2];
        BSbroadinfo(3,5)=[ thetaC-heading3];
        BSbroadinfo(4,5)=[ thetaD-heading4];
        
        [estimX,estimY,BSbanned]=lslocation( BSbroadinfo );
        
        meaerror(index)=sqrt( (i-estimX).^2+(j-estimY).^2);
        index=index+1;
        
    end
end

meamax=max(meaerror);
meamean=mean(meaerror);
for i=1:1:Aerawidth/step
    meapic(:,i)=meaerror( ((i-1)*Aerawidth/step+1):i*Aerawidth/step);
end
