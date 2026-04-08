function updated_fire = fire_step(fire, params,drone_water_dropped_at)
    % 1. CREATE updated_fire as a copy of fire
    % We read the current state from 'fire', but save all changes to 'updated_fire'
    updated_fire = fire;
    
    % Get grid dimensions for boundary checking
    num_rows = params.grid_size(1);
    num_cols = params.grid_size(2);

    for i = 1:num_rows
        for j = 1:num_cols
            
            % ==========================================
            % FIRE BEHAVIOR LOGIC
            % ==========================================
            % Check if cell has fuel and is on fire
            if fire.consumable_grid(i,j) > 0 && fire.fire_sectors(i,j) > 0
                
                % --- Growth Phase ---
                if fire.fire_sectors(i,j) < fire.consumable_grid(i,j) % && fire.time_at_peak(i,j) == 0 
                    % Use params instead of hardcoding 0.1
                    updated_fire.fire_sectors(i,j) = fire.fire_sectors(i,j) + params.growth_rate;
                
                % --- Peak & Spread Phase ---
                elseif fire.fire_sectors(i,j) >= 1.0 && fire.time_at_peak(i,j) < params.peak_duration
                    updated_fire.time_at_peak(i,j) = fire.time_at_peak(i,j) + 1;
                    
                    % Spread to Cardinal Neighbors (N, S, E, W)
                    % We MUST check boundaries (e.g., i > 1) to prevent crashing
                    
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
            
            % ==========================================
            % EXTRA CREDIT: DIAGONAL SPREAD
            % ==========================================
            if fire.fire_sectors(i,j) == 0 && fire.consumable_grid(i,j) > 0
                % Calculate sum of Cardinal Neighbors
                neighbor_sum = 0;
                if i > 1, neighbor_sum = neighbor_sum + fire.fire_sectors(i-1, j); end % N
                if i < num_rows, neighbor_sum = neighbor_sum + fire.fire_sectors(i+1, j); end % S
                if j > 1, neighbor_sum = neighbor_sum + fire.fire_sectors(i, j-1); end % W
                if j < num_cols, neighbor_sum = neighbor_sum + fire.fire_sectors(i, j+1); end % E
                
                if neighbor_sum > 1.0
                    % Calculate Diagonal Probability (e.g., neighbor_usm = 1.2, therefore there's a 20% chance to ignite)
                    if rand() < neighbor_sum - 1.0 
                        updated_fire.fire_sectors(i,j) = params.growth_rate;
                    end
                end
            end
            
            % ==========================================
            % DRONE INTERACTION
            % ==========================================
            % Note: You need a matrix or function called `drone_water_dropped` 
            % to trigger this. I've structured it assuming it's a 2D matrix 
            % of the same size as the grid, passed into the function somehow.
            
            if drone_water_dropped_at(i, j) == 1
                updated_fire.fire_sectors(i,j) = 0;
            end
            
            % ==========================================
            % CLAMPING VALUES
            % ==========================================
            % Ensure intensity never exceeds available fuel
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



% % FUNCTION fire_step(fire, params)
% function fire_step(fire, params)
% 
% %      CREATE updated_fire  as a copy of fire
% %
% 
% for(i = 1:params.grid_size(1))
%     for(j = 1:params.grid_size(2))
% %     FOR every row 'i' in grid:
% %         FOR every column 'j' in grid:
% % 
% 
% 
% %             // Check if cell has fuel and is on fire
% %             IF consumable_grid[i][j] > 0 AND fire_sectors[i][j] > 0:
% % 
% 
% if (fire.consumable_grid(i,j) > 0 && fire.fire_sectors(i,j) > 0)
% 
% 
% %                 // Growth Phase
% %                 IF fire_sectors[i][j] < consumable_grid[i][j] AND time_at_peak[i][j] == 0:
% %                     updated_fire.fire_sectors[i][j] += 0.1
% %
% if (fire.fire_sectors(i,j)<fire.consumable_grid(i,j)  && fire.time_at_peak(i,j)== 0)
%     fire.fire_sectors(i,j) = fire.fire_sectors(i,j) + 0.1;
% 
% 
% 
% 
% 
% %                 // Peak & Spread Phase
% %                 ELSE IF fire_sectors[i][j] == 1.0 AND time_at_peak[i][j] < 5:
% %                     updated_fire.time_at_peak[i][j] += 1
% %                     // Spread to Cardinal Neighbors (N, S, E, W)
% %                     Increase neighbor intensity by 0.1 if their consumable_grid > 0
% % 
% elseif ( fire.fire_sectors(i,j) == 1.0 &&  fire.time_at_peak(i,j)<5)
% 
%  fire.time_at_peak(i,j) = fire.time_at_peak(i,j)+ 1;
% %                     // Spread to Cardinal Neighbors (N, S, E, W)
% %                     Increase neighbor intensity by 0.1 if their consumable_grid > 0
% 
% 
% 
%  %                 // Decay Phase
% %                 ELSE:
% %                     updated_fire.fire_sectors[i][j] -= 0.1
% %                     updated_fire.consumable_grid[i][j] -= 0.1
% else
% fire.fire_sectors(i,j) =  fire.fire_sectors(i,j) -0.1
% fire.consumable_grid(i,j) =  fire.consumable_grid(i,j) -0.1
% end
% end
% 
% 
% % 
% %             // Handle Diagonal Spread (Extra Credit)
% %             IF fire_sectors[i][j] == 0 AND consumable_grid[i][j] > 0:
% % %                 IF sum(Cardinal Neighbors) > 1.0:
% % %                     Calculate Diagonal Probability
% % %                     Apply ignition based on probability
% if (fire.fire_sectors(i,j) ==0&& fire.consumable_grid(i,j)>0)
% 
% end
% % 
% %             // Drone Interaction
% %             IF drone_water_dropped_at(i, j):
% %                 updated_fire.fire_sectors[i][j] = 0
% if  drone_water_dropped_at(i, j)
% 
% fire.fire_sectors(i,j)=0
% end
% % 
% %             // Clamp Values to ensure intensity never exceeds 1.0 or drops below 0.0
% %             CLAMP updated_fire.fire_sectors[i][j] BETWEEN 0.0 AND consumable_grid[i][j]
% 
% 
% % 
% % // Save the newly calculated state to the historical array fire_simulation[current_step] = updated_fire 
% % 
% 
%     end
%     end
%     return (fire)
% % RETURN updated_fire
% % 
