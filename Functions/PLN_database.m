function [lam, noNodes] = PLN_database(Database_name)


%%  Choosing a dataset
% Choose one of the following datasets:

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % %         Classification        % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

switch Database_name
    case 'Vowel'
        lam = 1e2;     noNodes = 2000;
    case 'ExtendedYaleB'
        lam=1e7;       noNodes=3000;
    case 'AR'
        lam=1e7;       noNodes=3000;
    case 'Satimage'
        lam=1e2;       noNodes=2500;
    case 'Scene15'
        lam=1e0;       noNodes=4000;
    case 'Caltech101'
        lam=1e2;       noNodes=4000;
    case 'Letter'
        lam=1e1;       noNodes=6000;
    case 'NORB'
        lam=1e3;       noNodes=4000;
    case 'Shuttle'
        lam=1e2;       noNodes=1000;
    case 'MNIST'
        lam=1e-1;      noNodes=4000;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % %           Regression          % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

switch Database_name
    case 'Pyrim'
        lam=1e-1;      noNodes=100;
    case 'Bodyfat'
        lam=1e-1;      noNodes=50;
    case 'Housing'
        lam=1e3;      noNodes=200;
    case 'Strike'
        lam=1e3;      noNodes=300;
    case 'Balloon'
        lam=5e-3;      noNodes=400;
    case 'Space_ga'
        lam=1e-1;     noNodes=200;
    case 'Abalone'
        lam=1e-1;     noNodes=100;
    case 'Parkinsons'
        lam=1e-1;     noNodes=100;
end

