function misclassificationRate = SVM_performance(SVMModel, testInput, testOutput, p, LossFunction)
% p=1 : plot the confusion matrix
% classificarion=0 : outputs regression (scores before \max operator)
% classificarion=1 : outputs classification performance

if p == 1
    [~,score] = predict(SVMModel,testInput);
    testOutputCoded = zeros(size(testInput,1) ,2);
    noClass = numel(SVMModel.ClassNames);
    for i = 1:noClass
        testOutputCoded(char(testOutput) == SVMModel.ClassNames{i},i) = 1;  % for each row, column i = 1 meaning that that row belongs to class i
    end
    
    plotconfusion(testOutputCoded',score')
end

%     [~,maxScore] = max(score,[],2);
%     [~,trueClass] = max(testOutputCoded,[],2);
%     misclassificationRate =  sum(maxScore ~= trueClass)/size(testInput,1);

misclassificationRate = loss(SVMModel,testInput,testOutput,'LossFun',LossFunction);


