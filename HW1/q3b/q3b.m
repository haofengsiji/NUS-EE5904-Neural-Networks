clc
clear

AND = [0 0 1 0;0 1 1 0;1 0 1 0;1 1 1 1];
OR = [0 0 1 0;0 1 1 1;1 0 1 1;1 1 1 1];
NAND = [0 0 1 1;0 1 1 1;1 0 1 1;1 1 1 0];
COMPLEMENT = [0 1 1;1 1 0];

eta = 0.1;
w = randn(1,3);
w_h = w;

% AND
classified = false;

while not (classified)
    classified = true;
    for i = 1:length(AND(:,1))
        if AND(i,1:3)*w' >= 0 y = 1;else y = 0; end
        if AND(i,4) ~= y
            classified = false;
            w = w + eta*(AND(i,4)-y)*AND(i,1:3);
            w_h = [w_h;w];
        end
    end 
end

x = linspace(0,2);
y = -w(1)/w(2)*x - w(3)/w(2);
figure1 = figure;
hold on
plot(x,y)
scatter(AND(:,1),AND(:,2),[],AND(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('AND')
hold off
saveas(figure1,sprintf('AND_%.3f.png',eta))

figure2 = figure;
hold on 
plot(0:length(w_h)-1,w_h(:,1),'-o')
plot(0:length(w_h)-1,w_h(:,2),'-o')
plot(0:length(w_h)-1,w_h(:,3),'-o')
legend({'w1','w2','b'},'location','northwest')
title('AND')
hold off
saveas(figure2,sprintf('AND_w_%.3f.png',eta))

% OR
classified = false;

while not (classified)
    classified = true;
    for i = 1:length(OR(:,1))
        if OR(i,1:3)*w' >= 0 y = 1;else y = 0; end
        if OR(i,4) ~= y
            classified = false;
            w = w + eta*(OR(i,4)-y)*OR(i,1:3);
            w_h = [w_h;w];
        end
    end 
end

x = linspace(0,2);
y = -w(1)/w(2)*x - w(3)/w(2);
figure3 = figure;
hold on
plot(x,y)
scatter(OR(:,1),OR(:,2),[],OR(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('OR')
hold off
saveas(figure3,sprintf('OR_%.3f.png',eta))

figure4 = figure;
hold on 
plot(0:length(w_h)-1,w_h(:,1),'-o')
plot(0:length(w_h)-1,w_h(:,2),'-o')
plot(0:length(w_h)-1,w_h(:,3),'-o')
legend({'w1','w2','b'},'location','northwest')
title('OR')
hold off
saveas(figure4,sprintf('OR_w_%.3f.png',eta))

% NAND
classified = false;

while not (classified)
    classified = true;
    for i = 1:length(NAND(:,1))
        if NAND(i,1:3)*w' >= 0 y = 1;else y = 0; end
        if NAND(i,4) ~= y
            classified = false;
            w = w + eta*(NAND(i,4)-y)*NAND(i,1:3);
            w_h = [w_h;w];
        end
    end 
end

x = linspace(0,2);
y = -w(1)/w(2)*x - w(3)/w(2);
figure5 = figure;
hold on
plot(x,y)
scatter(NAND(:,1),NAND(:,2),[],NAND(:,4),'filled')
xlim([0 2])
ylim([0 2])
title('NAND')
hold off
saveas(figure5,sprintf('NAND_%.3f.png',eta))

figure6 = figure;
hold on 
plot(0:length(w_h)-1,w_h(:,1),'-o')
plot(0:length(w_h)-1,w_h(:,2),'-o')
plot(0:length(w_h)-1,w_h(:,3),'-o')
legend({'w1','w2','b'},'location','northwest')
title('NAND')
hold off
saveas(figure6,sprintf('NAND_w_%.3f.png',eta))

% COMPLEMENT
w = randn(1,2);
w_h = w;
classified = false;

while not (classified)
    classified = true;
    for i = 1:length(COMPLEMENT(:,1))
        if COMPLEMENT(i,1:2)*w' >= 0 y = 1;else y = 0; end
        if COMPLEMENT(i,3) ~= y
            classified = false;
            w = w + eta*(COMPLEMENT(i,3)-y)*COMPLEMENT(i,1:2);
            w_h = [w_h;w];
        end
    end 
end


x = - w(2)/w(1);
figure7 = figure;
hold on
plot([x x],[0 2])
scatter(COMPLEMENT(:,1),zeros([length(COMPLEMENT(:,1)) 1]),[],COMPLEMENT(:,3),'filled')
xlim([0 2])
ylim([0 2])
title('COMPLEMENT')
hold off
saveas(figure7,sprintf('COMPLEMENT_%.3f.png',eta))

figure8 = figure;
hold on 
plot(0:length(w_h)-1,w_h(:,1),'-o')
plot(0:length(w_h)-1,w_h(:,2),'-o')
legend({'w1','b'},'location','northwest')
title('COMPLEMENT')
hold off
saveas(figure8,sprintf('COMPLEMENT_w_%.3f.png',eta))