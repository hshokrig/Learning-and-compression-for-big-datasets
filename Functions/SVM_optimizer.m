fprintf('\n SVM optimizer is running...\n')

fun = @(x)SVM_obj_confun_p2(x, Dataset.Training.X, Dataset.Training.Y, ...
    Dataset.Training.SelectedX, Dataset.Training.SelectedY, ...
    Error_threshold, LossFunction);

InitialPoint = table(Fit.f_optimal(1), Fit.f_optimal(2));
InitialPoint.Properties.VariableNames = {'sigma', 'box'};

results = bayesopt(fun,[sigma,box],'IsObjectiveDeterministic',true,...
    'NumCoupledConstraints',1,'AcquisitionFunctionName','expected-improvement-plus',...
    'PlotFcn',[],'Verbose',1,'InitialX',InitialPoint);
%    'PlotFcn',{@plotMinObjective,@plotConstraintModels,@plotObjectiveModel},...

f_optimal = [results.XAtMinObjective.sigma, results.XAtMinObjective.box];


SVMModel_optimized = fitcsvm(Dataset.Training.SelectedX, Dataset.Training.SelectedY,'KernelFunction','rbf','KernelScale',f_optimal(1),'BoxConstraint',f_optimal(2));
Fit.function = SVMModel_optimized;

objective = SVM_performance(Fit.function, Dataset.Training.SelectedX, Dataset.Training.SelectedY, 0, LossFunction);
constraint = SVM_performance(Fit.function, Dataset.Training.X, Dataset.Training.Y, 0, LossFunction) - Error_threshold;

