function StallF = computeStallF(StallF, f_optimal_new, f_optimal_old, StallF_Threshold)

if norm(f_optimal_new - f_optimal_old) < StallF_Threshold
        StallF = StallF +1;
else
        StallF = 0;
end

end
