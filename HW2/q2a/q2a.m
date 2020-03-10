clc
clear
% hyperparams
epochs = 200;
% data
train_x = -1:0.05:1;
train_y = 1.2*sin(pi*train_x) - cos(2.4*pi*train_x);

for i = [1:10,20,50]
    % trainig
    [net,~] = my_mlp(i,train_x,train_y,41,epochs);
    % test
    test_x = -3:0.01:3;
    test_y = 1.2*sin(pi*test_x) - cos(2.4*pi*test_x);
    y = net(test_x);
    % plot
    fig = figure();
    hold on
    plot(test_x,test_y,'-','LineWidth',2)
    scatter(train_x,train_y)
    plot(test_x,y,'-','LineWidth',2)
    ylim([-2.5 2.5])
    legend('Groundtruth','Train Points','Regression Line')
    title(sprintf('Mode:seq Epochs:%d HiddenLayer:%d',epochs,i))
    ylabel('Y')
    xlabel('X')
    hold off
    % save image
    saveas(fig,sprintf('images/HiddenLayer%02d.png',i));
end
