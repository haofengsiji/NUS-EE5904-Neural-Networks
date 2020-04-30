clc
clear
% load MINST Data
load('../MNIST_database')
%   A0206597U->9=0 7=1
%   Train data
trainIdx = find(train_classlabel==9 | train_classlabel==7); % find the location of classes 
TrLabel = train_classlabel(trainIdx);
TrLabel(TrLabel==9) = 1;
TrLabel(TrLabel==7) = 0;
Train_Data = train_data(:,trainIdx);
%   Test data
testIdx = find( test_classlabel==9 | test_classlabel==7); % find the location of classes 
TeLabel = test_classlabel(testIdx);
TeLabel(TeLabel==9) = 1;
TeLabel(TeLabel==7) = 0;
Test_Data = test_data(:,testIdx);
% K-means
%   Initialization. centers
rng(520)
cur_cen = datasample(Train_Data,2,2);
prev_cen = zeros(size(cur_cen));
while sum(cur_cen~=prev_cen,'all') ~= 0
    prev_cen = cur_cen;
    %   Assignment
    dis = sum(prev_cen.^2,1)' + sum(Train_Data.^2,1) - 2*prev_cen'*Train_Data;
    [~,label]=min(dis,[],1);
    %   Updating
    cur_cen(:,1) = mean(Train_Data(:,label==1),2);
    cur_cen(:,2) = mean(Train_Data(:,label==2),2);
end
% Training
cen = cur_cen;
input = Train_Data;
r = sum(input.^2,1)' + sum(cen.^2,1) - 2*input'*cen;
RBF = exp(-r/2/100^2);
w = pinv(RBF)*TrLabel';
% Predict
%   TrPred
input = Train_Data;
r = sum(input.^2,1)' + sum(cen.^2,1) - 2*input'*cen;
RBF = exp(-r/2/100^2);
TrPred = (RBF*w)';
%   TePred
input = Test_Data;
r = sum(input.^2,1)' + sum(cen.^2,1) - 2*input'*cen;
RBF = exp(-r/2/100^2);
TePred = (RBF*w)';
% Plot
TrAcc = zeros(1,1000);
TeAcc = zeros(1,1000);
thr = zeros(1,1000);
TrN = length(TrLabel);
TeN = length(TeLabel);
for i = 1:1000
    t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
    thr(i) = t;
    TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
    TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
end
f1 = figure();
plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te');
saveas(f1,'q2c\performance.png')
f2 = figure();
sgtitle('K-means Centers')
subplot(1,2,1)
imshow(reshape(cur_cen(:,1),[28,28]));
subplot(1,2,2)
imshow(reshape(cur_cen(:,2),[28,28]));
saveas(f2,'q2c\Centers.png')
f3 = figure();
sgtitle('Training set average')
subplot(1,2,1)
imshow(reshape(mean(Train_Data(:,TrLabel==1),2),[28,28]));
subplot(1,2,2)
imshow(reshape(mean(Train_Data(:,TrLabel==0),2),[28,28]));
saveas(f3,'q2c\average.png')



