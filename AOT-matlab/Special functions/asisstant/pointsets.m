function [Xpset,Ypset]=pointset(BSbroadinfo)
% [Xpset,Ypset]=pointset(BSbroadinfo)
% 对任意给定的多变形进行网格划分

% 获得基站坐标信息以确定定位区域
BSXpos=BSbroadinfo( :,2);
BSYpos=BSbroadinfo( :,3);

loopflag=1;pointer=0;flag=0;
tripointset=zeros(3,1);
maxnum=max(BSXpos);

tmpBSXpos=BSXpos;
while loopflag
    [minX ind]=min(tmpBSXpos);
    if tmpBSXpos(ind)<(maxnum+1)
        tmpBSXpos(ind)=maxnum+1;
        tripointset(pointer+1)=ind;
        pointer=pointer+1;
        flag=flag+1;
        if flag==3
            %三角形区域的点集
            
            
            flag=flag-1;
            pointer=mod(pointer,3);
        end
    else
        loopflag=0;
    end
end
