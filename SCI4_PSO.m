function [BGest_Fv,BGest_X] = SCI4_PSO(particlesize,maxnum,c1,c2,w)
%% 初始化粒子群的位置，速度
FxNum = 8;  % 系数的个数
MaxPosition = 10;

x=(rand(particlesize,FxNum)*MaxPosition-MaxPosition/2)%粒子所在位置
v=(rand(particlesize,FxNum)*2-1)%粒子飞翔速度

% 求粒子初始状态下的适应度
for i=1:particlesize
	[f(i)]=SCI4_Edge_fitness_ORL(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%     [f(i)]=SCI4_Edge_fitness_YALE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%     [f(i)]=SCI4_Edge_fitness_MU_PIE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
end
% 初始化粒子初始状态下的个人最优、集体最优适应度
personalbest_x=x;
personalbest_faval=f;
[globalbest_faval,i]=max(personalbest_faval);
globalbest_x=personalbest_x(i,:);

MaxLose = 0;

%% 使用当前位置信息，开始迭代循环，
for k=1:maxnum
   %求最新的准确率；    
    % 更新速度
    for i=1:particlesize
        % 更新速度
        v(i,:)=w*v(i,:)+c1*rand*(personalbest_x(i,:)-x(i,:))+c2*rand*(globalbest_x-x(i,:)); 
        % 处理速度超过边界的情况
        for j = 1:1:FxNum
%              if (v(i,j))> MaxPosition   不受边界限制
             if abs(v(i,j))> MaxPosition
                 v(i,j) = mod(v(i,j),MaxPosition);
             end
        end
        
        % 更新位置
        x = x + v;
        % 处理位置超过边界的情况
        for j = 1:1:FxNum
%              if (v(i,j))> MaxPosition   不受边界限制
             if abs(x(i,j))> MaxPosition
                 x(i,j) = mod(x(i,j),MaxPosition);
             end
        end
     end
    
    % 求速度更新之后的准确率
	for i=1:particlesize		
        	[f(i)]=SCI4_Edge_fitness_ORL(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%             [f(i)]=SCI4_Edge_fitness_YALE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
%         [f(i)]=SCI4_Edge_fitness_MU_PIE(x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8));
        
        % 求个体最优解
		if f(i)>personalbest_faval(i)
			personalbest_faval(i)=f(i);
			personalbest_x(i,:)=[x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8)];
        end
        % 判断集体最优解
        if globalbest_faval < f(i)
            globalbest_faval = f(i);
            globalbest_x=personalbest_x(i,:);
        else
            MaxLose = MaxLose + 1;
        end
    end
    
    % 更新集体最优的适应度及对应的位置（分配方案）
% 	[globalbest_faval,i]=max(personalbest_faval);
% 	globalbest_x=personalbest_x(i,:);
    
    % 检查连续未检测出最优解的次数是否超过50，若是，则退出循环
    if MaxLose > 30
        break;
    end
end
f
BGest_Fv = globalbest_faval;
BGest_X = globalbest_x;
