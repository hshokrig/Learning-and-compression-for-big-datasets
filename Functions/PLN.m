function [train_error, test_error, train_accuracy, test_accuracy, Total_NN_size, NumNode_opt]=...
    PLN(X_train, T_train, X_test, T_test, g, NumNodes, eps_o, mu, kmax, lam, eta_n, eta_l, First_Block)
%%  Name:   PLN
%    
%   Inputs:
%   X_train:        Data matrix of the training set with P rows, where each column contains
%                   one sample of dimension P (refer to "Load_dataset.m" for more details)
%   T_train:        Target matrix of the training set with Q rows, where each
%                   column containg the one target of dimension Q (refer to "Load_dataset.m" for more details)
%   X_test:         Data matrix of the testing set with P rows, where each column contains
%                   one sample of dimension P (refer to "Load_dataset.m" for more details)
%   T_test:         Target matrix of the testing set with Q rows, where each
%                   column containg the one target of dimension Q (refer to "Load_dataset.m" for more details)
%   g:              a PP-holding non-linear function such as RLU or leaky-RLU
%   NumNodes:       Matrix containing the number of nodes in each layer (each element MUST be >= 2Q)
%                   Row i contains the number nodes of layer i on which we want to sweep, and it MUST be increasing
%   eps_o:          The regularization constant of matrix O which is equal to alpha*sqrt(2*Q), alpha MUST be >= 1            
%   mu:             the parameter mu of ADMM which controls the convergence speed            
%   kmax:           maximum number of iteration in ADMM algorithm
%   lam:            lagrangian multiplier of the regularized least-square in the first layer 
%   eta_n:          NME threshold for adding new nodes to the network 
%   eta_l:          NME threshold for adding new layer to the network 
%   First_Block:    Represents the choice of the algorithm in the first sublayer which in our case is 'LS' 
% 
%   Outputs:
%   train_error:    The training NME in db scale
%   test_error:     The testing NME in db scale
%   train_accuracy: The trainging accuracy
%   test_accuracy:  The testing accuracy
%   Total_NN_size:  The squence of total number of random nodes in the network at the time of training
%   NumNode_opt:    The optimum number of random nodes derived by PLN in each layer
% 
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   
%   Paper:          Progressive Learning for Systematic Design of Large Neural Network
%   Authors:        Saikat Chatterjee, Alireza M. Javid, Mostafa Sadeghi, Partha P. Mitra, Mikael Skoglund 
%   Organiztion:    KTH Royal Institute of Technology
%   Contact:        Alireza M. Javid, almj@kth.se
%   Website:        www.ee.kth.se/reproducible/
% 
%   ***September 2017***

%%

P=size(X_train,1);  %   Data Dimension
Q=size(T_train,1);
VQ=[eye(Q);-eye(Q)];

size_counter=0;
train_error=[];
test_error=[];
test_accuracy=[];
train_accuracy=[];
Total_NN_size=[];   %   the sequence of total number of random nodes in the network
NumNode_opt=[];     %   The set of optimum number of nodes in each layer

%% First layer Block
switch First_Block
    case {'LS'}
        [train_label_firstBlock,test_label_firstBlock,train_accuracy_firstBlock,test_accuracy_firstBlock]=LS(...
            X_train,T_train,X_test,T_test, lam);
end

train_error(1)=Calculate_error(T_train,train_label_firstBlock);
test_error(1)=Calculate_error(T_test,test_label_firstBlock);
test_accuracy(1)=test_accuracy_firstBlock;
train_accuracy(1)=train_accuracy_firstBlock;
Total_NN_size=[Total_NN_size,size_counter];     %   At this point, the total number of random nodes is zero in the network

%   Initializing the algorithm for the first time
Yi=X_train;
t_hati=train_label_firstBlock;
Pi=P;

%%%%%%%%    Test
Yi_test=X_test;
t_hati_test=test_label_firstBlock;
%%%%%%%%

Thr_l=1;    %   The flag correspoding to eta_l
layer=0;
while layer<size(NumNodes,1)
    layer=layer+1;
    
    if Thr_l==1
        Ri=2*rand(NumNodes(layer,1)-2*Q, Pi)-1;     %   Generating the random matrix R
        Zi_part1=VQ*t_hati;
        Zi_part1_test=VQ*t_hati_test;
        
        Thr_n=1;    %   The flag correspoding to eta_n
        i=0;
        while i<size(NumNodes,2)
            i=i+1;
            if i==2
                Thr_n=1;
            end
            
            if Thr_n==1
                ni=NumNodes(layer,i);
                
                Total_NN_size=[Total_NN_size,size_counter+ni-2*Q];  %   The total number of random nodes is updating
                
                if i>1
                    Ri=[Ri;2*rand(ni-NumNodes(layer,i-1), Pi)-1];   %   adding new random nodes to the network
                end
                
                Zi_part2=Ri*Yi;
                Zi_part2=normc(Zi_part2);   %   The regularization action to be done at each layer
                Zi=[Zi_part1;Zi_part2];
                Yi_temp=g(Zi);

                Oi=LS_ADMM(T_train,Yi_temp,eps_o, mu, kmax);    %   The ADMM solver for constrained least square
                t_hati=Oi*Yi_temp;
                
                train_error=[train_error,Calculate_error(T_train,t_hati)];
                train_accuracy=[train_accuracy,Calculate_accuracy(T_train,t_hati)];
                
                %%%%%%%%%%  Test
                %   Following the same procedure for test data
                Zi_part2_test=Ri*Yi_test;
                Zi_part2_test=normc(Zi_part2_test);
                Zi_test=[Zi_part1_test;Zi_part2_test];
                Yi_test_temp=g(Zi_test);
                t_hati_test=Oi*Yi_test_temp;
                
                test_error=[test_error,Calculate_error(T_test,t_hati_test)];
                test_accuracy=[test_accuracy,Calculate_accuracy(T_test,t_hati_test)];

                %    checking to see if any of the thresholds has been reached or not
                Thr_n=((train_error(end-1)-train_error(end))/abs(train_error(end-1)))>=eta_n;
                
                if size(NumNodes,2)==1
                    if i==1 && layer>1
                        Thr_l=((train_error(end-1)-train_error(end))/abs(train_error(end-1)))>=eta_l;
                    end
                else
                    if i==1
                        error_temp=train_error(end-1);
                    end
                end
                
            end
            
        end
        
        if size(NumNodes,2)>1
            Thr_l=((error_temp-train_error(end))/abs(error_temp))>=eta_l;
        end
        
        %    updating the variables for the next layer
        Yi=Yi_temp;
        Yi_test=Yi_test_temp;
        Pi=ni;
        NumNode_opt=[NumNode_opt,ni];   %   Optimum number of nodes at this layer
        size_counter=size_counter+ni-2*Q;   % Updating the total number of random nodes at the end of each layer
    end
end

return
