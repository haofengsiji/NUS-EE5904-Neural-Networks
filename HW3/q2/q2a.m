clc
clear
% load MINST
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
for lam = [0,0.1,1,10,100]
    % Training
    lambda = lam; % regularization factor;
    cen = Train_Data;
    input = Train_Data;
    r = sum(input.^2,1)' + sum(cen.^2,1) - 2*input'*cen;
    RBF = exp(-r/2/100^2);
    w =inv(RBF'*RBF+lambda*eye(size(RBF,2)))*RBF'*TrLabel';
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
    fig = figure();
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
    plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te');
    title(sprintf('\\lambda=%.1f',lam))
    saveas(fig,sprintf('q2a/lambda_%.1f.png',lam))
end
