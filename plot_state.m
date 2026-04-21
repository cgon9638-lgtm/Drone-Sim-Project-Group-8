function plot_state(fire, droneFleet, currentTime)

figure(1);
clf; % clear figure each step for a clean redraw

%%Fire heatmap
imagesc(fire.fire_sectors);
colormap(hot);
colorbar;
caxis([0, 1]); % fix colour scale so intensity reads consistently
hold on;

%%Drone markers
% imagesc maps column → X axis, row → Y axis, so plot(col, row)
for ii = 1 : length(droneFleet)
    r = droneFleet(ii).Position(1);
    c = droneFleet(ii).Position(2);

    plot(c, r, 's', 'MarkerSize', 10, 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'black');

    text(c + 0.4, r, sprintf('D%d', droneFleet(ii).ID),'Color', 'white', 'FontWeight', 'bold', 'FontSize', 8);
end

hold off;
axis equal tight;
xlabel('Column');
ylabel('Row');
title(sprintf('Fire Simulation|t = %.1f|Max intensity = %.3f', currentTime, max(fire.fire_sectors(:))));

drawnow;   % flush graphics buffer so animation appears live

end
