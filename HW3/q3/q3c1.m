clc
clear
% load MINST
load('../MNIST_database')
%   A0206597U-> NO:9,7 ->0,1,2,3,4,5,6,8
%   Train data
trainIdx = find(train_classlabel~=9 & train_classlabel~=7); % find the location of classes 
TrLabel = train_classlabel(trainIdx);
Train_Data = train_data(:,trainIdx);
% SOM
%   initialization
neurons = zeros(784,10,10);
sigma0 = sqrt(10^2+10^2)/2;
for epoch = 1:1000
    lr = 0.1*exp(-epoch/1000);
    sigma = sigma0*exp(-epoch/(1000/log(sigma0)));
    for i = 1:size(Train_Data,2)
        dis = squeeze(sum((Train_Data(:,i) - neurons).^2,1))';
        [~,winner] = min(dis,[],'all','linear');
        k = ceil(winner/10);
        n = winner - (k-1)*10;
        d_j = ([1:10] - n).^2;
        d_i = ([1:10] - k).^2;
        d_square = d_j' + d_i;
        h = exp(-d_square./(2*sigma^2)); 
        % Update
        h = permute(repmat(h,[1,1,784]),[3 2 1]);
        neurons = neurons + lr*h.*(Train_Data(:,i) - neurons);
    end
end
maplabel = [0,6,6,6,6,6,6,4,4,4;...
    0,0,6,6,6,6,6,4,4,4;...
    0,0,0,0,6,6,2,4,4,4;...
    0,0,0,2,2,2,2,2,4,4;...
    0,0,0,2,2,2,2,2,2,1;...
    3,3,8,8,8,8,8,2,1,1;...
    3,3,3,8,8,8,8,8,1,1;...
    3,3,8,8,8,8,8,5,1,1;...
    3,3,8,8,8,5,5,5,1,1;...
    3,3,8,8,5,5,5,5,1,1;];
f = figure;
f.WindowState = 'maximized' ;
for n = 1:10
    for k = 1:10
        subplot(10,10,(n-1)*10+k)
        imshow(reshape(neurons(:,n,k),28,28))
        title(sprintf('%d',maplabel(n,k)))
    end
end
save('neurons','neurons','maplabel')