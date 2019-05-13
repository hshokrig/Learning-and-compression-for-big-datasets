options = optimoptions('fminunc');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'Algorithm', 'quasi-newton');
options = optimoptions(options,'MaxFunctionEvaluations', 1e6);
options = optimoptions(options,'OptimalityTolerance', 1e-10);
options = optimoptions(options,'FunctionTolerance', 1e-10);
options = optimoptions(options,'StepTolerance', 1e-10);
[Fit.f_optimal_test2, ~] = fminunc(Fobjective, Fit.f_optimal_test2, options);
