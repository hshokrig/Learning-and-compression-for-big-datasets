Dataset.Training.select = true(1,Dataset.Training.size);
Dataset.Training.SelectedX = Dataset.Training.MappedX(:,Dataset.Training.select);
Dataset.Training.SelectedY = Dataset.Training.Y(:,Dataset.Training.select);
f0 = rand(Dataset.dimensionY, size(Dataset.Training.SelectedX,1)); %initial point
Fit.f_optimal = f0;
Fit.z_optimal = zeros(1,Dataset.Training.size);

Told = [];
iterations.cont = 1;
iterations.StallF = 0; iterations.StallZ = 0; 
iterations.maxCount = 1e2;
iterations.count = 1;

% main iteration
while iterations.cont
    % objective function
    Fobjective = @(x)(sum(LossFunc(x, Dataset.Training.SelectedX, Dataset.Training.SelectedY)) + PLN.lam * norm(x))/size(Dataset.Training.SelectedX,2);

    % Constraint function
    Fconstraint = @(x)PLN_confun_p2(x, LossFunc, Dataset.Training, Error_threshold);
    
    % iteration on f for a fix z
    PLN_optimizerF
    iterations.StallF = computeStallF(iterations.StallF, f_optimal, Fit.f_optimal, iterations.thresholdStallF);
    Fit.f_optimal = f_optimal;
    if iterations.count == 1
        Fit.f_true_optimal = f_optimal;
    end
      
    % iteration on z for a fixed f
    PLN_optimizerZ
    iterations.StallZ = computeStallZ(iterations.StallZ, z_optimal, Fit.z_optimal);
    Fit.z_optimal = z_optimal;
    
    % Dataset selection
    Dataset.Training.select = logical(Fit.z_optimal);
    Dataset.Training.SelectedX = Dataset.Training.MappedX(:,Dataset.Training.select);
    Dataset.Training.SelectedY = Dataset.Training.Y(:,Dataset.Training.select);
    
    % print outputs 
    Tnew = table(trialCount, iterations.count, Fobjective(Fit.f_optimal), Fconstraint(Fit.f_optimal), size(Dataset.Training.SelectedX,2), size(Dataset.Training.X,2), iterations.StallF, iterations.StallZ);
    Tnew.Properties.VariableNames = {'Iteration_PLN', 'Iteration_per_PLN', 'Objective','Constraint', 'Size_compressedDataset','Size_originalDataset', 'Stall_F', 'Stall_Z'};
    T = [Told; Tnew];
    if mod(trialCount, PLN.trialNum/10) == 1
        T
    end
    Told = T;
   
    % prepare for the next iteration    
    if (iterations.count > iterations.maxCount) | (iterations.StallF > iterations.MaxStallF ) | (iterations.StallZ > iterations.MaxStallZ )
        % it can be modified to account for stallment in f_star or in z_star for like N times
        iterations.cont = 0;
    end
    
    iterations.count = iterations.count + 1;
    
end
