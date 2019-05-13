%% fmincon

options = optimoptions('fmincon');
options = optimoptions(options,'Algorithm','sqp');
%options = optimoptions(options,'Display', 'iter');
options = optimoptions(options,'Display', 'off');
% options = optimoptions(options,'MaxFunctionEvaluations',1e8);
% options = optimoptions(options,'OptimalityTolerance', 1e-15);
% options = optimoptions(options,'FunctionTolerance', 1e-15);
% options = optimoptions(options,'StepTolerance',1e-15); 
[f_optimal, fval] = fmincon(Fobjective,f0,[],[],[],[],[],[],Fconstraint,options);


%% pattern search 
% options = optimoptions('patternsearch');
% options = optimoptions(options,'MeshTolerance', 1e-10);
% options = optimoptions(options,'ConstraintTolerance', 1e-10);
% options = optimoptions(options,'StepTolerance', 1e-10);
% options = optimoptions(options,'FunctionTolerance', 1e-10);
% options = optimoptions(options,'MaxIterations', 1e10);
% options = optimoptions(options,'MaxFunctionEvaluations', 1e5);
% options = optimoptions(options,'AccelerateMesh', true);
% options = optimoptions(options,'UseCompleteSearch', true);
% options = optimoptions(options,'Display', 'iter');
% [f_optimal, fval] = patternsearch(Fobjective,f0,[],[],[],[],[],[],Fconstraint,options);

