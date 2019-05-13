function loss = PolynomialRegression_objfunc_p1(x, FittedFunction, Training_x, Training_y)

loss = (FittedFunction(x,Training_x) - Training_y).^2;

