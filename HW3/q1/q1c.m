clc
clear
% construct data
rng(520) % reproduce seed
train_x = -1:0.05:1;
train_y = 1.2*sin(pi*train_x)-cos(2.4*pi*train_x)+0.3*randn(1,size(train_x,2));
test_x = -1:0.01:1;
test_y = 1.2*sin(pi*test_x)-cos(2.4*pi*test_x);
MSE_train = [];
MSE_test = [];
for i = [0,0.1,1,10,100]
    % Training
    lambda = i;
    r = abs(train_x' - train_x);
    RBF = exp(-r.^2./2/0.1^2);
    w =pinv(RBF'*RBF+lambda*eye(size(RBF,2)))*RBF'*train_y';
    % Train
    r = abs(train_x' - train_x);
    RBF = exp(-r.^2./2/0.1^2);
    pred_y = (RBF*w)';
    MSE_train = [MSE_train;sum((pred_y - train_y).^2)/size(pred_y,2)];
    % Test
    r = abs(test_x' - train_x);
    RBF = exp(-r.^2./2/0.1^2);
    pred_y = (RBF*w)';
    MSE_test = [MSE_test;sum((pred_y - test_y).^2)/size(pred_y,2)];
    % Plot
    fig = figure();
    hold on
    plot(train_x,train_y,'o')
    plot(test_x,pred_y)
    plot(test_x,test_y)
    legend('Train points','RBFN','Ground Truth','Location','northwest')
    title(join(['\lambda=',sprintf('%.1f',i)]))
    hold off
    saveas(fig,sprintf('lambda_%.1f.png',i))
end
