clc 
clear

AND = [0 0 1 0;0 1 1 0;1 0 1 0;1 1 1 1];
OR = [0 0 1 0;0 1 1 1;1 0 1 1;1 1 1 1];
NAND = [0 0 1 1;0 1 1 1;1 0 1 1;1 1 1 0];
COMPLEMENT = [0 1 1;1 1 0];

x = linspace(0,2);
y = -1.0/1.0*x - (-1.5)/1.0;
figure1 = figure;
hold on
plot(x,y)
scatter(AND(:,1),AND(:,2),[],AND(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('AND')
hold off
saveas(figure1,'AND.png')

x = linspace(0,2);
y = -1.0/1.0*x - (-0.5)/1.0;
figure1 = figure;
hold on
plot(x,y)
scatter(OR(:,1),OR(:,2),[],OR(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('OR')
hold off
saveas(figure1,'OR.png')

x = linspace(0,2);
y = -(-1.0)/(-1.0)*x - 1.5/(-1.0);
figure1 = figure;
hold on
plot(x,y)
scatter(NAND(:,1),NAND(:,2),[],NAND(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('NAND')
hold off
saveas(figure1,'NAND.png')

x = - 0.5/(-1.0);
figure7 = figure;
hold on
plot([x x],[0 2])
scatter(COMPLEMENT(:,1),zeros([length(COMPLEMENT(:,1)) 1]),[],COMPLEMENT(:,3),'filled')
xlim([0 2])
ylim([0 2])
title('COMPLEMENT')
hold off
saveas(figure7,'COMPLEMENT.png')
