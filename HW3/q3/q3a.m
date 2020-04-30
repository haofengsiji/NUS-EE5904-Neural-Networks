clc
clear
% Train data
t = linspace(-pi,pi,200);
trainX = [t.*sin(pi*sin(t)./t); 1-abs(t).*cos(pi*sin(t)./t)]; % 2x200 matrix, column-wise points
% SOM
%   initialization
neurons = zeros(2,25);
sigma0 = sqrt(25^2+1)/2;
for epoch = 1:500
    lr = 0.1*exp(-epoch/500);
    sigma = sigma0*exp(-epoch/(500/log(sigma0)));
    for i = 1:size(trainX,2)
        dis = sum((trainX(:,i) - neurons).^2,1);
        [~,winner] = min(dis,[],2);
        d = abs([1:25]-winner);
        h = exp(-d.^2/(2*sigma^2));
        % Update
        neurons = neurons + lr*h.*(trainX(:,i) - neurons);
    end
end
hold on
plot(trainX(1,:),trainX(2,:),'+r');
plot(neurons(1,:),neurons(2,:),'o-');
hold off







