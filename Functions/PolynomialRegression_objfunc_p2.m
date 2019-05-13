function loss = PolynomialRegression_objfunc_p2(x, FittedFunction, X, Y)

DatasetSize =  size(X,2);
loss = norm(FittedFunction(x,X) - Y).^2/DatasetSize;

