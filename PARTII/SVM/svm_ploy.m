clear
clc

%% load data
load('train.mat')
load('test.mat')

%% Preprocessing input data
mu = mean(train_data,2);
sigma = std(train_data,0,2); % normalized by the number of observations N
norm_train = (train_data - mu)./sigma;
norm_test = (test_data - mu)./sigma;
P = 3;
C = 10e6; % Hard margin:In theory +inf
%% loop
% for C = [10e6,0.1,0.6,1.1,2.1]
% for P = [1,2,3,4,5]
for C = [0.1,0.6,1.1,2.1]
for P = [1,2,3,4,5]
%% Mercer condition check
gram_m = (norm_train'*norm_train+1).^P;
eigenvalues = eig(gram_m);
flag = true;
if min(eigenvalues) <-1e-4
    flag = false;
    fprintf('P = %d this kernel candidate is not admissible\n',P)
end

%% Training
if flag == true
    % Set the training parameters
    A = [];
    b = [];
    Aeq = train_label';
    Beq = 0;
    [f_dim,s_dim]=size(norm_train);
    lb = zeros(s_dim,1);
    ub=ones(s_dim,1)*C;
    f=-ones(s_dim,1);
    x0 = [];
    % Reform the tarining set 
    %   H = didjK(x1,x2) Poly Kernel K(x1; x2) = x1'x2
    H_sign = train_label*train_label';
    H = (norm_train'*norm_train + 1).^P.*H_sign;
    options = optimset('LargeScale','off','MaxIter',1000);
    % Quadratic Programming
    Alpha = quadprog(H,f,A,b,Aeq,Beq,lb,ub,x0,options);
    idx = find(Alpha>1e-8);
    % Calculate disciminant parameters
    ai_di_K = Alpha.*train_label.*(norm_train'*norm_train+1).^P; % (s_dim x s_dim)
    a_d_K = sum(ai_di_K,1)'; % (1 x s_dim)'
    bo = mean(train_label(idx) - a_d_K(idx));
    % Accuracy on train set and test set
    %   train
    acc_train = Acc(Alpha,bo,norm_train,train_label,norm_train,train_label,P);
    fprintf('acc_train:%.2f%% when P=%d C=%.1f\n ',acc_train*100,P,C)
    %   test
    acc_test = Acc(Alpha,bo,norm_train,train_label,norm_test,test_label,P);
    fprintf('acc_test:%.2f%% when P=%d C=%.1f\n ',acc_test*100,P,C)
    
end
end
end
%% functions
function accuracy = Acc(alpha,bo,train_data,train_label,data,label,P)
    ai_di_K = alpha.*train_label.*(train_data'*data+1).^P; % (num_sppport x s_dim)
    a_d_K = sum(ai_di_K,1)'; %(1 x s_dim)'
    pred_label = sign(a_d_K + bo);
    accuracy = mean(pred_label == label,'all');
end