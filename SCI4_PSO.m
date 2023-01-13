function [BGest_Fv,BGest_X] = SCI4_PSO(particlesize,maxnum,c1,c2,w)
%% ��ʼ������Ⱥ��λ�ã��ٶ�
FxNum = 8;  % ϵ���ĸ���
MaxPosition = 10;

x=(rand(particlesize,FxNum)*MaxPosition-MaxPosition/2)%��������λ��
v=(rand(particlesize,FxNum)*2-1)%���ӷ����ٶ�

% �����ӳ�ʼ״̬�µ���Ӧ��
for i=1:particlesize
	[f(i)]=SCI4_Edge_fitness_ORL(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%     [f(i)]=SCI4_Edge_fitness_YALE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%     [f(i)]=SCI4_Edge_fitness_MU_PIE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
end
% ��ʼ�����ӳ�ʼ״̬�µĸ������š�����������Ӧ��
personalbest_x=x;
personalbest_faval=f;
[globalbest_faval,i]=max(personalbest_faval);
globalbest_x=personalbest_x(i,:);

MaxLose = 0;

%% ʹ�õ�ǰλ����Ϣ����ʼ����ѭ����
for k=1:maxnum
   %�����µ�׼ȷ�ʣ�    
    % �����ٶ�
    for i=1:particlesize
        % �����ٶ�
        v(i,:)=w*v(i,:)+c1*rand*(personalbest_x(i,:)-x(i,:))+c2*rand*(globalbest_x-x(i,:)); 
        % �����ٶȳ����߽�����
        for j = 1:1:FxNum
%              if (v(i,j))> MaxPosition   ���ܱ߽�����
             if abs(v(i,j))> MaxPosition
                 v(i,j) = mod(v(i,j),MaxPosition);
             end
        end
        
        % ����λ��
        x = x + v;
        % ����λ�ó����߽�����
        for j = 1:1:FxNum
%              if (v(i,j))> MaxPosition   ���ܱ߽�����
             if abs(x(i,j))> MaxPosition
                 x(i,j) = mod(x(i,j),MaxPosition);
             end
        end
     end
    
    % ���ٶȸ���֮���׼ȷ��
	for i=1:particlesize		
        	[f(i)]=SCI4_Edge_fitness_ORL(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%             [f(i)]=SCI4_Edge_fitness_YALE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%         [f(i)]=SCI4_Edge_fitness_MU_PIE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
        
        % ��������Ž�
		if f(i)>personalbest_faval(i)
			personalbest_faval(i)=f(i);
			personalbest_x(i,:)=[x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8)];
        end
        % �жϼ������Ž�
        if globalbest_faval < f(i)
            globalbest_faval = f(i);
            globalbest_x=personalbest_x(i,:);
        else
            MaxLose = MaxLose + 1;
        end
    end
    
    % ���¼������ŵ���Ӧ�ȼ���Ӧ��λ�ã����䷽����
% 	[globalbest_faval,i]=max(personalbest_faval);
% 	globalbest_x=personalbest_x(i,:);
    
    % �������δ�������Ž�Ĵ����Ƿ񳬹�50�����ǣ����˳�ѭ��
    if MaxLose > 30
        break;
    end
end
f
BGest_Fv = globalbest_faval;
BGest_X = globalbest_x;
