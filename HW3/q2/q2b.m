clc
clear
% load MINST
load('../MNIST_database')
%   A0206597U->9=0 7=1
%   Train data
c1 = 9;
c2 = 7;
trainIdx = find(train_classlabel==c1 | train_classlabel==c2); % find the location of classes 
TrLabel = train_classlabel(trainIdx);
TrLabel(TrLabel==c1) = 1;
TrLabel(TrLabel==c2) = 0;
Train_Data = train_data(:,trainIdx);
%   Test data
testIdx = find( test_classlabel==c1 | test_classlabel==c2); % find the location of classes 
TeLabel = test_classlabel(testIdx);
TeLabel(TeLabel==c1) = 1;
TeLabel(TeLabel==c2) = 0;
Test_Data = test_data(:,testIdx);
for sigma = [-1,0.1,1,10,100,1000,10000]
    % Training
    rng(520)
    rand_cen = datasample(Train_Data,100,2);
    input = Train_Data;
    r = dis(input,rand_cen);
    if sigma == -1
        sigma = sqrt(max(r,[],'all'))/sqrt(2*size(rand_cen,2));
    end
    RBF = exp(-r./(2*sigma^2));
    w = pinv(RBF)*TrLabel';
    % Predict
    %   TrPred
    input = Train_Data;
    r = dis(input,rand_cen);
    RBF = exp(-r./(2*sigma^2));
    TrPred = (RBF*w)';
    %   TePred
    input = Test_Data;
    r = dis(input,rand_cen);
    RBF = exp(-r./(2*sigma^2));
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
    title(sprintf('Width=%.2f',sigma))
    saveas(fig,sprintf('q2b/width_%.2f.png',sigma))
end
function a = dis(input,rand_cen)
% Square(norm2)
% a = sum(input.^2,1)' + sum(rand_cen.^2,1) - 2*input'*rand_cen;
  a = zeros(size(input,2),size(rand_cen,2));
  for i = 1:size(input,2)
      for j = 1:size(rand_cen,2)
          a(i,j) = norm(input(:,i)-rand_cen(:,j),2)^2;
      end
  end
  b = sum(input.^2,1)' + sum(rand_cen.^2,1) - 2*input'*rand_cen;
end