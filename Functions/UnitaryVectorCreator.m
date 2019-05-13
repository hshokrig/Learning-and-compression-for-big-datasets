function UnitaryVector = UnitaryVectorCreator(N,Index)
% Creates a column vector whose Index-th entry is 1. 

UnitaryVector = zeros(N,1);
UnitaryVector(Index) = 1;

end
