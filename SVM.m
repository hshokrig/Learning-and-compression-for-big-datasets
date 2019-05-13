%% Initializations
clc, clear
rng default
addpath(genpath('Datasets'));
addpath(genpath('Functions'));

%load fisheriris
load ionosphere

trainRatio = 0.7; valRatio = 0; testRatio = 1 - trainRatio - valRatio;

[trainInd,valInd,testInd] = dividerand(length(Y),0.7,0,0.3);  % create index for Training and Test datasets

Dataset.Training.size = length(trainInd);
Dataset.Training.X = X(trainInd,:);
Dataset.Training.Y = Y(trainInd,:);

Dataset.Test.size = length(testInd);
Dataset.Test.X = X(testInd,:);
Dataset.Test.Y = Y(testInd,:);

%% Training
SVMModel = fitcsvm(Dataset.Training.X,Dataset.Training.Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');


% check performance
LossFunction = 'classiferror'; % 'classiferror' | 'logit' | 'binodeviance' | 'exponential' | 'hinge' | 'mincost' | 'quadratic
Fit.TrainingMisclassificationRate = SVM_performance(SVMModel, Dataset.Training.X, Dataset.Training.Y, 0, LossFunction);
Fit.TestMisclassificationRate = SVM_performance(SVMModel, Dataset.Test.X, Dataset.Test.Y, 0, LossFunction);

%% Iterative algorithm
% initializations
Dataset.Training.select = true(1,Dataset.Training.size);
Dataset.Training.SelectedX = Dataset.Training.X(Dataset.Training.select,:);
Dataset.Training.SelectedY = Dataset.Training.Y(Dataset.Training.select);


%%% Optimization using Baysian optimization
Fit.function = SVMModel;
Fit.f_optimal = [1e-6, 1e-6];
% optimization variables
sigma = optimizableVariable('sigma',[1e-4,1e4],'Transform','log');
box = optimizableVariable('box',[1e-5,1e5],'Transform','log');

Error_threshold = 1e-1;
Fit.min_cardinality_Z = 15;
LossFunction = 'classiferror'; % 'classiferror' | 'logit' | 'binodeviance' | 'exponential' | 'hinge' | 'mincost' | 'quadratic
sigma = optimizableVariable('sigma',[1e-5,1e5],'Transform','log');
box = optimizableVariable('box',[1e-5,1e5],'Transform','log');

cont = 1;
StallF = 0; StallZ = 0; MaxStallF = 20; MaxStallZ = 20; StallF_Threshold = 1e-2;
MaxNumIter = 1e8;
k = 1;
Told = [];

% main iteration
while cont
    %     keyboard
    
    % iteration on p for a fix z
    SVM_optimizer
    
    SVMModel_optimized = fitcsvm(Dataset.Training.SelectedX, Dataset.Training.SelectedY,'KernelFunction','rbf','KernelScale',f_optimal(1),'BoxConstraint',f_optimal(2));
    Fit.function = SVMModel_optimized;
   
    objective = SVM_performance(Fit.function, Dataset.Training.SelectedX, Dataset.Training.SelectedY, 0, LossFunction);
    constraint = SVM_performance(Fit.function, Dataset.Training.X, Dataset.Training.Y, 0, LossFunction) - Error_threshold;
        
    if norm(f_optimal - Fit.f_optimal) < StallF_Threshold
        StallF = StallF +1;
    else
        StallF = 0;
    end
    Fit.f_optimal = f_optimal;
       
    % iteration on z for a fix f
    Training_error = zeros(1,Dataset.Training.size);
    for i=1:Dataset.Training.size 
            Training_error(i) =  SVM_performance(Fit.function, Dataset.Training.X(i,:), Dataset.Training.Y(i,:), 0, LossFunction);
    end
        
    [~,sorted_index] = sort(abs(Training_error));
    Fit.z_optimal = zeros(1,Dataset.Training.size);
    Fit.z_optimal(sorted_index(1:Fit.min_cardinality_Z)) = 1;
    Fit.z_optimal([1,end])=1;
    if Fit.z_optimal == Dataset.Training.select
        StallZ = StallZ +1;
    else
        StallZ = 0;
    end
    %     [f0; f_star]
    %     [[fval;Fobjective(f0)], [Fconstraint(f_star); Fconstraint(f0)]]
    %     [Dataset.Training.select; z_star]
    
    % Dataset selection
    Dataset.Training.select = logical(Fit.z_optimal);
    Dataset.Training.SelectedX = Dataset.Training.X(Dataset.Training.select,:);
    Dataset.Training.SelectedY = Dataset.Training.Y(Dataset.Training.select,:);
    
    % prepare for the next iteration
    
    %     [k, StallF, StallZ]
    if (k > MaxNumIter) | (StallF > MaxStallF ) | (StallZ > MaxStallZ )
        % it can be modified to account for stallment in f_star or in z_star for like N times
        cont = 0;
    end
    
    Tnew = table(k, objective, constraint, size(Dataset.Training.SelectedX,1), size(Dataset.Training.X,1), StallF, StallZ);
    Tnew.Properties.VariableNames = {'Iteration', 'Objective','Constraint', 'Size_CompressedDataset','Size_OriginalDatasetSize', 'Stall_F', 'Stall_Z'};
    T = [Told; Tnew]
    Told = T;

    k = k+1;
    
end
