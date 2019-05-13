%% Calculations
optimalLS = reshape(Fit.f_optimal, size(Dataset.Training.Y,1), size(Dataset.Training.MappedX,1));
trueOptimalLS = reshape(Fit.f_true_optimal, size(Dataset.Training.Y,1), size(Dataset.Training.MappedX,1));

Dataset.Test.EvalY_f_optimal_test1 = optimalLS * Dataset.Test.MappedX;
Dataset.Test.EvalY_f_true_optimal_test1 = trueOptimalLS * Dataset.Test.MappedX;

Dataset.Training.EvalY_f_optimal_test1 = optimalLS * Dataset.Training.MappedX;
Dataset.Training.EvalY_f_true_optimal_test1 = trueOptimalLS * Dataset.Training.MappedX;


Fit.GeneralizationError_true_optimal_test1(trialCount) = sum(LossFunc(Fit.f_true_optimal, Dataset.Test.MappedX, Dataset.Test.Y))/Dataset.Test.size;
Fit.GeneralizationError_optimal_test1(trialCount) = sum(LossFunc(Fit.f_optimal, Dataset.Test.MappedX, Dataset.Test.Y))/Dataset.Test.size;
Fit.TrainingError_true_optimal_test1(trialCount) = sum(LossFunc(Fit.f_true_optimal, Dataset.Training.MappedX, Dataset.Training.Y))/Dataset.Training.size;
Fit.TrainingError_optimal_test1(trialCount) = sum(LossFunc(Fit.f_optimal, Dataset.Training.MappedX, Dataset.Training.Y))/Dataset.Training.size;

%% Plots
if mod(trialCount, PLN.trialNum/10) == 1

    figure(1)
    subplot(2,2,[1,2])
    plot(XaxisTraining, Dataset.Training.Y,'-o','color','k')
    hold on
    plot(XaxisTraining(Dataset.Training.select), Dataset.Training.SelectedY,'bs','MarkerFaceColor','b')
    plot(XaxisTraining, Dataset.Training.EvalY_f_true_optimal_test1,'-x', 'color','r')
    plot(XaxisTraining, Dataset.Training.EvalY_f_optimal_test1,'-x', 'color','b')
    str.Test1.Xindex = sprintf('Original dataset');
    str.Test1.SelectedXindex = sprintf('Compressed dataset (z*), K = %g', Fit.min_cardinality_Z);
    str.Test1.FXindex = sprintf('Fuction fitted with original dataset');
    str.Test1.FSelectedXindex = sprintf('Solution of our optimization problem (f*)');
    legend(str.Test1.Xindex, str.Test1.SelectedXindex, str.Test1.FXindex, str.Test1.FSelectedXindex,'Location','northeastoutside')
    xlabel('X index');
    ylabel('Y');
    title('Test 1')
    hold off
    
    
    subplot(2,2,3)
    plot(XaxisTraining, abs(Dataset.Training.Y - Dataset.Training.EvalY_f_true_optimal_test1),'-o','color','r')
    hold on
    plot(XaxisTraining, abs(Dataset.Training.Y - Dataset.Training.EvalY_f_optimal_test1),'-o','color','b')
    str.Test1.TrainingOriginalDataset = sprintf('Original dataset, NMSE = %0.4f', Fit.TrainingError_true_optimal_test1(trialCount));
    str.Test1.TrainingCompressedDataset = sprintf('Original dataset, NMSE = %0.4f', Fit.TrainingError_optimal_test1(trialCount));
    legend(str.Test1.TrainingOriginalDataset, str.Test1.TrainingCompressedDataset ,'Location','northeast')
    xlabel('X index');
    ylabel('Training error');
    hold off
    
    
    subplot(2,2,4)
    plot(XaxisTest, abs(Dataset.Test.Y - Dataset.Test.EvalY_f_true_optimal_test1),'--x','color','r')
    hold on
    plot(XaxisTest, abs(Dataset.Test.Y - Dataset.Test.EvalY_f_optimal_test1),'--x','color','b')
    str.Test1.TestOriginalDataset = sprintf('Original dataset, NMSE = %0.4f', Fit.GeneralizationError_true_optimal_test1(trialCount));
    str.Test1.TestCompressedDataset = sprintf('Original dataset, NMSE = %0.4f', Fit.GeneralizationError_optimal_test1(trialCount));
    legend(str.Test1.TestOriginalDataset, str.Test1.TestCompressedDataset,'Location','northeast')
    xlabel('X index');
    ylabel('Generalization error');
    hold off
    
end
