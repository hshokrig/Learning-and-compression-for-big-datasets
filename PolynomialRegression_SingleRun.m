%% Initializations
clc, clear
addpath(genpath('Datasets'));
addpath(genpath('Functions'));

Dataset.Training.size = 100;
Dataset.Test.size = 1000;
Dataset.Training.X = linspace(0,4*pi,Dataset.Training.size);
Noise = 0.1*randn(1,Dataset.Training.size);
% Noise = 0;
Dataset.Training.Y = sin(Dataset.Training.X) + Noise;
Dataset.Test.X = linspace(0,4*pi,Dataset.Test.size);
Dataset.Test.Y = sin(Dataset.Test.X);

%% Training
Fit.order = 10;
% polynomial of degree 7
FittedFunction = @(p,xdata) polyval(p,xdata);
% p(1)*xdata.^7 + p(2)*xdata.^6 + p(3)*xdata.^5 + p(4)*xdata.^4 + p(5)*xdata.^3 + p(6)*xdata.^2 + p(7)*xdata + p(8);
Fit.function = FittedFunction;

%% Iterative algorithm
% initializations
Dataset.Training.select = true(1,Dataset.Training.size);
Dataset.Training.SelectedX = Dataset.Training.X(Dataset.Training.select);
Dataset.Training.SelectedY = Dataset.Training.Y(Dataset.Training.select);
f0 = polyfit(Dataset.Training.SelectedX, Dataset.Training.SelectedY, Fit.order); %initial point
Fit.f_optimal = f0;

Error_threshold = 1e-1;
Fit.min_cardinality_Z = 15;
cont = 1;
StallF = 0; StallZ = 0; MaxStallF = 20; MaxStallZ = 20; StallF_Threshold = 1e-2;
MaxNumIter = 1e8;
k = 1;

% main iteration
while cont
%     keyboard
    
    % objective function
    % Fobjective = @(p)sum((FittedFunction(p,Training_x) - Training_y).^2);
    Fobjective = @(x)PolynomialRegression_objfunc_p2(x, FittedFunction, Dataset.Training.SelectedX, Dataset.Training.SelectedY);
    
    % Constraint function
    % Fconstraint = @(p)[sum((FittedFunction(p,Dataset.Training.X) - Dataset.Training.Y).^2)/Dataset.Training.size - Error_threshold,[]];
    Fconstraint = @(x)PolynomialRegression_confun_p2(x, FittedFunction, Dataset.Training, Error_threshold);
    
    % iteration on p for a fix z
    PolynomialRegression_optimizer
    if norm(f_optimal - Fit.f_optimal) < StallF_Threshold
        StallF = StallF +1;
    else
        StallF = 0;
    end
    Fit.f_optimal = f_optimal;
    
    %%%%---------------------------------------------------------------%%%%
    % Why different answer than (Fit.function)
    % Fconstraint(Fit.function)<0 so a feasible point
    % Fobjective(Fit.function) << Fobjective(f_star), so why not finding p?
    % The only solution now is to set p0 = Fit.function !!!!!
    %%%%---------------------------------------------------------------%%%%
    
    % iteration on z for a fix f
    Training_error = PolynomialRegression_objfunc_p1(Fit.f_optimal, FittedFunction, Dataset.Training.X, Dataset.Training.Y);
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
    Dataset.Training.SelectedX = Dataset.Training.X(Dataset.Training.select);
    Dataset.Training.SelectedY = Dataset.Training.Y(Dataset.Training.select);
    
    % prepare for the next iteration
    
%     [k, StallF, StallZ]
    if (k > MaxNumIter) | (StallF > MaxStallF ) | (StallZ > MaxStallZ )
        % it can be modified to account for stallment in f_star or in z_star for like N times
        cont = 0;
    end
    
    k = k+1;
    
end


%% Test 1 : performance drop when f belongs to the set of feasible f (satisfy constraint), namely it is good enough
Fit.f_true_optimal = polyfit(Dataset.Training.X, Dataset.Training.Y, Fit.order); 

Dataset.Test.EvalY_f_optimal_test1 = FittedFunction(Fit.f_optimal, Dataset.Test.X);
Dataset.Test.EvalY_f_true_optimal_test1 = FittedFunction(Fit.f_true_optimal, Dataset.Test.X);
Fit.GeneralizationError_optimal_test1 = PolynomialRegression_objfunc_p2(Fit.f_optimal, Fit.function, Dataset.Test.X, Dataset.Test.Y);
Fit.GeneralizationError_true_optimal_test1 = PolynomialRegression_objfunc_p2(Fit.f_true_optimal, Fit.function, Dataset.Test.X, Dataset.Test.Y);

figure(1)
subplot 211
plot(Dataset.Training.X,Dataset.Training.Y,'o')
hold on
plot(Dataset.Training.SelectedX,Dataset.Training.SelectedY,'bs','MarkerFaceColor','b')
plot(Dataset.Test.X,Dataset.Test.EvalY_f_true_optimal_test1,'b')
plot(Dataset.Test.X,Dataset.Test.EvalY_f_optimal_test1,'r')
legend('Original dattaset','Compressed dataset (z*)','Fuction fitted with original dataset','Solution of our optimization problem (f*)','Location','northeastoutside')
title('Test 1')
hold off

%% Test 2: performance drop when we use the compressed dataset to find a new f
Fit.f_optimal_test2 = polyfit(Dataset.Training.SelectedX, Dataset.Training.SelectedY, Fit.order); 

Dataset.Test.EvalY_f_optimal_test2 = FittedFunction(Fit.f_optimal_test2, Dataset.Test.X);
Fit.GeneralizationError_optimal_test2 = PolynomialRegression_objfunc_p2(Fit.f_optimal_test2, Fit.function, Dataset.Test.X, Dataset.Test.Y);

figure(1)
subplot 212
plot(Dataset.Training.X,Dataset.Training.Y,'o')
hold on
plot(Dataset.Training.SelectedX,Dataset.Training.SelectedY,'bs','MarkerFaceColor','b')
plot(Dataset.Test.X,Dataset.Test.EvalY_f_true_optimal_test1,'b')
plot(Dataset.Test.X,Dataset.Test.EvalY_f_optimal_test2,'r')
legend('Original dataset','Compressed dataset (z*)','Fuction fitted with original dataset','New fuction fitted with compressed dataset','Location','northeastoutside')
title('Test 2')
hold off


