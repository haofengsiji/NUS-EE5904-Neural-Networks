clc
clear
% construct data
rng(520) % reproduce seed
train_x = -1:0.05:1;
train_y = 1.2*sin(pi*train_x)-cos(2.4*pi*train_x)+0.3*randn(1,size(train_x,2));
test_x = -1:0.01:1;
test_y = 1.2*sin(pi*test_x)-cos(2.4*pi*test_x);
% RBF matrix
r = abs(train_x' - train_x);
RBF = exp(-r.^2./2/0.1^2);
w = RBF^-1*train_y';
% predict on test
r = abs(test_x' - train_x);
RBF = exp(-r.^2./2/0.1^2);
pred_y = (RBF*w)';
hold on
plot(train_x,train_y,'o')
plot(test_x,pred_y)
plot(test_x,test_y)
legend('Train points','RBFN','Ground Truth','Location','northwest')
% mean square error on test
MSE_test = sum((pred_y - test_y).^2)/size(pred_y,2);
% predict on train
r = abs(train_x' - train_x);
RBF = exp(-r.^2./2/0.1^2);
pred_y = (RBF*w)';
% mean square error on train
MSE_train = sum((pred_y - train_y).^2)/size(pred_y,2);


