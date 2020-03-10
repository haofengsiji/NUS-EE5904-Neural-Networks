clc
clear all;
% load data
%   train_images (64*64,samples)
%   train_labels (1,samples)
%   val_images (64*64,samples)
%   val_labels (1,samples)
load('SceneData')
train_images = [train_images,val_images];
train_labels = [train_labels,val_labels];

% specify the structure and learning algorithm for MLP
net = patternnet(298,'traingdx');
net = configure(net,train_images,train_labels);
net.trainparam.lr=0.05;
net.trainparam.epochs=1000;
net.trainparam.goal=1e-5;
net.trainparam.min_grad=1e-5;
net.performParam.regularization =0.5; % Regularization strength 0,0.25,0.5,0.9
net.trainParam.max_fail = 1000;
net.divideFcn = 'divideind';
net.divideParam.trainInd =1:500;
net.divideParam.valInd = 501:666;
% Train the MLP
[net,tr]=train(net,train_images,train_labels);
% accuracy
pred_train = net(train_images);
accu_train = 1 - mean(abs(pred_train-train_labels));
pred_val = net(val_images);
accu_val = 1 - mean(abs(pred_val-val_labels));
fprintf('accu_train: %.02f%%\n',accu_train*100)
fprintf('accu_val: %.02f%%\n',accu_val*100)