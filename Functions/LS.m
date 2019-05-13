function [T_hat_train,T_hat_test,train_accuracy,test_accuracy]=LS(...
                        X_train, T_train, X_test, T_test, lam)                    
P=size(X_train,1);
N=size(X_train,2);
if P < N
    W_ls=(T_train*X_train')/(X_train*X_train'+lam*eye(size(X_train,1)));
else
    W_ls=(T_train/(X_train'*X_train+lam*eye(size(X_train,2))))*X_train';
end

T_hat_train=W_ls*X_train;
T_hat_test=W_ls*X_test;
train_accuracy=Calculate_accuracy(T_train,T_hat_train);
test_accuracy=Calculate_accuracy(T_test,T_hat_test);
end
