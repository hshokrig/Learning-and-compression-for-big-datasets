function [r_hat_orth,a_hat,img_temp]=my_func2(r_hat,Kappa,Index,X_rhat,Num_regen)
N=size(r_hat,2);
Q=size(r_hat,1);
img_temp=zeros(size(X_rhat,1),Num_regen);

for i=1:Num_regen
    cont=1;
    while cont
        my_ind=randperm(N,Kappa);
        my_temp=r_hat(:,my_ind);
        my_rank=rank(my_temp);
        if my_rank==Q
            cont=0;
        end
    end
    r_hat_orth=my_temp;
    
    temp_2=zeros(Q,1);
    temp_2(Index)=1;
    a_hat=pinv(r_hat_orth)*temp_2;
    
    img_temp(:,i)=X_rhat(:,my_ind)*a_hat;
    
end
% imshow(vec2mat(img_temp,28));
% keyboard
end