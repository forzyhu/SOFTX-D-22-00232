clc
clear
pic_address='F:\mat\���԰�\MU_PIE_Face\CMU_PIE_Face\Pose29_64x64_files\';%ͼƬ�ı����ַ
% pic_address='F:\mat\���԰�\���ֲ���ͼ\CMU_PIE_Face_Pose09_64x64_files\';%���ֲ���ͼ
train_img=[];%ѵ��ͼƬ��������
train_lab=[]; %ѵ��ͼƬ�Ľ����

rols=6;%��ʾ����֪ͼƬ���з����Ϸֽ�Ϊ���ٸ���ͼ,���ڽ�ͼƬ�ֿ�
cols=6;%��ʾ����֪ͼƬ���з����Ϸֽ�Ϊ���ٸ���ͼ,���ڽ�ͼƬ�ֿ�

Man_num=68;%ȡ���ٸ��˽���ѵ����ͼƬ��������ʽΪsx_y������x����ͬ���ˣ�y����ͬһ���˵Ĳ�ͬͼ��
Fig_num=24;%ÿ��ͼƬ��ȡ������

%ѵ��������������
Train_num=18;  %����ѵ����������������Ҫ����ʱ��ֻ��Ҫ�ø�ֵ����

%ѵ��������������
Train_num_start=1;%ѵ��������ʼ��ֵ���ȴ�ÿ���˵ĵڼ���ͼƬ��ʼ����ѵ��
Train_num_end=Train_num;%ѵ������������ֵ���ȵ�ÿ���˵ĵڼ���ͼƬ��������ѵ��        �ı��ֵʵ��ѵ�������л�
%ģ�����������������
Fig_num_start=Train_num_end+1;%����������ʼ��ֵ���ȴ�ÿ���˵ĵڼ���ͼƬ��ʼ���з���
Fig_num_end=24;%��������������ֵ���ȵ�ÿ���˵ĵڼ���ͼƬ�������з���

%% ����ѭ������¼
for XunHuan = 10:Train_num_end
    Train_num_end = XunHuan;
    Fig_num_start=Train_num_end+1;%����������ʼ��ֵ���ȴ�ÿ���˵ĵڼ���ͼƬ��ʼ���з���
    
for Man_i=1:Man_num
    for Fig_j=1:Fig_num   
        num=(Man_i-1)*Fig_num+Fig_j;
        m=strcat(pic_address,int2str(num),'.jpg');
        %1����ȡͼƬ
        img=imread(m);
        [x,y,z]=size(img);
        if(z>1)
            img=rgb2gray(img);
        end        
        
        %2����ֵ��ȡ
        %2.1����ȡͼƬ������ֵ
%         img=LBP_fun_new(img);%96.6667
%         img=LBP_fun(img);%
%         img=CZ_Fun(img);%
%         img=ZYH_XJ(img);
%         img=LBP_FuBo(img);%77
%         img=LBP_Old(img);%77
%         [A img ]=LBP_zyh_Tm_Tn(img);
%         img=LBP(img);
%         img = WLCGP_Function(img);   %WLCGP����
%         img=Zyh_std(img);
%         [CLBP_S,CLBP_M,CLBP_C,img2]=clbp_modify(img,2,8,'x');  %CLBP�㷨

        [img]=Artictl_SCI4_Zyh_Fun_CZYW(img,-2.8507,17.3508,24.5187,8.8568,-4.6288,8.6714,20.4349,-1.5919);%    ����4���㷨    (0.2,0.4) YALE�Ƽ�  
%           [img]=Artictl_SCI4_Zyh_Fun_CZYW(img,3.5284,2.3740,-4.2648,0.8642,3.0010,-2.4942,15.6236,0.3061);%    ����4���㷨    (0.2,0.4)  ORL�Ƽ�
%         [img]=Artictl_SCI4_Zyh_Fun_CZYW(img,0.4659,1.4555,1.7143,2.5508,-0.0499,2.2975,-0.0088,0.1338);%    ����4���㷨    (0.2,0.4)
%         [img]=Artictl_SCI3_Zyh_Fun_CZYW(img,1,2);%97%             ����3���㷨    (0.2,0.4)
%         [x c img]=Artictl_SCI2_Zyh_Fun_IGCO(img,1.101);%          ����2���㷨
%         [x c img]=Artictl_SCI1_Zyh_Fun_CZYW(img);%97%             ����1���㷨     

        %2.2����ͼƬ�ֽ�Ϊ���ɸ���ͼƬ���������ͼƬ��ֱ��ͼ����������һ������ֵ��
        img2=Picture_to_small(img,rols,cols);
        %4���γ�������������train_img
        train_img = cat(1,train_img,img2);  %�з�����ϣ������������ӣ�
        train_lab = cat(1,train_lab,Man_i);
    end
end


%% ��������ѵ����train_Img��train_Lab  ����֤�������Լ���test_Img��test_Lab
train_Img=[];       %ѵ������������
train_Lab=[];       %ѵ��������
test_Img=[];        %���Լ���������
test_Lab=[];        %���Լ�����

% %����1��
for i=1:Man_num
    for j=1:Fig_num
        (i-1)*Fig_num + j;
        if(j>=Train_num_start &j<=Train_num_end)
            %��ȡѵ����
            train_Img=[train_Img;train_img((i-1)*Fig_num + j,:)];
            train_Lab=[train_Lab;train_lab((i-1)*Fig_num + j,:)];
        end
        if(j>=Fig_num_start &j<=Fig_num_end)
            %��ȡģ����漯
            test_Img=[test_Img;train_img((i-1)*Fig_num + j,:)];
            test_Lab=[test_Lab;train_lab((i-1)*Fig_num + j,:)];
        end
    end 
end
%����2���԰�ȡֵ
% train_Img = train_img(1:2:400,:);
% train_Lab = train_lab(1:2:400,:);
% test_Img = train_img(2:2:400,:);
% test_Lab = train_lab(2:2:400,:);

%% ����ʹ��PCA�����ݽ��н�ά����
% 3.1�� ʹ��ϵͳ�Դ�����pca���н�ά����
    % 3.1.2�������������������PCAת��������ά������������ֵѹ��
    % [coeff score latent x ]=pca(train_Img);
    % train_Img = score(:,1:85)

    %         %ѡȡ������ֵ���ۼƹ����ʴ���XX(0.95)���ϵ���Ч����ֵ
    %         uu = cumsum(latent)./sum(latent);         %��������׼ȷ��
    %         a=size(uu);
    %         num=1;
    %         for i=1:a(1)
    %             if(uu(i)>0.95)
    %                 num=i;
    %                 break;
    %             end
    %         end
    %         test_Img = score(:,1:50);

    % 3.1.2�����Լ���PCA��ά����
    % [coeff score latent x ]=pca(test_Img);
    % test_Img = score(:,1:85);

% 3.2��ʹ���Զ��庯��PCA���н�ά
     [S train_Img test_Img] = PCA(train_Img,test_Img);% %�˴�������PCA��������ѵ�����Ͳ��Լ������ݽ��н�ά

%% �ġ�SVM������ѵ�� 

%% 4.1.��SVM�����ŵĲ��� 
%SVM����/ѵ��(RBF�˺���)        �ò��ִ�����Ҫ����Ѱ��SVM����Ѳ���c/g
% %%
% % 1. Ѱ�����c/g��������������֤����
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

%% 4.2.. ���ݹ�һ��
% [Train_matrix,PS] = mapminmax(train_matrix');       %mapminmaxΪmatlab�ṩ�Ĺ�һ�������������ص�ֵ��Ϊһ������ֵ����Ϊ��������������Ҫ����ת�ã�
% Train_matrix = Train_matrix';
% Test_matrix = mapminmax('apply',test_matrix',PS);
% Test_matrix = Test_matrix';

%% 4.3 ��SVM����ѵ��
% SVM��������                                    % 0.00375  ʱLBPΪ95.5%    zyh_fun_czyw AAΪ98%   AA2Ϊ97.5% 
% cmd='-s 0 -t 2 -c 16 -g 0.000976562500000000  ';
% cmd='-s 0 -t 2 -c 3.4822 -g 0.0103  '      % articl2 ������ͼ��
% cmd='-s 0 -t 2 -c 1.1487 -g 0.0206  '        % articl2 ������ͼ��
cmd='-s 0 -t 2 -c 16 -g 0.0068  '       %MU_PIE����
%% 4.4 ��ʼѵ������ý��ģ��model
model = libsvmtrain(train_Lab,train_Img,cmd);

%% �塢��SVM����ģ��������
[py,accuracy,decision_values] = libsvmpredict(test_Lab,test_Img,model);
py;

%%����׼ȷ�ȣ�Ȼ�����ѭ��
result(XunHuan,1) = XunHuan;
result(XunHuan,2) = accuracy(1);
end
result'


% %% ʹ��ѭ���Ĵ���
% for XunHuan = 1:Train_num_end
%     Train_num_end = XunHuan;
%     Fig_num_start=Train_num_end+1;%����������ʼ��ֵ���ȴ�ÿ���˵ĵڼ���ͼƬ��ʼ���з���
%     
%     
%     %%����׼ȷ�ȣ�Ȼ�����ѭ��
%     result(XunHuan,1) = XunHuan;
%     result(XunHuan,2) = accuracy(1);
% end
% result'               %��ʾ���