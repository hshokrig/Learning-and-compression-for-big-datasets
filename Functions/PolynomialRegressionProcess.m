function [E_p1_D , E_p1_E] = PolynomialRegressionProcess(Dataset, Fit, Plot_variable)

f0 = Fit.f_optimal;
Error_threshold = 1e-1;
cont = 1;
StallF = 0; StallZ = 0; MaxStallF = 20; MaxStallZ = 20; StallF_Threshold = 1e-2;
MaxNumIter = 0.5e3;
k = 1;

% main iteration
while cont
    %     keyboard
    
    % objective function
    % Fobjective = @(p)sum((Fit.function(p,Training_x) - Training_y).^2);
    Fobjective = @(x)PolynomialRegression_objfunc_p2(x, Fit.function, Dataset.Training.SelectedX, Dataset.Training.SelectedY);
    
    % Constraint function
    % Fconstraint = @(p)[sum((Fit.function(p,Dataset.Training.X) - Dataset.Training.Y).^2)/Dataset.Training.size - Error_threshold,[]];
    Fconstraint = @(x)PolynomialRegression_confun_p2(x, Fit.function, Dataset.Training, Error_threshold);
    
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
    Training_error = PolynomialRegression_objfunc_p1(Fit.f_optimal, Fit.function, Dataset.Training.X, Dataset.Training.Y);
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

Dataset.Test.EvalY_f_optimal_test1 = Fit.function(Fit.f_optimal, Dataset.Test.X);
Dataset.Test.EvalY_f_true_optimal_test1 = Fit.function(Fit.f_true_optimal, Dataset.Test.X);
Fit.GeneralizationError_optimal_test1 = PolynomialRegression_objfunc_p2(Fit.f_optimal, Fit.function, Dataset.Test.X, Dataset.Test.Y);
Fit.GeneralizationError_true_optimal_test1 = PolynomialRegression_objfunc_p2(Fit.f_true_optimal, Fit.function, Dataset.Test.X, Dataset.Test.Y);

if Plot_variable == 1
    figure(1)
    subplot 211
    plot(Dataset.Training.X,Dataset.Training.Y,'o')
    hold on
    plot(Dataset.Training.SelectedX,Dataset.Training.SelectedY,'bs','MarkerFaceColor','b')
    plot(Dataset.Test.X,Dataset.Test.EvalY_f_true_optimal_test1,'b')
    plot(Dataset.Test.X,Dataset.Test.EvalY_f_optimal_test1,'r')
    legend('Original dataset (D)','Compressed dataset (z*)','Fuction fitted with original dataset','Solution of our optimization problem (f*)','Location','northeastoutside')
    title('Test 1')
    hold off
end

%% Test 2: performance drop when we use the compressed dataset to find a new f
Fit.f_optimal_test2 = polyfit(Dataset.Training.SelectedX, Dataset.Training.SelectedY, Fit.order);

Dataset.Test.EvalY_f_optimal_test2 = Fit.function(Fit.f_optimal_test2, Dataset.Test.X);
Fit.GeneralizationError_optimal_test2 = PolynomialRegression_objfunc_p2(Fit.f_optimal_test2, Fit.function, Dataset.Test.X, Dataset.Test.Y);

if Plot_variable == 1
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
end

E_p1_D = Fit.GeneralizationError_true_optimal_test1;
E_p1_E = Fit.GeneralizationError_optimal_test2;

end