function [c, ceq] = PolynomialRegression_confun_p2(x, FittedFunction, Training, Error_threshold)

% Nonlinear inequality constraints
c = sum((FittedFunction(x,Training.X) - Training.Y).^2)/Training.size - Error_threshold;

% Nonlinear equality constraints
ceq = [];