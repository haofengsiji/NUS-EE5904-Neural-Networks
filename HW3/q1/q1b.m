clc
clear
% construct data
rng(520) % reproduce seed
train_x = -1:0.05:1;
train_y = 1.2*sin(pi*train_x)-cos(2.4*pi*train_x)+0.3*randn(1,size(train_x,2));
test_x = -1:0.01:1;
test_y = 1.2*sin(pi*test_x)-cos(2.4*pi*test_x);
% Choose centers
rand_cens = datasample(train_x,15,2);
% Training
r = abs(train_x' - rand_cens);
RBF = exp(-r.^2./2/0.1^2);
w = pinv(RBF)*train_y';
% Train accuracy
r = abs(train_x' - rand_cens);
RBF = exp(-r.^2./2/0.1^2);
pred_y = (RBF*w)';
MSE_train = sum((pred_y - train_y).^2)/size(pred_y,2);
% Test accuracy
r = abs(test_x' - rand_cens);
RBF = exp(-r.^2./2/0.1^2);
pred_y = (RBF*w)';
MSE_test = sum((pred_y - test_y).^2)/size(pred_y,2);
% plot result
hold on
plot(train_x,train_y,'o')
plot(test_x,pred_y)
plot(test_x,test_y)
legend('Train points','RBFN','Ground Truth','Location','northwest')
