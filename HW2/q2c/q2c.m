% The code template is copied from the slides
%Matlab code
clc
clear all;
% sampling points in the domain of [-1,1]
train_x = -1:0.05:1;
% generating training data, and the desired outputs
train_y = 1.2*sin(pi*train_x) - cos(2.4*pi*train_x);
for i = [1:10,20,50]
    % specify the structure and learning algorithm for MLP
    net = feedforwardnet(i,'trainbr');
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';
    net = configure(net,train_x,train_y);
    net.trainparam.lr=0.01;
    net.trainparam.epochs=10000;
    net.trainparam.goal=1e-9;
    net.divideParam.trainRatio=1.0;
    net.divideParam.valRatio=0.0;
    net.divideParam.testRatio=0.0;
    % Train the MLP
    [net,tr]=train(net,train_x,train_y);
    % Test the MLP, net_output is the output of the MLP, ytest is the desired output.
    test_x = -3:0.01:3;
    test_y = 1.2*sin(pi*test_x) - cos(2.4*pi*test_x);

    net_output=sim(net,test_x);
    % Plot out the test results
    fig = figure();
    hold on
    plot(test_x,test_y,'-','LineWidth',2)
    scatter(train_x,train_y)
    plot(test_x,net_output,'-','LineWidth',2)
    ylim([-2.5 2.5])
    legend('Groundtruth','Train Points','Regression Line')
    title(sprintf('Mode:Batch Epochs:%d HiddenLayer:%d',tr.num_epochs,i))
    ylabel('Y')
    xlabel('X')
    hold off
    % save image
    saveas(fig,sprintf('images/HiddenLayer%02d.png',i));
end