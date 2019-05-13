Training_error = LossFunc(Fit.f_optimal, Dataset.Training.MappedX, Dataset.Training.Y) + PLN.lam * norm(Fit.f_optimal);
[~,sorted_index] = sort(abs(Training_error));
z_optimal = zeros(1,Dataset.Training.size);
z_optimal(sorted_index(1:Fit.min_cardinality_Z)) = 1;