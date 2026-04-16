function updated_fire = fire_step(fire, params, drone_water_dropped_at)
   
    updated_fire = fire;
    
    num_rows = params.grid_size(1);
    num_cols = params.grid_size(2);

    for i = 1:num_rows
        for j = 1:num_cols
            
            % Fire Behavior Logic 
            % Check if cell has fuel and is on fire
            if fire.consumable_grid(i,j) > 0 && fire.fire_sectors(i,j) > 0
                
                % --- Growth Phase ---
                if fire.fire_sectors(i,j) < fire.consumable_grid(i,j) 
                    updated_fire.fire_sectors(i,j) = fire.fire_sectors(i,j) + params.growth_rate;
                
                % --- Peak & Spread Phase ---
                elseif fire.fire_sectors(i,j) >= 1.0 && fire.time_at_peak(i,j) < params.peak_duration
                    updated_fire.time_at_peak(i,j) = fire.time_at_peak(i,j) + 1;
                    
                    % Spread to Cardinal Neighbors (N, S, E, W)
                    % North (i-1)
                    if i > 1 && fire.consumable_grid(i-1, j) > 0 && fire.fire_sectors(i-1, j) == 0
                        updated_fire.fire_sectors(i-1, j) = params.growth_rate;
                    end
                    % South (i+1)
                    if i < num_rows && fire.consumable_grid(i+1, j) > 0 && fire.fire_sectors(i+1, j) == 0
                        updated_fire.fire_sectors(i+1, j) = params.growth_rate;
                    end
                    % West (j-1)
                    if j > 1 && fire.consumable_grid(i, j-1) > 0 && fire.fire_sectors(i, j-1) == 0
                        updated_fire.fire_sectors(i, j-1) = params.growth_rate;
                    end
                    % East (j+1)
                    if j < num_cols && fire.consumable_grid(i, j+1) > 0 && fire.fire_sectors(i, j+1) == 0
                        updated_fire.fire_sectors(i, j+1) = params.growth_rate;
                    end
                 
                % --- Decay Phase ---
                else
                    updated_fire.fire_sectors(i,j) = fire.fire_sectors(i,j) - params.decay_rate;
                    updated_fire.consumable_grid(i,j) = fire.consumable_grid(i,j) - params.decay_rate;
                end
            end
            
            % EXTRA CREDIT: Diagonal Spread
            if fire.fire_sectors(i,j) == 0 && fire.consumable_grid(i,j) > 0
                % Calculate sum of Cardinal Neighbors
                neighbor_sum = 0;
                if i > 1, neighbor_sum = neighbor_sum + fire.fire_sectors(i-1, j); end % N
                if i < num_rows, neighbor_sum = neighbor_sum + fire.fire_sectors(i+1, j); end % S
                if j > 1, neighbor_sum = neighbor_sum + fire.fire_sectors(i, j-1); end % W
                if j < num_cols, neighbor_sum = neighbor_sum + fire.fire_sectors(i, j+1); end % E
                
                if neighbor_sum > 1.0
                    % Calculate Diagonal Probability ( neighbor_usm = 1.2, therefore there's a 20% chance to ignite)
                    if rand() < neighbor_sum - 1.0 
                        updated_fire.fire_sectors(i,j) = params.growth_rate;
                    end
                end
            end
            

            % DRONE INTERACTION
            
            if drone_water_dropped_at(i, j) == 1
                updated_fire.fire_sectors(i,j) = 0;
            end
            
            % CLAMPING VALUES
            if updated_fire.fire_sectors(i,j) > updated_fire.consumable_grid(i,j)
                updated_fire.fire_sectors(i,j) = updated_fire.consumable_grid(i,j);
            end
            
            % Ensure nothing drops below 0.0
            if updated_fire.fire_sectors(i,j) < 0
                updated_fire.fire_sectors(i,j) = 0;
            end
            if updated_fire.consumable_grid(i,j) < 0
                updated_fire.consumable_grid(i,j) = 0;
            end
            
        end
    end
end

