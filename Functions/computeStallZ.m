function StallZ = computeStallZ(StallZ, z_optimal_new, z_optimal_old)

if z_optimal_new == z_optimal_old
    StallZ = StallZ +1;
else
    StallZ = 0;
end

end