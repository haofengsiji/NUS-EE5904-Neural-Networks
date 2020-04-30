clc
clear
% Train data
rng(720) % reproducibility
trainX = rands(2,500); % 2x500 matrix, column-wise points
% SOM
%   initialization
neurons = randn(2,5,5);
sigma0 = sqrt(5^2+5^2)/2;
for epoch = 1:500
    lr = 0.1*exp(-epoch/500);
    sigma = sigma0*exp(-epoch/(500/log(sigma0)));
    for i = 1:size(trainX,2)
        dis = squeeze(sum((trainX(:,i) - neurons).^2,1))';
        [~,winner] = min(dis,[],'all','linear');
        k = ceil(winner/5);
        n = winner - (k-1)*5;
        d_j = ([1:5] - n).^2;
        d_i = ([1:5] - k).^2;
        d_square = d_j' + d_i;
        h = exp(-d_square./(2*sigma^2)); 
        % Update
        h = permute(repmat(h,[1,1,2]),[3 2 1]);
        neurons = neurons + lr*h.*(trainX(:,i) - neurons);
    end
end
% plot
plot(trainX(1,:),trainX(2,:),'+r');
hold on 
for i = 1:5
    for j = 1:5
        % left and right neighbors
        if i+1 <= 5
            plot([neurons(1,i,j),neurons(1,i+1,j)],[neurons(2,i,j),neurons(2,i+1,j)],'bo-')
        end
        % top and bottom neighbors
        if j+1 <= 5
            plot([neurons(1,i,j),neurons(1,i,j+1)],[neurons(2,i,j),neurons(2,i,j+1)],'bo-')
        end
    end
end
hold off
