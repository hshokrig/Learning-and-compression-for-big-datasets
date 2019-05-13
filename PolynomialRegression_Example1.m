%% Initializations
clc, clear
addpath(genpath('Datasets'));
addpath(genpath('Functions'));

load Example1Func.mat
Dataset.Training.size = 100;
Dataset.Test.size = 85;
Dataset.Training.X = linspace(0,8,Dataset.Training.size);

Dataset.Test.X = linspace(0, 8, Dataset.Test.size);
Dataset.Test.Y = feval(Example1Func, Dataset.Test.X)';

%% Training
% polynomial of degree 10
% p(1)*xdata.^7 + p(2)*xdata.^6 + p(3)*xdata.^5 + p(4)*xdata.^4 + p(5)*xdata.^3 + p(6)*xdata.^2 + p(7)*xdata + p(8);
Fit.order = 10;
FittedFunction = @(p,xdata) polyval(p,xdata);
Fit.function = FittedFunction;

%% Iterative algorithm
Plot_variable = 1;
K = fliplr(round(logspace(log10(12),log10(12),12)));
MonteCarlo = 500;
E_p1_D = zeros(MonteCarlo, length(K)); E_p1_E = zeros(MonteCarlo, length(K));

for MonteCarlo_index = 1:MonteCarlo
    for K_index = 1:length(K)
        % initializations
        Noise = 0.005*randn(1,Dataset.Training.size);
        % Noise = 0;
        Dataset.Training.Y = feval(Example1Func, Dataset.Training.X)' + Noise;
        
        Dataset.Training.select = true(1,Dataset.Training.size);
        Dataset.Training.SelectedX = Dataset.Training.X(Dataset.Training.select);
        Dataset.Training.SelectedY = Dataset.Training.Y(Dataset.Training.select);
        f0 = polyfit(Dataset.Training.SelectedX, Dataset.Training.SelectedY, Fit.order); %initial point
        Fit.f_optimal = f0;
        
        
        Fit.min_cardinality_Z = K(K_index);
        
        [E_p1_D(MonteCarlo_index, K_index), E_p1_E(MonteCarlo_index, K_index)] = PolynomialRegressionProcess(Dataset, Fit, Plot_variable);
        [K(K_index), MonteCarlo_index]
    end
    
end

save(sprintf('Results/PolynomialRegression_Example1.mat'))

figure(2)
semilogy(1-K/Dataset.Training.size, mean(E_p1_D), 1-K/Dataset.Training.size, mean(E_p1_E))
legend('$E[e_{(P1)}(D)]$', '$E[e_{(P1)}(E^{\star})]$')
xlabel('Compression ratio')
ylabel('Average true generalization error')
ChangeInterpreter(gcf,'Latex')
