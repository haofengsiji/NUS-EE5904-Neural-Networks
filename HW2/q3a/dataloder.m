clc
clear

% read training data
train_images = [];
train_labels = [];
D = '../group_2/train/';
S = dir(fullfile(D,'*.jpg')); 
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    I = imread(F);
    V = double(I(:));
    train_images = [train_images,V];
    train_labels = [train_labels,str2num(S(k).name(6))];
end
% read validation data
val_images = [];
val_labels = [];
D = '../group_2/val/';
S = dir(fullfile(D,'*.jpg')); 
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    I = imread(F);
    V = double(I(:));
    val_images = [val_images,V];
    val_labels = [val_labels,str2num(S(k).name(6))];
end
% export training and validation data to SceneData.mat
save('SceneData','train_images','train_labels','val_images','val_labels')