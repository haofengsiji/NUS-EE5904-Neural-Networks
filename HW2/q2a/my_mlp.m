function [net,accu_train] = my_mlp(n,x,y,train_num,epochs)
% Construct a 1-n-1 MLP and conduct sequential training.
%
% Args:
%   n: int, number of neurons in the hidden layer of MLP.
%   x: vector of (1, train_num), inputs.
%   y: vector of (1, train_num), desired outputs of inputs.
%   train_num: int, number of trianing data.
%   epochs: int, number of training epochs.
%
% Returns:
%
%   net: object, containg trained network.
%   accu_train: vector of (epochs, 1), containg the accuracy on training
%               set of each epoch during training.

    % 1. Change the input to cell array form for sequential training
    x_c = num2cell(x, 1);
    y_c = num2cell(y, 1);

    % 2. Construct and configure the MLP
    net = fitnet(n,'trainscg');% I use Scaled conjugate gradient backpropagation.

    net.divideFcn = 'dividetrain'; % input for training only
    net.divideParam.trainRatio = 1; % all train
    net.divideParam.testRatio = 0; % no test
    net.divideParam.valRatio = 0; % no val
    net.trainParam.epochs = epochs;

    accu_train = zeros(epochs,1); % record accuracy on training set of each epoch

    % 3. Train the network in sequential mode
    for i = 1 : epochs
        display(['Epoch: ', num2str(i)])
        idx = randperm(train_num); % shuffle the input
        net = adapt(net, x_c(:,idx), y_c(:,idx));
        pred_train = round(net(x(:,1:train_num))); % predictions on training set
        accu_train(i) = 1 - mean(abs(pred_train-y(1:train_num)));
    end
end


