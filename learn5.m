clc
clear
%% ϵͳ��������
%pic_address='F:\mat\���԰�\ORL\s';%ͼƬ�ı����ַ
%m=strcat(pic_address,int2str(1),'_',int2str(1),'.bmp');
pic='F:\mat\pic\zyh_mask.jpg';
pic='F:\mat\pic\����.JPG';  %tim1.jpg
% pic='F:\mat\pic\���� 100x100.JPG';  %tim1.jpg
% pic='F:\mat\pic\ylj_mask.png';  %tim1.jpg
pic='F:\mat\pic\zyh.jpg';
r=3;
c=3;
%1����ȡͼƬ
img=imread(pic);
[x,y,z]=size(img)
    if(z>1)
        A=rgb2gray(img);
    else
        A=img;
    end  
    %% ����1�ĵڶ��ַ��������Ժܴ�̶��Ͻ�ʡ����ʱ��
    [m,n,z] = size(A)
    
%% ��ͼƬ�������������ת����ʹ����������������

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
SS=(B1-B2)+(B3-B4);

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
        if(BQZ(i,j) < ave*0.1)
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
% A11 = A/255 * 1.0
% 
% TT1 = sin(A11);
% TTR = (y+2)/2 * 255;

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
AA2=(A+BB)- SS*8;   %ʶ���ʽϸߣ�������Ϊ3.5��ʱ��ʶ�������   ORL���Կ���Ϊ98.5%   AA2=(A+BB)- SS*3.5;   A+(BB-SS*3.5);   AA2=(A+BB)- SS*(4~7)���Դﵽ100%;

% -91.1522019853535,-498.025397652447,25.0968251127402,-82.329816001429,-2382.14586008598,-609.517994723438,-1886.09588114121,-430.839077845546
% ,,,,,,,

%% ͼ�����������ķ���ֵ
% retImg = (A - BQZ * 1.2 + BB);
% retImg = (A + T1*fn + BB*fm);                   %��0.2,0.4��
% retImg = (B1*f1 + B2*f2 + B3*f3 + B4*f4 + BB*f5 + BQZ*f6 + T1*f7 + A *f8);                   %��0.2,0.4��
retImg = (B1*-91.1522019853535 + B2*-498.025397652447 + B3*25.0968251127402 + B4*-82.329816001429 + BB*-2382.14586008598 + BQZ*-609.517994723438 + T1*-1886.09588114121 + A *-430.839077845546);                   %��0.2,0.4��


%% ͼ����ʾ��
figure(1)
subplot(r,c,1),imshow(255-SS)
%%
%  TEXT
% 
subplot(r,c,2),imshow((255-B1))
subplot(r,c,3),imshow(255-(B2))
subplot(r,c,4),imshow(255-(B3))
subplot(r,c,5),imshow(255-(B4))

subplot(r,c,6),imshow(255-BB)
subplot(r,c,7),imshow(255-BQZ)
subplot(r,c,8),imshow(255-T1)

subplot(r,c,9),imshow(255-retImg)


%% ������ھ�ֵ����ֵ��
%     B11 = B1;
%     for i=1:m
%         for j=1:n
%             if B1(i,j) <= ave
%                 B11(i,j) = B1(i,j)- B1(i,j);
%             else
%                 if(i>=2 && i<m-1)
%                     if B11(i-1,j)<ave
%                         B11(i-1,j) =  B1(i,j);
%                     end
%                     if B11(i-1,j-1)<ave
%                         B11(i-1,j-1) =  B1(i,j);
%                     end
%                     if B11(i-1,j+1)<ave
%                         B11(i-1,j+1) =  B1(i,j);
%                     end
%                     if B11(i+1,j)<ave
%                         B11(i+1,j) =  B1(i,j);
%                     end
%                 end
%             end
%         end
%     end