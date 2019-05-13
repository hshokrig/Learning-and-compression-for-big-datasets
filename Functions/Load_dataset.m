function [training_feats, H_train, testing_feats, H_test]=Load_dataset(Dataset)
%%  NOTE:
%
%   In case you want to test your own dataset, note that the arrangment of
%   the output of this function must be as follows:
%
%   training_feats: A matrix with N columns and P rows, where N is the number of
%                   the training samples and P is the dimension of each sample
%
%   H_train:        A matrix with N columns and Q rows, where N is the number of
%                   the training samples and Q is the dimension of the target
%                   (In classification: each columns has only one element "1"
%                   indicating the class and the rest of the elements are "0")
%
%   testing_feats:  A matrix with M columns and P rows, where M is the number of
%                   the testing samples and P is the dimension of each sample
%
%   H_test:        A matrix with M columns and Q rows, where M is the number of
%                   the testing samples and Q is the dimension of the target
%                   (In classification: each columns has only one element "1"
%                   indicating the class and the rest of the elements are "0")
%
%%

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % %           Classification Datasets         % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

switch Dataset
    case {'Vowel'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %   Vowel database
        % %   Data_dimension=10, Sample_number=990, Label_number=11
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Vowel.mat')
        Train_num=48*11;
        Test_num=42*11;
        training_feats=featureMat(:,1:Train_num);
        H_train=labelMat(:,1:Train_num);
        testing_feats=featureMat(:,1+Train_num:Train_num+Test_num);
        H_test=labelMat(:,1+Train_num:Train_num+Test_num);
        
    case {'ExtendedYaleB'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %   Extended YaleB database
        % %   Data_dimension=504, Sample_number=2414, Label_number=38
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        load('ExtendedYaleB.mat')
        Train_num=1600;
        Test_num=800;
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=labelMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'AR'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %   AR database
        % %   Data_dimension=540, Sample_number=2600, Label_number=100
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('AR.mat')
        Train_num=1800;
        Test_num=800;
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=labelMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Satimage'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Satimage database
        %   Data_dimension=36, Sample_number=4435(train)+2000(test), Label_number=7
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Satimage.mat')
        Train_num=4435;
        Test_num=2000;
        training_feats=train_x(:,1:Train_num);
        testing_feats=test_x(:,1:Test_num);
        H_train=train_y(:,1:Train_num);
        H_test=test_y(:,1:Test_num);
        
    case {'Scene15'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %   Scene15 database,
        % %   Data_dimension=3000, Sample_number=4485, Label_number=15
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Scene15.mat')
        Train_num=3000;
        Test_num=1400;
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=labelMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Caltech101'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %   Caltech101 database
        % %   Data_dimension=3000, Sample_number=9144, Label_number=102
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Caltech101.mat')
        Train_num=6000;
        Test_num=3000;
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=labelMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Letter'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Letter database
        %   Data_dimension=16, Sample_number=20000, Label_number=26
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Letter.mat')
        Train_num=13333;
        Test_num=6667;
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=labelMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'NORB'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   NORB database
        %   Data_dimension=2048, Sample_number=24300(train)+24300(test), Label_number=5
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('NORB.mat')
        Train_num=24300;
        Test_num=24300;
        training_feats=train_x(1:Train_num,:)';
        testing_feats=test_x(1:Test_num,:)';
        H_train=train_y(1:Train_num,:)';
        H_test=test_y(1:Test_num,:)';
        
    case {'Shuttle'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Shuttle database
        %   Data_dimension=9, Sample_number=43500(train)+14500(test), Label_number=7
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Shuttle.mat')
        Train_num=43500;
        Test_num=14500;
        training_feats=train_x(:,1:Train_num);
        testing_feats=test_x(:,1:Test_num);
        H_train=train_y(:,1:Train_num);
        H_test=test_y(:,1:Test_num);
        
    case {'MNIST'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   MNIST database
        %   Data_dimension=784, Sample_number=60000(train)+10000(test), Label_number=10
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('MNIST.mat')
        Train_num=60000;
        Test_num=10000;
        training_feats=train_x(:,1:Train_num);
        testing_feats=test_x(:,1:Test_num);
        H_train=train_y(:,1:Train_num);
        H_test=test_y(:,1:Test_num);
        
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % % % % % % % % % % % % % % %           Regression Datasets         % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        
    case {'Parkinsons'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Parkinsons_Telemonitoring databas
        %   Data_dimension=20, Sample_number=5875, Target_number=2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Parkinsons_Telemonitoring.mat')
        Train_num=4000;
        Test_num=1875;
        featureMat=DataMat(:,[1:4,7:22])';
        targetMat=DataMat(:,[5,6])';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Pyrim'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Pyrim databas
        %   Data_dimension=27, Sample_number=74, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Pyrim.mat')
        Train_num=49;
        Test_num=25;
        featureMat=DataMat(:,2:28)';
        targetMat=DataMat(:,1)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Bodyfat'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Bodyfat databas
        %   Data_dimension=14, Sample_number=252, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Bodyfat.mat')
        Train_num=168;
        Test_num=84;
        featureMat=DataMat(:,[1,3:15])';
        targetMat=DataMat(:,2)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Housing'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Housing databas
        %   Data_dimension=13, Sample_number=506, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Housing.mat')
        Train_num=337;
        Test_num=169;
        featureMat=DataMat(:,1:13)';
        targetMat=DataMat(:,14)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Strike'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Strike databas
        %   Data_dimension=6, Sample_number=625, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Strike.mat')
        Train_num=416;
        Test_num=209;
        featureMat=DataMat(:,[1:2,4:7])';
        targetMat=DataMat(:,3)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Balloon'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Balloon databas
        %   Data_dimension=1, Sample_number=2001, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Balloon.mat')
        Train_num=1334;
        Test_num=667;
        featureMat=DataMat(:,1)';
        targetMat=DataMat(:,2)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Space_ga'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Space_ga database
        %   Data_dimension=6, Sample_number=3017, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Space_ga.mat')
        Train_num=2071;
        Test_num=1036;
        featureMat=DataMat(:,2:7)';
        targetMat=DataMat(:,1)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
    case {'Abalone'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Abalone databas
        %   Data_dimension=8, Sample_number=4177, Target_number=1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load('Abalone.mat')
        Train_num=2784;
        Test_num=1393;
        featureMat=DataMat(:,1:8)';
        targetMat=DataMat(:,9)';
        Rand_index=randperm(size(featureMat,2));
        featureMatR=featureMat(:,Rand_index);
        labelMatR=targetMat(:,Rand_index);
        training_feats=featureMatR(:,1:Train_num);
        H_train=labelMatR(:,1:Train_num);
        testing_feats=featureMatR(:,1+Train_num:Train_num+Test_num);
        H_test=labelMatR(:,1+Train_num:Train_num+Test_num);
        
end

end