%% Initializations
clc, clear
addpath(genpath('Datasets'));
addpath(genpath('Functions'));

%   Loading the dataset
Dataset.Name = 'Pyrim'; % see full list in ELM_database.m
[PLN.lam, PLN.noNodes] = PLN_database(Dataset.Name);
PLN.noNodes = 100;

iterations.MaxStallF = 3; iterations.MaxStallZ = 3; iterations.thresholdStallF = 1e-2;

%% Training
% PLN parameters
PLN.a_leaky_RLU = 0;      %   set to a small non-zero value if you want to test leaky-RLU
PLN.ActivationFunc = @(x) x.*(x >= 0)+PLN.a_leaky_RLU*x.*(x < 0);
LossFunc = @(o, X, Y)  (Y - reshape(o, size(Y,1), size(X,1))*X).^2; % O = reshape(o, size(Y,1), size(X,2)), since "o" is a vector for optimization

% The perfomance measures we are interested in
Fit.compressionRatio = 0.25;

PLN.trialNum = 100;
Fit.MeanGeneralizationError_originalDataset = zeros(1, PLN.trialNum);
Fit.MeanGeneralizationError_compressedDataset = zeros(1, PLN.trialNum);

for trialCount = 1:PLN.trialNum
    disp(trialCount)
    
    [Dataset.Training.X, Dataset.Training.Y, Dataset.Test.X, Dataset.Test.Y] = Load_dataset(Dataset.Name);
    Dataset.noFeatures = size(Dataset.Training.X,1);
    Dataset.Training.size = size(Dataset.Training.X,2);
    Dataset.dimensionY = size(Dataset.Training.Y,1);
    Dataset.Test.size = size(Dataset.Test.X,2);
    
    Fit.min_cardinality_Z = ceil(size(Dataset.Training.X,2) * (1-Fit.compressionRatio));
    Error_threshold = 5e-2 * norm(Dataset.Training.Y);  % 0.0x relative error on every element of the estimated vector
    
    
    % Input layer weight matrix: W, input to the last LS layer: Y
    % Weights of the last layer should be optimized
    % Y(:,i) = mapping of i-th point of the dataset to the input of LS layer
    PLN.W = 2*rand(PLN.noNodes, Dataset.noFeatures)-1;
    PLN.b = 2*rand(PLN.noNodes, 1) -1;
    Dataset.Training.MappedX = PLN.ActivationFunc(PLN.W*Dataset.Training.X + repmat(PLN.b, 1, Dataset.Training.size));
    Dataset.Test.MappedX = PLN.ActivationFunc(PLN.W * Dataset.Test.X + repmat(PLN.b, 1, Dataset.Test.size));
    
    %% Iterative algorithm
    PLN_IterativeAlgorithm
    
    
%% Test 1 : performance drop when f belongs to the set of feasible f (satisfy constraint), namely it is good enough
    XaxisTraining = 1:Dataset.Training.size;
    XaxisTest = 1:Dataset.Test.size;
    
    plot_test1 = 0;  % change it to 1 to see the figures in every iteration
    PLN_RunTest1
    
    %% Test 2: performance drop when we use the compressed dataset to find a new f
    plot_test2 = 0;  % change it to 1 to see the figures in every iteration
    PLN_RunTest2
    
end


%% Print the results of the average and standard deviation over multiple trials
Fit

T = table({Dataset.Name; Fit.min_cardinality_Z; size(Dataset.Training.X,2); ...
    (size(Dataset.Training.X,2) - Fit.min_cardinality_Z)/size(Dataset.Training.X,2)*100; PLN.trialNum; PLN.noNodes; ...
    [num2str(mean(Fit.GeneralizationError_originalDataset),4),', ',num2str(std(Fit.GeneralizationError_originalDataset),4)]; ...
    [num2str(mean(Fit.GeneralizationError_compressedDataset),4),', ',num2str(std(Fit.GeneralizationError_compressedDataset),4)]});
T.Properties.RowNames = {'Database name', 'Size of compressed dataset', ...
    'Size of original dataset', 'Compression ratio (%)', '# Iterations for PLN', '# Hidden nodes in PLN', ...
    'Mean, std of Gen. Err. (trained with original dataset in dB)',...
    'Mean, std of Gen. Err. (trained with compressed dataset in dB)'};
T.Properties.VariableNames = {'Values'}


save(sprintf('Results/%s_CompressRatio%0.2f_noHneurons%g_noTrial%g.mat',Dataset.Name, Fit.compressionRatio, PLN.noNodes, PLN.trialNum))
