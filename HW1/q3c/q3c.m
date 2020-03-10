clc
clear

EXCLUSIVE_OR = [0 0 1 0;0 1 1 1;1 0 1 1;1 1 1 0];

eta = 0.1;
w = randn(1,3);
w_h = w;

% EXCLUSIVE_OR
classified = false;

while not (classified)
    classified = true;
    for i = 1:length(EXCLUSIVE_OR(:,1))
        if EXCLUSIVE_OR(i,1:3)*w' >= 0 y = 1;else y = 0; end
        if EXCLUSIVE_OR(i,4) ~= y
            classified = false;
            w = w + eta*(EXCLUSIVE_OR(i,4)-y)*EXCLUSIVE_OR(i,1:3);
            w_h = [w_h;w];
        end
    end 
end

x = linspace(0,2);
y = -w(1)/w(2)*x - w(3)/w(2);
figure1 = figure;
hold on
plot(x,y)
scatter(EXCLUSIVE_OR(:,1),EXCLUSIVE_OR(:,2),[],EXCLUSIVE_OR(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('EXCLUSIVE_OR')
hold off
saveas(figure1,sprintf('EXCLUSIVE_OR_%.3f.png',eta))

figure2 = figure;
hold on 
plot(0:length(w_h)-1,w_h(:,1),'-o')
plot(0:length(w_h)-1,w_h(:,2),'-o')
plot(0:length(w_h)-1,w_h(:,3),'-o')
legend({'w1','w2','b'},'location','northwest')
title('EXCLUSIVE_OR')
hold off
saveas(figure2,sprintf('EXCLUSIVE_OR_w_%.3f.png',eta))

