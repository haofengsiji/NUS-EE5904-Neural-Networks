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
% training
[ net, accu_train, accu_val ] = train_seq( 298, train_images, train_labels, 500, 10);
