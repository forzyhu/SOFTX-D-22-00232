% function [S,F] = PCA(in)
function [S,F,F1] = PCA(in,X)
% 利用PCA对人脸数据进行特征降维
% S : PCA降维转换矩阵，当训练数据时输出，测试数据与给定的scale相同
    ratio = 0.95;
    [coeff, score, latent] = pca(in);%PCA降维
    energy = cumsum(latent) ./ sum(latent);
    [m,n] = size(energy);
    dim= 3;
    for k = 1 : m
        if energy(k) > ratio
            dim = k;
            break;
        end
    end  
    S = coeff(:, 1 : dim); 
    F = score(:, 1 : dim);
    F1 = bsxfun(@minus, X, mean(X, 1)) *S;
end
