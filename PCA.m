% function [S,F] = PCA(in)
function [S,F,F1] = PCA(in,X)
% ����PCA���������ݽ���������ά
% S : PCA��άת�����󣬵�ѵ������ʱ��������������������scale��ͬ
    ratio = 0.95;
    [coeff, score, latent] = pca(in);%PCA��ά
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
