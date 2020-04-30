% y1 = 1 / k;
% y2 = 100 / (100 + k);
% y3 = (1 + log(k)) / k;
% y4 = (1 + 5 * log(k)) / k;
% y5 = exp(-0.001*k);

hold on
fplot(@(k) 1 / k,[1 1000])
fplot(@(k) 100 / (100 + k),[1 1000])
fplot(@(k) (1 + log(k)) / k,[1 1000])
fplot(@(k) (1 + 5 * log(k)) / k,[1 1000])
fplot(@(k) exp(-0.001*k),[1 1000])
hold off
legend('1/k','100 / (100 + k)','(1 + log(k)) / k','(1 + 5 * log(k)) / k','exp(-0.001*k)')

