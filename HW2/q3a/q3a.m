clc
clear
% load data
%   train_images (256*256,samples)
%   train_labels (1,samples)
%   val_images (256*256,samples)
%   val_labels (1,samples)
load('SceneData')
% specify the structure and learning algorithm for MLP
net = perceptron();
net = configure(net,train_images,train_labels);
net.trainparam.lr=0.01;
net.trainparam.epochs=1000;
net.trainparam.goal=1e-9;
net.divideParam.trainRatio=1.0;
net.divideParam.valRatio=0.0;
net.divideParam.testRatio=0.0;
% Train the MLP
[net,tr]=train(net,train_images,train_labels);
% accuracy
pred_train = net(train_images);
accu_train = 1 - mean(abs(pred_train-train_labels));
pred_val = net(val_images);
accu_val = 1 - mean(abs(pred_val-val_labels));
fprintf('accu_train: %.02f%%\n',accu_train*100)
fprintf('accu_val: %.02f%%\n',accu_val*100)