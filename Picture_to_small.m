%该函数的目的是将一张图片分解成m行n列个子图片，然后求各个子图片的直方图，并将所有直方图汇总成一个特征量
%img为待分解的图片，m为分解为m行，n为分解为n列
function B=Picture_to_small(img,m,n)
            rols = m;
            cols = n;
            [mr nr]=size(img);
            m4=floor(mr/rols);
            n4=floor(nr/cols);
            % imhFig=[];
            Figcount=[];
            for i=1:rols
                for j=1:cols
                    %将图像分解为rols*cols块
                    num=(i-1)*cols+j;
                    K=img((i-1)*m4+1:i*m4,(j-1)*n4+1:j*n4);
                    %求各个分解后子图片的直方图
                    [counts,x]=imhist(K,64);     
                    %将各个子图的直方图汇总成特征向量                    
                    counts=counts/m/n;                     
%                     counts=counts';
                    %计算归一化灰度直方图各区间的值
                    Figcount = [Figcount;counts];
                    
%                     subplot(rols,cols,num),imhist(K);
                    
                end
            end
            B=Figcount';
end