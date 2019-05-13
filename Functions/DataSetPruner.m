function new_img_pruned = DataSetPruner(Index, new_img, t_hati_test_artificial_data, Num_regen_pruned, measure_type)

Distances = DistanceMeasure(Index, t_hati_test_artificial_data, measure_type);
[Distances_value, Distances_index] = sort(Distances,'ascend');

new_img_pruned = new_img(:,Distances_index(1:Num_regen_pruned));

return
