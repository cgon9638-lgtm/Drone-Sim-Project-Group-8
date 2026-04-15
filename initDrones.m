function droneFleet = initDrones(numDrones)
    % Initialize an empty struct array
    droneFleet = struct('ID', {}, 'Position', {}, 'Target', {}, ...
                        'Status', {}, 'DistanceTraveled', {}, 'CellsExtinguished', {});
                    
    for i = 1:numDrones
        droneFleet(i).ID = i;
        % Spawn them at random locations on the 30x30 grid to start
        droneFleet(i).Position = [randi([1, 30]), randi([1, 30])]; 
        droneFleet(i).Target = [0, 0]; % No target yet
        droneFleet(i).Status = 'searching';
        droneFleet(i).DistanceTraveled = 0;
        droneFleet(i).CellsExtinguished = 0;
    end
end