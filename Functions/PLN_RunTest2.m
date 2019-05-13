%% Train with original dataset
Fobjective = @(x)(sum(LossFunc(x, Dataset.Training.MappedX, Dataset.Training.Y)) + PLN.lam * norm(x))/size(Dataset.Training.MappedX,2);
Fit.f_optimal_test2 = f0;
PLN_optimizerF_unconstrained
% to further improve the results
PLN_optimizerF_unconstrained
PLN_optimizerF_unconstrained
Fit.GeneralizationError_originalDataset(trialCount) = 10*log10(sum(LossFunc(Fit.f_optimal_test2, Dataset.Test.MappedX, Dataset.Test.Y))/sum((Dataset.Test.Y).^2));

optimalLS_original = reshape(Fit.f_optimal_test2, size(Dataset.Training.Y,1), size(Dataset.Training.MappedX,1));
Dataset.Test.EvalY_f_true_optimal_test2 = optimalLS_original * Dataset.Test.MappedX;

%% Train with compressed dataset
Fobjective = @(x)(sum(LossFunc(x, Dataset.Training.SelectedX, Dataset.Training.SelectedY)) + PLN.lam * norm(x))/size(Dataset.Training.SelectedX,2);
PLN_optimizerF_unconstrained
Fit.GeneralizationError_compressedDataset(trialCount) = 10*log10(sum(LossFunc(Fit.f_optimal_test2, Dataset.Test.MappedX, Dataset.Test.Y))/sum((Dataset.Test.Y).^2));

optimalLS_compressed = reshape(Fit.f_optimal_test2, size(Dataset.Training.SelectedY,1), size(Dataset.Training.SelectedX,1));
Dataset.Test.EvalY_f_optimal_test2 = optimalLS_compressed * Dataset.Test.MappedX;

%% Plots
if mod(trialCount, PLN.trialNum/10) == 1   
    figure(2)
    plot(XaxisTest, abs(Dataset.Test.Y - Dataset.Test.EvalY_f_true_optimal_test2),'--x','color','r')
    hold on
    plot(XaxisTest, abs(Dataset.Test.Y - Dataset.Test.EvalY_f_optimal_test2),'--x','color','b')
    str.Test2.TestOriginalDataset = sprintf('Training with original dataset (K=%g), NMSE = %0.4f', Fit.min_cardinality_Z, Fit.GeneralizationError_originalDataset(trialCount));
    str.Test2.TestCompressedDataset = sprintf('Training with compressed dataset, NMSE = %0.4f', Fit.GeneralizationError_compressedDataset(trialCount));
    legend(str.Test2.TestOriginalDataset, str.Test2.TestCompressedDataset,'Location','northeast')
    xlabel('X index');
    ylabel('Generalization error');
    title('Test 2')
    hold off
end
