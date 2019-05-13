function [r_hat,X_rhat]=my_func(t_hati,T,X_train,Index)
my_ind=[];
N=size(T,2);
for i=1:N
    score_est =  T(:,i);
    [~, maxind_est] = max(score_est);  % classifying
    if(maxind_est~=Index)
        my_ind=[my_ind,i];
    end
end

r_hat=t_hati(:,my_ind);
X_rhat=X_train(:,my_ind);
end