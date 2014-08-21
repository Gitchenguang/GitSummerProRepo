step=1;Aerawidth=70;loopnum=100;
% ��վ����
BSNum=4;

BS1=[0,0];BS2=[Aerawidth,0];BS3=[Aerawidth,Aerawidth];BS4=[0,Aerawidth];

BSbroadinfo=zeros( BSNum ,5);
BSbroadinfo(1,1:3)=[ 1,BS1(1,1),BS1(1,2)];
BSbroadinfo(2,1:3)=[ 2,BS2(1,1),BS2(1,2)];
BSbroadinfo(3,1:3)=[ 3,BS3(1,1),BS3(1,2)];
BSbroadinfo(4,1:3)=[ 4,BS4(1,1),BS4(1,2)];

meaerror=zeros(1,(Aerawidth/step)*(Aerawidth/step));
for ind=1:1:loopnum


% ��װBSbroadinfo��headings

BSbroadinfo(:,4)=(rand(BSNum,1)-0.5)*360;

% ��ѭ���������ƽ��
tmperror=zeros(1,(Aerawidth/step)*(Aerawidth/step));

    index=1;
    for i=step/2:step:Aerawidth-step/2
        for j=step/2:step:Aerawidth-step/2

            % �������BS�ķ���
            BSbroadinfo(:,5)=generangle([i,j],BSbroadinfo);

            [estimX,estimY,BSbanned]=lslocation( BSbroadinfo );
            tmperror(index)=sqrt( (i-estimX).^2+(j-estimY).^2);
            index=index+1;
        end
    end
    meaerror=tmperror+meaerror;
end

meaerror=meaerror/loopnum;
meamax=max(meaerror);
meamean=mean(meaerror);
meapic=zeros( Aerawidth/step,Aerawidth/step);
for i=1:1:Aerawidth/step
    meapic(:,i)=meaerror( ((i-1)*Aerawidth/step+1):i*Aerawidth/step);
end
