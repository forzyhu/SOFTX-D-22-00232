clc
clear
% load('ORL_Data.mat');   %可以去除
% task(3,1);
% Num = size(ORL_Data)
%% 参数设置
maxnum=100;%最大迭代次数
c1=1.5;%每个粒子的个体学习因子，加速度常数
c2=1.5;%每个粒子的社会学习因子，加速度常数
w=0.4;%惯性因子
particlesize=5;%粒子群规模

%% 只运行一次
% [fv,value]  =  SCI4_PSO(particlesize,maxnum,c1,c2,w)


%% 运行10次，产生10次推荐
for i=1:1:10
    [fv,value]  =  SCI4_PSO(particlesize,maxnum,c1,c2,w)
    FVA(i) = fv;
    ValueA(i,:) = value;
end
ValueA
