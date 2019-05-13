function [X_Train_reduced,T_Train_reduced]=Reduce_dataset(X_train,T_train,Index,Num_rem)

X_Train_reduced = X_train;
T_Train_reduced =T_train;

temp_ind=find(T_train(Index,:)==1);
T_train_index_deleted = temp_ind(randperm(length(temp_ind),length(temp_ind) - Num_rem));
X_Train_reduced(:,T_train_index_deleted) = [];
T_Train_reduced(:,T_train_index_deleted) = [];

end
