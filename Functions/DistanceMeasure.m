function Distances = DistanceMeasure(Index, t_hati_test_artificial_data, measure_type)

t_actual = UnitaryVectorCreator(size(t_hati_test_artificial_data,1),Index);
t_actual = repmat(t_actual,1,size(t_hati_test_artificial_data,2));

if measure_type == 1 % check Euc. distance
    Distances = sum((abs(t_actual - t_hati_test_artificial_data)).^2,1);

elseif measure_type == 2 % Do not include Index class in the computation
    t_actual_2 = t_actual;
    t_actual_2(Index,:) = [];
    t_hati_test_artificial_data_2 = t_actual;
    t_hati_test_artificial_data_2(Index,:) = [];
    t_hati_test_artificial_data_2(Index,:) = [];
    Distances = sum((abs(t_actual_2 - t_hati_test_artificial_data_2)).^2,1);
    
elseif measure_type == 3 
    Distances = -sum(log(abs(t_actual - t_hati_test_artificial_data)),1);
    
elseif measure_type == 4 
    Distances = -sum(1./(abs(t_actual - t_hati_test_artificial_data)+eps),1);
    
end

end

