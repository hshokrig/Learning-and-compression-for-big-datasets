function accuracy=Calculate_accuracy(T,T_hat)
%   Calculate accuracy
errnum = 0;
N=size(T,2);
for i=1:N
    score_est =  T_hat(:,i);
    score_gt = T(:,i);
    [~, maxind_est] = max(score_est);  % classifying
    [~, maxind_gt] = max(score_gt);
    if(maxind_est~=maxind_gt)
        errnum = errnum + 1;
    end
end
accuracy=(N-errnum)/N;
end