function [droneFleet, waterDrops] = updateDrones(droneFleet, fireGrid)
    % Initialize an empty list for water drops this turn
    % We use an empty matrix, and we will add [x, y] rows to it if a drone drops water
    waterDrops = []; 
    
    numDrones = length(droneFleet);
    
    % Step 1: Target Selection
    for i = 1:numDrones
        % If searching or target fire is already out (intensity < 0.1)
        if strcmp(droneFleet(i).Status, 'searching') || ...
           (droneFleet(i).Target(1) ~= 0 && fireGrid(droneFleet(i).Target(1), droneFleet(i).Target(2)) < 0.1)
            
            % Find the highest intensity fire on the grid
            % max(fireGrid, [], 'all') finds the absolute highest number
            % find() gets the exact row (x) and column (y) of that number
            maxFire = max(fireGrid, [], 'all');
            
            if maxFire > 0.1 % Only target if there is actually a fire!
                [targetX, targetY] = find(fireGrid == maxFire, 1); % Get first instance of max fire
                droneFleet(i).Target = [targetX, targetY];
                droneFleet(i).Status = 'moving';
            else
                droneFleet(i).Status = 'idle'; % No fires left!
            end
        end
    end
    
    % Step 2: Movement & Collision Avoidance
    for i = 1:numDrones
        if strcmp(droneFleet(i).Status, 'moving')
            currPos = droneFleet(i).Position;
            targPos = droneFleet(i).Target;
            
            % Calculate next step (moving 1 square horizontally, vertically, or diagonally)
            % sign() returns 1 if target is greater, -1 if less, 0 if equal. Perfect for 1-step grids!
            stepX = sign(targPos(1) - currPos(1));
            stepY = sign(targPos(2) - currPos(2));
            nextPos = currPos + [stepX, stepY];
            
            % Collision Avoidance Check
            collision = false;
            for j = 1:numDrones
                if i ~= j && isequal(droneFleet(j).Position, nextPos)
                    collision = true; % Someone is in the way!
                end
            end
            
            % Move if the path is clear
            if ~collision
                droneFleet(i).Position = nextPos;
                % Distance formula: sqrt((x2-x1)^2 + (y2-y1)^2)
                distMoved = sqrt(stepX^2 + stepY^2); 
                droneFleet(i).DistanceTraveled = droneFleet(i).DistanceTraveled + distMoved;
            end
        end
    end
    
    % Step 3: Extinguishing
    for i = 1:numDrones
        if isequal(droneFleet(i).Position, droneFleet(i).Target) && strcmp(droneFleet(i).Status, 'moving')
            % Drone reached the fire!
            waterDrops = [waterDrops; droneFleet(i).Position]; % Add coordinate to the list for Carlos
            droneFleet(i).CellsExtinguished = droneFleet(i).CellsExtinguished + 1;
            droneFleet(i).Status = 'searching'; % Reset to find a new fire next turn
        end
    end
end