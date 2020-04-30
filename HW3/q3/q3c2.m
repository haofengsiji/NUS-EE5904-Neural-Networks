clc
clear
% load MINST
load('../MNIST_database')
%   A0206597U-> NO:9,7 ->0,1,2,3,4,5,6,8
% load model
load('neurons')
% Predict
%   Test data
testIdx = find(test_classlabel~=9 & test_classlabel~=7); % find the location of classes 
TeLabel = test_classlabel(testIdx);
Test_Data = test_data(:,testIdx);
% TePred
TePred = zeros(size(TeLabel));
counter_1 = 1;
counter_2 = 1;
for i = 1:size(Test_Data,2)
    dis = squeeze(sum((Test_Data(:,i) - neurons).^2,1));
    [~,winner] = min(dis,[],'all','linear');
    k = ceil(winner/10);
    n = winner - (k-1)*10;
    TePred(1,i) = maplabel(n,k);
    % plot some correct samples
    if TePred(1,i)==TeLabel(1,i) && counter_1 <= 5
        figure(1)
        sgtitle('Correct classification')
        subplot(5,2,(counter_1-1)*2+1)
        imshow(reshape(Test_Data(:,i),28,28))
        title(sprintf('Ground Truth:%d',TeLabel(1,i)))
        subplot(5,2,(counter_1-1)*2+2)
        imshow(reshape(neurons(:,n,k),28,28))
        title(sprintf('Label Predicted:%d',TePred(1,i)))
        counter_1 = counter_1 + 1;
    % plot some incorrect samples
    elseif TePred(1,i)~=TeLabel(1,i) && counter_2 <= 5
        figure(2)
        sgtitle('Incorrect classification')
        subplot(5,2,(counter_2-1)*2+1)
        imshow(reshape(Test_Data(:,i),28,28))
        title(sprintf('Ground Truth:%d',TeLabel(1,i)))
        subplot(5,2,(counter_2-1)*2+2)
        imshow(reshape(neurons(:,n,k),28,28))
        title(sprintf('Label Predicted:%d',TePred(1,i)))
        counter_2 = counter_2 + 1;
    end
end
TeAccr = sum(TePred == TeLabel)/size(Test_Data,2)

        
