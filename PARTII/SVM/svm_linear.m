clear
clc
%% load data
load('train.mat')
load('test.mat')

%% Preprocessing input data
mu = mean(train_data,2);
sigma = std(train_data,1,2); % normalized by the number of observations N
norm_train = (train_data - mu)./sigma;
norm_test = (test_data - mu)./sigma;

%% Mercer condition check
gram_m = norm_train'*norm_train;
eigenvalues = eig(gram_m);
flag = true;
if min(eigenvalues) < -1e-4
    flag = false;
    fprintf('this kernel candidate is not admissible')
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
    C = 10e6; % Hard margin: +inf(in theory)/10e6 (in practice)
    ub=ones(s_dim,1)*C;
    f=-ones(s_dim,1);
    x0 = [];
    % Reform the tarining set 
    %   H = didjK(x1,x2) Linear Kernel K(x1; x2) = x1'x2
    H_sign = train_label*train_label';
    H = norm_train'*norm_train.*H_sign;
    options = optimset('LargeScale','off','MaxIter',1000);
    % Quadratic Programming
    Alpha = quadprog(H,f,A,b,Aeq,Beq,lb,ub,x0,options);
    idx = find(Alpha>1e-4);
    % Calculate disciminant parameters
    wo = sum(Alpha'.*train_label'.*norm_train,2);
    bo=mean(1./train_label(idx) - norm_train(:,idx)'*wo);
    % Accuracy on train set and test set
    %   train
    acc_train = Acc(wo,bo,norm_train,train_label);
    fprintf('acc_train:%.2f%% when C=%d\n',acc_train*100,C)
    %   test
    acc_test = Acc(wo,bo,norm_test,test_label);
    fprintf('acc_test:%.2f%% when C=%d\n',acc_test*100,C)

end

%% functions
function accuracy = Acc(w,b,data,label)
    pred_label = sign(w'*data+b)';
    accuracy = mean(pred_label == label,'all');
end




