function [angle]=quanangle(xy)
% [angle]=quanangle(xy)

if xy(1,1)==0 
    if xy(1,2)>0
       angle=90;
    elseif xy(1,2)<0
       angle=-90; 
    end
else
    kXY=xy(1,2)/xy(1,1);
    if kXY>=tan(pi*11/24)
        angle=90;
    elseif kXY>=tan(pi*9/24)
        angle=75;
    elseif kXY>=tan(pi*7/24)
        angle=60;
    elseif kXY>=tan(pi*5/24)
        angle=45;
    elseif kXY>=tan(pi*3/24)
        angle=30;
    elseif kXY>=tan(pi*1/24)
        angle=15;  
    elseif kXY>=tan(-pi*1/24)
        angle=0;
    elseif kXY>=tan(-pi*3/24)
        angle=-15;
    elseif kXY>=tan(-pi*5/24)
        angle=-30;
    elseif kXY>=tan(-pi*7/24)
        angle=-45;
    elseif kXY>=tan(-pi*9/24)
        angle=-60;
    elseif kXY>=tan(-pi*11/24)
        angle=-75;
    else
        angle=-90;
    end
end