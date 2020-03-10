clc
clear
% 128x128
% read training data
train_images_128 = [];
train_images_64 = [];
train_images_32 = [];
train_images_pca = [];
train_labels = [];
D = '../group_2/train/';
S = dir(fullfile(D,'*.jpg')); 
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    I = imread(F);
    I_128 = imresize(I,0.5);
    I_64 = imresize(I,0.25);
    I_32 = imresize(I,0.125);
    V = double(I(:));
    V_128 = double(I_128(:));
    V_64 = double(I_64(:));
    V_32 = double(I_32(:));
    train_images_pca = [train_images_pca,V];
    train_images_128 = [train_images_128,V_128];
    train_images_64 = [train_images_64,V_64];
    train_images_32 = [train_images_32,V_32];
    train_labels = [train_labels,str2double(S(k).name(6))];
end
% read validation data
val_images_128 = [];
val_images_64 = [];
val_images_32  = [];
val_images_pca = [];
val_labels = [];
D = '../group_2/val/';
S = dir(fullfile(D,'*.jpg')); 
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    I = imread(F);
    I_128 = imresize(I,0.5);
    I_64 = imresize(I,0.25);
    I_32 = imresize(I,0.125);
    V = double(I(:));
    V_128 = double(I_128(:));
    V_64 = double(I_64(:));
    V_32 = double(I_32(:));
    val_images_pca = [val_images_pca,V];
    val_images_128 = [val_images_128,V_128];
    val_images_64 = [val_images_64,V_64];
    val_images_32 = [val_images_32,V_32];
    val_labels= [val_labels,str2double(S(k).name(6))];
end

% PCA
[coeff,~,latent] = pca(train_images_pca');
sum_latent = sum(latent);
temp = 0;
for i = 1:499
    temp = temp + latent(i);
    if temp/sum_latent >= 0.95
        break
    end
end
train_images_pca = coeff(:,1:i)'*train_images_pca;
val_images_pca = coeff(:,1:i)'*val_images_pca;

% export training and validation data to SceneData.mat
save('SceneData','train_images_128','val_images_128',...
'train_images_64','val_images_64',...
'train_images_32','val_images_32',...
'train_images_pca','val_images_pca',...
'train_labels','val_labels')