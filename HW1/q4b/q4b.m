clc
clear

x = [0 1;0.8 1;1.6 1;3 1;4.0 1;5.0 1];
d = [0.5; 1; 4; 5; 6; 9];

w = randn(1,2);
w_h = w;
eta = 0.01; % learning rate
classified = false;


for epoch = 1:100
    %classified = true;
    for i = 1:length(x(:,1))
         if x(i,1:2)*w' == d(i)
         else
             %classified = false;
             e = d(i) - x(i,1:2)*w';
             w = w + eta*e*x(i,1:2);
             w_h= [w_h;w];
         end
    end
end

y = x*w';

figure
hold on 
scatter(x(:,1),d,'filled')
p = plot(x(:,1),y);
p.LineWidth  = 2;
hold off

figure
hold on 
plot(0:length(w_h)-1,w_h(:,1),'-x')
plot(0:length(w_h)-1,w_h(:,2),'-o')
legend({'w1','b'})
hold off