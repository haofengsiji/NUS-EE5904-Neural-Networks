clc
clear
% initialization
x = 0;
y = 0.5;
count = 1;
cost = (1-x)^2 + 100*(y-x^2)^2;
coords_h = [x,y;]; % history of x and y
cost_h = [cost]; % history of cost

% update process
while cost >= 1e-5
    count = count + 1;
    % update weights
    g = [(2*(x - 1) + 400*(x^3 - x*y)); 200*(y-x^2)];
    H = [1200*x^2 - 400*y + 2,-400*x; -400*x,200];
    w = [x;y]-H^(-1)*g;
    x = w(1);
    y = w(2);
    % new cost
    cost = (1-x)^2 + 100*(y-x^2)^2;
    % record values
    coords_h = [coords_h;x,y;];
    cost_h = [cost_h;cost];
end

% plot
figure()
hold on
yyaxis left
plot(coords_h(:,1),coords_h(:,2),'-o')
ylabel('Y')
yyaxis right
plot(coords_h(:,1),cost_h,'*--')
ylabel('Function Value')
xlabel('X')
hold off