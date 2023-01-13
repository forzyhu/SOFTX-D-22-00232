clc
clear
pic_address='F:\mat\测试包\MU_PIE_Face\CMU_PIE_Face\Pose29_64x64_files\';%图片的保存地址
% pic_address='F:\mat\测试包\口罩测试图\CMU_PIE_Face_Pose09_64x64_files\';%口罩测试图
train_img=[];%训练图片的向量集
train_lab=[]; %训练图片的结果集

rols=6;%表示将已知图片在行方向上分解为多少个子图,用于将图片分块
cols=6;%表示将已知图片在列方向上分解为多少个子图,用于将图片分块

Man_num=68;%取多少个人进行训练，图片的命名方式为sx_y，其中x代表不同的人，y代表同一个人的不同图像
Fig_num=24;%每种图片读取的数量

%训练样本参数设置
Train_num=18;  %用于训练样本的数量，需要更改时，只需要该该值即可

%训练样本参数设置
Train_num_start=1;%训练样本开始数值，既从每个人的第几张图片开始进行训练
Train_num_end=Train_num;%训练样本结束数值，既到每个人的第几张图片结束进行训练        改变该值实现训练数量切换
%模拟测试样本参数设置
Fig_num_start=Train_num_end+1;%测试样本开始数值，既从每个人的第几张图片开始进行仿真
Fig_num_end=24;%测试样本结束数值，既到每个人的第几张图片结束进行仿真

%% 进入循环并记录
for XunHuan = 10:Train_num_end
    Train_num_end = XunHuan;
    Fig_num_start=Train_num_end+1;%测试样本开始数值，既从每个人的第几张图片开始进行仿真
    
for Man_i=1:Man_num
    for Fig_j=1:Fig_num   
        num=(Man_i-1)*Fig_num+Fig_j;
        m=strcat(pic_address,int2str(num),'.jpg');
        %1、读取图片
        img=imread(m);
        [x,y,z]=size(img);
        if(z>1)
            img=rgb2gray(img);
        end        
        
        %2特征值提取
        %2.1、提取图片的特征值
%         img=LBP_fun_new(img);%96.6667
%         img=LBP_fun(img);%
%         img=CZ_Fun(img);%
%         img=ZYH_XJ(img);
%         img=LBP_FuBo(img);%77
%         img=LBP_Old(img);%77
%         [A img ]=LBP_zyh_Tm_Tn(img);
%         img=LBP(img);
%         img = WLCGP_Function(img);   %WLCGP函数
%         img=Zyh_std(img);
%         [CLBP_S,CLBP_M,CLBP_C,img2]=clbp_modify(img,2,8,'x');  %CLBP算法

        [img]=Artictl_SCI4_Zyh_Fun_CZYW(img,-2.8507,17.3508,24.5187,8.8568,-4.6288,8.6714,20.4349,-1.5919);%    论文4的算法    (0.2,0.4) YALE推荐  
%           [img]=Artictl_SCI4_Zyh_Fun_CZYW(img,3.5284,2.3740,-4.2648,0.8642,3.0010,-2.4942,15.6236,0.3061);%    论文4的算法    (0.2,0.4)  ORL推荐
%         [img]=Artictl_SCI4_Zyh_Fun_CZYW(img,0.4659,1.4555,1.7143,2.5508,-0.0499,2.2975,-0.0088,0.1338);%    论文4的算法    (0.2,0.4)
%         [img]=Artictl_SCI3_Zyh_Fun_CZYW(img,1,2);%97%             论文3的算法    (0.2,0.4)
%         [x c img]=Artictl_SCI2_Zyh_Fun_IGCO(img,1.101);%          论文2的算法
%         [x c img]=Artictl_SCI1_Zyh_Fun_CZYW(img);%97%             论文1的算法     

        %2.2、将图片分解为若干各子图片，求各个子图片的直方图，并串联成一个特征值；
        img2=Picture_to_small(img,rols,cols);
        %4、形成特征向量矩阵train_img
        train_img = cat(1,train_img,img2);  %行方向组合（行数不断增加）
        train_lab = cat(1,train_lab,Man_i);
    end
end


%% 二、分离训练集train_Img、train_Lab  和验证集（测试集）test_Img、test_Lab
train_Img=[];       %训练集特征数据
train_Lab=[];       %训练集分类
test_Img=[];        %测试集特征数据
test_Lab=[];        %测试集分类

% %方法1：
for i=1:Man_num
    for j=1:Fig_num
        (i-1)*Fig_num + j;
        if(j>=Train_num_start &j<=Train_num_end)
            %提取训练集
            train_Img=[train_Img;train_img((i-1)*Fig_num + j,:)];
            train_Lab=[train_Lab;train_lab((i-1)*Fig_num + j,:)];
        end
        if(j>=Fig_num_start &j<=Fig_num_end)
            %提取模拟仿真集
            test_Img=[test_Img;train_img((i-1)*Fig_num + j,:)];
            test_Lab=[test_Lab;train_lab((i-1)*Fig_num + j,:)];
        end
    end 
end
%方法2：对半取值
% train_Img = train_img(1:2:400,:);
% train_Lab = train_lab(1:2:400,:);
% test_Img = train_img(2:2:400,:);
% test_Lab = train_lab(2:2:400,:);

%% 三、使用PCA对数据进行将维处理
% 3.1、 使用系统自带函数pca进行将维处理
    % 3.1.2、对特征向量矩阵进行PCA转换（及降维处理），将特征值压缩
    % [coeff score latent x ]=pca(train_Img);
    % train_Img = score(:,1:85)

    %         %选取当特征值的累计贡献率大于XX(0.95)以上的有效特征值
    %         uu = cumsum(latent)./sum(latent);         %用来计算准确率
    %         a=size(uu);
    %         num=1;
    %         for i=1:a(1)
    %             if(uu(i)>0.95)
    %                 num=i;
    %                 break;
    %             end
    %         end
    %         test_Img = score(:,1:50);

    % 3.1.2、测试集的PCA将维处理
    % [coeff score latent x ]=pca(test_Img);
    % test_Img = score(:,1:85);

% 3.2、使用自定义函数PCA进行降维
     [S train_Img test_Img] = PCA(train_Img,test_Img);% %此处借用了PCA函数，对训练集和测试集的数据进行将维

%% 四、SVM向量机训练 

%% 4.1.求SVM的最优的参数 
%SVM创建/训练(RBF核函数)        该部分代码主要用于寻求SVM的最佳参数c/g
% %%
% % 1. 寻找最佳c/g参数——交叉验证方法
% [c,g] = meshgrid(-10:0.4:10,-10:0.4:10);
% [m,n] = size(c);
% cg = zeros(m,n);
% eps = 10^(-4);
% v = 5;
% bestc = 1;
% bestg = 0.1;
% bestacc = 0;
% for i = 1:m
%     for j = 1:n
%         cmd = ['-v ',num2str(v),' -t 2',' -c ',num2str(2^c(i,j)),' -g ',num2str(2^g(i,j))];
%         cg(i,j) = libsvmtrain(train_Lab,train_Img,cmd);     
%         if cg(i,j) > bestacc
%             bestacc = cg(i,j);
%             bestc = 2^c(i,j);
%             bestg = 2^g(i,j);
%         end        
%         if abs( cg(i,j)-bestacc )<=eps && bestc > 2^c(i,j) 
%             bestacc = cg(i,j);
%             bestc = 2^c(i,j);
%             bestg = 2^g(i,j);
%         end               
%     end
% end

%% 4.2.. 数据归一化
% [Train_matrix,PS] = mapminmax(train_matrix');       %mapminmax为matlab提供的归一化处理函数，返回的值列为一个数据值，行为特征数，所以需要将其转置；
% Train_matrix = Train_matrix';
% Test_matrix = mapminmax('apply',test_matrix',PS);
% Test_matrix = Test_matrix';

%% 4.3 对SVM进行训练
% SVM参数设置                                    % 0.00375  时LBP为95.5%    zyh_fun_czyw AA为98%   AA2为97.5% 
% cmd='-s 0 -t 2 -c 16 -g 0.000976562500000000  ';
% cmd='-s 0 -t 2 -c 3.4822 -g 0.0103  '      % articl2 戴口罩图像
% cmd='-s 0 -t 2 -c 1.1487 -g 0.0206  '        % articl2 戴口罩图像
cmd='-s 0 -t 2 -c 16 -g 0.0068  '       %MU_PIE最优
%% 4.4 开始训练并获得结果模型model
model = libsvmtrain(train_Lab,train_Img,cmd);

%% 五、对SVM进行模拟仿真测试
[py,accuracy,decision_values] = libsvmpredict(test_Lab,test_Img,model);
py;

%%保存准确度，然后继续循环
result(XunHuan,1) = XunHuan;
result(XunHuan,2) = accuracy(1);
end
result'


% %% 使用循环的代码
% for XunHuan = 1:Train_num_end
%     Train_num_end = XunHuan;
%     Fig_num_start=Train_num_end+1;%测试样本开始数值，既从每个人的第几张图片开始进行仿真
%     
%     
%     %%保存准确度，然后继续循环
%     result(XunHuan,1) = XunHuan;
%     result(XunHuan,2) = accuracy(1);
% end
% result'               %显示结果