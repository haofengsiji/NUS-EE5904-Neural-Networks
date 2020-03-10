clc
clear

x = [0 1;0.8 1;1.6 1;3 1;4.0 1;5.0 1];
d = [0.5; 1; 4; 5; 6; 9];

w = (x'*x)^(-1)*x'*d;
y = x*w;

figure
hold on 
scatter(x(:,1),d,'filled')
p = plot(x(:,1),y);
p.LineWidth  = 2;