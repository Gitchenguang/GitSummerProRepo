function [Xpset,Ypset]=pointsset(step, Axy,Bxy,Cxy  )
% [Xpset,Ypset]=pointsset( Axy,Bxy,Cxy )

AC=Cxy-Axy;BC=Cxy-Bxy;AB=Bxy-Axy;
kAC=AC(1,2)/AC(1,1);kBC=BC(1,2)/BC(1,1);

len=abs(AB(1,1));

index=1;

for i=step/2:step:len-step/2
    for j=step/2:step:len-step/2
        % 对i分区间讨论[0,25]
        if i<=len/2
            if j<( kAC*(i-Axy(1,1))+Axy(1,2))
                Xpset(index)=i;
                Ypset(index)=j;
                index=index+1;
            end
        else
            if j<( kBC*(i-Bxy(1,1))+Bxy(1,2))
                Xpset(index)=i;
                Ypset(index)=j;
                index=index+1;
            end
        end
    end
end
