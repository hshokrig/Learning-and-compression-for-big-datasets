function [c, ceq] = PLN_confun_p2(x, LossFunc, Training, Error_threshold)

% Nonlinear inequality constraints
c = (sum(LossFunc(x, Training.MappedX, Training.Y)))/Training.size - Error_threshold;

% Nonlinear equality constraints
ceq = [];