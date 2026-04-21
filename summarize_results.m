function summarize_results(droneFleet, fire, params)

numDrones = length(droneFleet);

%%Console table
fprintf('\n%s\n', repmat('=', 1, 62));
fprintf('SIMULATION SUMMARY\n');
fprintf('%s\n', repmat('=', 1, 62));
fprintf('%-5s  %-14s  %-16s  %-16s\n', ...
        'ID', 'Final Pos', 'Dist Traveled', 'Cells Extinguished');
fprintf('%s\n', repmat('-', 1, 62));

% Pre-allocate arrays for the CSV table
IDs = zeros(numDrones, 1);
FinalRow = zeros(numDrones, 1);
FinalCol = zeros(numDrones, 1);
DistTrav = zeros(numDrones, 1);
CellsOut = zeros(numDrones, 1);

for ii = 1:numDrones
    d = droneFleet(ii);

    fprintf('%-5d [%3d, %3d] %-16.2f  %-16d\n', ...
            d.ID, d.Position(1), d.Position(2), ...
            d.DistanceTraveled, d.CellsExtinguished);

    IDs(ii) = d.ID;
    FinalRow(ii) = d.Position(1);
    FinalCol(ii) = d.Position(2);
    DistTrav(ii) = d.DistanceTraveled;
    CellsOut(ii) = d.CellsExtinguished;
end

%%Fire grid stats
cellsStillBurning = sum(fire.fire_sectors(:) > params.extinguishThreshold);
fuelRemaining = sum(fire.consumable_grid(:));
fuelConsumed = params.grid_size(1) * params.grid_size(2) - fuelRemaining;

fprintf('%s\n', repmat('-', 1, 62));
fprintf('Cells still above extinguish threshold:%d\n', cellsStillBurning);
fprintf('Total fuel remaining:%.2f\n', fuelRemaining);
fprintf('Estimated fuel consumed:%.2f\n', fuelConsumed);
fprintf('%s\n', repmat('=', 1, 62));

%%Write CSV
T = table(IDs, FinalRow, FinalCol, DistTrav, CellsOut, ...
    'VariableNames', {'DroneID', 'FinalRow', 'FinalCol', ...
                      'DistanceTraveled', 'CellsExtinguished'});

writetable(T, 'drone_summary.csv');
fprintf('\n  CSV saved  → drone_summary.csv\n');

%%Save full workspace snapshot
save('simulation_data.mat', 'fire', 'droneFleet', 'params');
fprintf('  MAT saved  → simulation_data.mat\n\n');
    % Saves fire, droneFleet, and params so anyone can reload and inspect offline
end
