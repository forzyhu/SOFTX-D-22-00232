%���㷨��ͼ�������������ȡ���ܽϺõ���ȡ������
%��ֵ��λ�㷨
%% m�ļ�ͷ
% clc
% clear
% A=imread('F:\mat\pic\allpic.jpg');
%% ����ͷ
function [retImg]=Zyh_Fun_CZYW(A,f1,f2,f3,f4,f5,f6,f7,f8)
r=3;
c=3;
% rr_Value = rr_temp;
[m,n,z]=size(A);
%% ����ͼƬ�Ƿ�Ϊ�Ҷ�ͼƬ����ת��
if(z>1)
    A=rgb2gray(A);
end
%% 1����ͼ�����ĸ�������ݶ�ֵ
for i=1:m
    for j=1:n
         if(j==1)
             B1(i,j)=A(i,j)-A(i,j);
         else
             B1(i,j)=abs(A(i,j)-A(i,j-1));
         end
    end
end

%�������ݶ�
for i=1:m
    for j=1:n
         if(j==n)
             B2(i,j)=A(i,j)-A(i,j);
         else
             B2(i,j)=abs(A(i,j)-A(i,j+1));
         end
    end
end

%�������ݶ�
for i=1:m
    for j=1:n
         if(i==1)
             B3(i,j)=A(i,j)-A(i,j);
         else
             B3(i,j)=abs(A(i,j)-A(i-1,j));
         end
    end
end

%�������ݶ�
for i=1:m
    for j=1:n
         if(i==m)
             B4(i,j)=A(i,j)-A(i,j);
         else
             B4(i,j)=abs(A(i,j)-A(i+1,j));
         end
    end
end

%% 2����ͼ����ݶ��ںϾ���
BB=B1/4+B2/4+B3/4+B4/4;
% SS=(B1-B2)+(B3-B4);

%% 3��ȥ��ͼ����������  ���˴��ںܴ�̶���Ӱ���㷨��ʶ���ʣ�
BQZ = BB;
% aveBQZ=mean(mean(BQZ));
% �������ֵ�ľ�ֵ
% count = sum(sum(BQZ~=0));
% ave = sum(sum(BQZ))/count;

ave = 30;

% �޳���������
for i=1:m
    for j=1:n
        if(BQZ(i,j) < ave*1.1)
            BQZ(i,j)=0;
        end
    end
end

%% 4�����ڽ�����ͼ������������������ͼ�����Ҫ����������չ����
% �����ƻ��ǵ�9�����ڳ��ַ������ֵĸ�������3��ʱ
T1 = BQZ;
for i=1:m
    for j=1:n
        if(i>=2 && i<m-1 && j>=2 && j<n-1)
            Temp1=0;
            TempSum=0;
            % ѭ����Ź����ֵ������ֵ������
            for(ti=i-1:i+1)
                for(tj=j-1:j+1)
                    
                    if(BQZ(ti,tj)>0)
                        Temp1 = Temp1+1;
                        TempSum = TempSum + BQZ(ti,tj);
                    end
                end
            end
            % ���Ź����ڵ����ָ�ֵ
            if(Temp1>=3)
                for(ti=i-1:i+1)
                    for(tj=j-1:j+1)
                        if(BQZ(ti,tj)<=0)
                            T1(ti,tj) = uint8(TempSum/Temp1);
                        end
                    end
                end
            end
        end
    end
end

%% T2 �Խ�����ֵ�Ե�����
% T2=BQZ-BQZ;
% if(1~=1)  % �ÿ������Ƿ����ò�������
%     for i=1:m
%         for j=1:n
%             if(i>=2 && i<m-1 && j>=2 && j<n-1)
%                 if(BQZ(i,j) > 0)
%                     T2(i-1,j-1) = BQZ(i+1,j+1)*1.1;
%                     T2(i+1,j+1) = BQZ(i-1,j-1)*1.3;
%                     T2(i-1,j+1) = BQZ(i+1,j-1)*1.2;
%                     T2(i+1,j-1) = BQZ(i-1,j+1)*1.4;
%                 end
%             end
%         end
%     end
% end
%%   ����㷨׼ȷ�ʵ���Ҫ��ʽ������**********************************************************************
% AA=A-(BB + SS*2);  %ʶ���ʽϸߣ�������Ϊ3��ʱ��ʶ�������   ORL���Կ���Ϊ97%
% AA2=(A+BB)- SS*8;   %ʶ���ʽϸߣ�������Ϊ3.5��ʱ��ʶ�������   ORL���Կ���Ϊ98.5%   AA2=(A+BB)- SS*3.5;   A+(BB-SS*3.5);   AA2=(A+BB)- SS*(4~7)���Դﵽ100%;

%% ͼ�����������ķ���ֵ
% retImg = (A - BQZ * 1.2 + BB);
% retImg = (A + T1*fn + BB*fm);                   %��0.2,0.4��
retImg = (B1*f1 + B2*f2 + B3*f3 + B4*f4 + BB*f5 + BQZ*f6 + T1*f7 + A *f8);                   %��0.2,0.4��

