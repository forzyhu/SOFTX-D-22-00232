%�ú�����Ŀ���ǽ�һ��ͼƬ�ֽ��m��n�и���ͼƬ��Ȼ���������ͼƬ��ֱ��ͼ����������ֱ��ͼ���ܳ�һ��������
%imgΪ���ֽ��ͼƬ��mΪ�ֽ�Ϊm�У�nΪ�ֽ�Ϊn��
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
                    %��ͼ��ֽ�Ϊrols*cols��
                    num=(i-1)*cols+j;
                    K=img((i-1)*m4+1:i*m4,(j-1)*n4+1:j*n4);
                    %������ֽ����ͼƬ��ֱ��ͼ
                    [counts,x]=imhist(K,64);     
                    %��������ͼ��ֱ��ͼ���ܳ���������                    
                    counts=counts/m/n;                     
%                     counts=counts';
                    %�����һ���Ҷ�ֱ��ͼ�������ֵ
                    Figcount = [Figcount;counts];
                    
%                     subplot(rols,cols,num),imhist(K);
                    
                end
            end
            B=Figcount';
end