%该算法对图像的轮廓进行提取，能较好的提取其特征
%差值移位算法
%% m文件头
% clc
% clear
% A=imread('F:\mat\pic\allpic.jpg');
%% 函数头
function [retImg]=Zyh_Fun_CZYW(A,f1,f2,f3,f4,f5,f6,f7,f8)
r=3;
c=3;
% rr_Value = rr_temp;
[m,n,z]=size(A);
%% 根据图片是否为灰度图片进行转换
if(z>1)
    A=rgb2gray(A);
end
%% 1、对图像求四个方向的梯度值
for i=1:m
    for j=1:n
         if(j==1)
             B1(i,j)=A(i,j)-A(i,j);
         else
             B1(i,j)=abs(A(i,j)-A(i,j-1));
         end
    end
end

%进行右梯度
for i=1:m
    for j=1:n
         if(j==n)
             B2(i,j)=A(i,j)-A(i,j);
         else
             B2(i,j)=abs(A(i,j)-A(i,j+1));
         end
    end
end

%进行上梯度
for i=1:m
    for j=1:n
         if(i==1)
             B3(i,j)=A(i,j)-A(i,j);
         else
             B3(i,j)=abs(A(i,j)-A(i-1,j));
         end
    end
end

%进行下梯度
for i=1:m
    for j=1:n
         if(i==m)
             B4(i,j)=A(i,j)-A(i,j);
         else
             B4(i,j)=abs(A(i,j)-A(i+1,j));
         end
    end
end

%% 2、求图像的梯度融合矩阵
BB=B1/4+B2/4+B3/4+B4/4;
% SS=(B1-B2)+(B3-B4);

%% 3、去除图像噪音处理  （此处在很大程度上影响算法的识别率）
BQZ = BB;
% aveBQZ=mean(mean(BQZ));
% 求非零数值的均值
% count = sum(sum(BQZ~=0));
% ave = sum(sum(BQZ))/count;

ave = 30;

% 剔除数字噪音
for i=1:m
    for j=1:n
        if(BQZ(i,j) < ave*1.1)
            BQZ(i,j)=0;
        end
    end
end

%% 4、基于降噪后的图像特征，扩大特征对图像的主要特征进行扩展延伸
% 初步计划是当9宫格内出现非零数字的个数大于3个时
T1 = BQZ;
for i=1:m
    for j=1:n
        if(i>=2 && i<m-1 && j>=2 && j<n-1)
            Temp1=0;
            TempSum=0;
            % 循环求九宫格均值及特征值的数量
            for(ti=i-1:i+1)
                for(tj=j-1:j+1)
                    
                    if(BQZ(ti,tj)>0)
                        Temp1 = Temp1+1;
                        TempSum = TempSum + BQZ(ti,tj);
                    end
                end
            end
            % 给九宫格内的数字赋值
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

%% T2 对角线数值对调方法
% T2=BQZ-BQZ;
% if(1~=1)  % 用开控制是否开启该部分运算
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
%%   提高算法准确率的主要方式在这里**********************************************************************
% AA=A-(BB + SS*2);  %识别率较高，该数字为3的时候，识别率最高   ORL测试库结果为97%
% AA2=(A+BB)- SS*8;   %识别率较高，该数字为3.5的时候，识别率最高   ORL测试库结果为98.5%   AA2=(A+BB)- SS*3.5;   A+(BB-SS*3.5);   AA2=(A+BB)- SS*(4~7)可以达到100%;

%% 图像特征描述的返回值
% retImg = (A - BQZ * 1.2 + BB);
% retImg = (A + T1*fn + BB*fm);                   %（0.2,0.4）
retImg = (B1*f1 + B2*f2 + B3*f3 + B4*f4 + BB*f5 + BQZ*f6 + T1*f7 + A *f8);                   %（0.2,0.4）

