clc
clear
% load('ORL_Data.mat');   %����ȥ��
% task(3,1);
% Num = size(ORL_Data)
%% ��������
maxnum=100;%����������
c1=1.5;%ÿ�����ӵĸ���ѧϰ���ӣ����ٶȳ���
c2=1.5;%ÿ�����ӵ����ѧϰ���ӣ����ٶȳ���
w=0.4;%��������
particlesize=5;%����Ⱥ��ģ

%% ֻ����һ��
% [fv,value]  =  SCI4_PSO(particlesize,maxnum,c1,c2,w)


%% ����10�Σ�����10���Ƽ�
for i=1:1:10
    [fv,value]  =  SCI4_PSO(particlesize,maxnum,c1,c2,w)
    FVA(i) = fv;
    ValueA(i,:) = value;
end
ValueA
