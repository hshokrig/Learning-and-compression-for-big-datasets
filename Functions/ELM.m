function [test_acc, train_err, T_hat, Tt_hat]=ELM(X, T, Xt, Tt, lam, NumNodes,g)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Training Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[P,N]=size(X);

%% Input layer weight matrix: W

W=2*rand(NumNodes,P)-1;
b=2*rand(NumNodes,1)-1;
ind=ones(1,N);
B=b(:,ind);
Z=W*X+B;

%% Hidden neorons

Y=g(Z);
% % Output layer weight matrix: O
if NumNodes < N
    O=(T*Y')/(Y*Y'+lam*eye(size(Y,1)));
else
    O=(T/(Y'*Y+lam*eye(size(Y,2))))*Y';
end

T_hat=O*Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Testing Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nt=size(Xt,2);

ind=ones(1,Nt);
B=b(:,ind);
Zt=W*Xt+B;

Yt=g(Zt);
Tt_hat=O*Yt;

% Test error and accuracy
test_acc=Calculate_accuracy(Tt,Tt_hat);
train_err=Calculate_accuracy(T,T_hat);


return
