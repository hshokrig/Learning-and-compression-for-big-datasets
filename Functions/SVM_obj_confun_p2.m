function [objective,constraint] = SVM_obj_confun_p2(x, TrainingX, TrainingY, SelectedX, SelectedY, Error_threshold, LossFunction)

SVMModel = fitcsvm(SelectedX, SelectedY, 'KernelFunction','rbf', 'BoxConstraint',x.box,'KernelScale',x.sigma);

objective = SVM_performance(SVMModel, SelectedX, SelectedY, 0, LossFunction);
constraint = SVM_performance(SVMModel, TrainingX, TrainingY, 0, LossFunction) - Error_threshold;

end
