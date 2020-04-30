clc
clear

%% load data
load('train.mat');
load('test.mat');
load('eval.mat');

%% Preprocessing input data
mu=mean(train_data,2);
std=std(train_data,0,2);
norm_train=(train_data-mu)./std;
norm_test=(test_data-mu)./std;
norm_eval=(eval_data-mu)./std;
s_dim=size(norm_train,2);
gamma = 0.00125;%Gaussian kernel
C=450;

%% Mercer condition check
gram_m=zeros(s_dim,s_dim);
for i=1:s_dim
    for j=1:s_dim
        gram_m(i,j)=exp(-gamma*sum((norm_train(:,i)-norm_train(:,j)).^2));
    end
end
eigenvalues=eig(gram_m);
flag = true;
if min(eigenvalues)<-1e-4
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
    ub=ones(s_dim,1)*C;
    f=-ones(s_dim,1);
    x0 = [];
    % Reform the tarining set 
    %   H = didjK(x1,x2) Poly Kernel K(x1; x2) = exp(-gamma*|x1-x2|^2)
    H=zeros(s_dim,s_dim);
    for i=1:s_dim
        for j=1:s_dim
            kernel=exp(-gamma*sum((norm_train(:,i)-norm_train(:,j)).^2));
            D=train_label(i)*train_label(j);
            H(i,j)=D.*kernel;
        end
    end
    options=optimset('LargeScale','off','MaxIter',1000);
    % Quadratic Programming
    Alpha = quadprog(H,f,A,b,Aeq,Beq,lb,ub,x0,options);
    idx = find(Alpha>1e-8);
    % Calculate disciminant parameters
    num_SVM=length(idx);    
    g=train_label(idx);
    bN=zeros(num_SVM,1);
    for i=1:num_SVM
        a_d_k=Alpha.*train_label.*exp(-gamma*sum((norm_train-norm_train(:,idx(i))).^2,1)');
        bN(i)=g(i)-sum(a_d_k);
    end
    bo=mean(bN);
    % Accuracy on train set and test set
    %   train
    [~,acc_train] = Acc(Alpha,bo,norm_train,train_label,norm_train,train_label,gamma);
    fprintf('acc_train:%.2f%% when gimma=%f C=%.1f\n ',acc_train*100,gamma,C)
    %   test
    [~,acc_test] = Acc(Alpha,bo,norm_train,train_label,norm_test,test_label,gamma);
    fprintf('acc_test:%.2f%% when gimma=%f C=%.1f\n ',acc_test*100,gamma,C)
    %   eval
    [eval_predicted,acc_eval] = Acc(Alpha,bo,norm_train,train_label,norm_eval,eval_label,gamma);
    fprintf('acc_eval:%.2f%% when gimma=%f C=%.1f\n ',acc_eval*100,gamma,C)

end

%% functions
function [pred_label,accuracy] = Acc(alpha,bo,train_data,train_label,data,label,gamma)
    g=zeros(length(label),1);
    for i=1:length(label)
        a_d_K=alpha.*train_label.*exp(-gamma*sum((train_data-data(:,i)).^2,1)');
        g(i)=sum(a_d_K)+bo;
    end
    pred_label=sign(g);
    accuracy = mean(pred_label == label,'all');
end

