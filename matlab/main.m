close all; clear; clc;

%% Coverage Path Planning for Agricultural UAV in Arbitrary Polygon Areas
%
% Implementation of the algorithm described in:
%
% Li, J., Sheng, H., Zhang, J., & Zhang, H. (2023).
% "Coverage Path Planning Method for Agricultural Spraying UAV
% in Arbitrary Polygon Area".
% Aerospace, 10(7), 755.
% https://doi.org/10.3390/aerospace10090755
%
% -------------------------------------------------------------------------
% Description
% -------------------------------------------------------------------------
% This script implements the coverage path planning method proposed in the
% referenced paper for agricultural spraying UAVs operating over arbitrary
% polygonal areas.
%
% The implementation includes:
%   - Margin reduction algorithm to handle internal obstacles such as
%     ditches and channels.
%   - Detection of concave vertices in polygonal regions.
%   - Topology-based decomposition of concave polygons.
%   - Coverage path generation for efficient spraying missions.
%
% -------------------------------------------------------------------------
% Repository
% -------------------------------------------------------------------------
% GitHub repository:
% https://github.com/tomisuarez2/concavity-aware-coverage-planning
%
% -------------------------------------------------------------------------
% Author
% -------------------------------------------------------------------------
% Tomás Suárez
% Mechatronics Engineer
%
% -------------------------------------------------------------------------
% Date
% -------------------------------------------------------------------------
% March 2026
%
% -------------------------------------------------------------------------
% Notes
% -------------------------------------------------------------------------
% This implementation was developed for research and educational purposes.
% The code is not an official implementation by the original authors of
% the referenced article.

%% Add paths

addpath("core\.")
addpath("decomposition\.")
addpath("geometry\.")
addpath("utils\.")

%% We started by specifying the clockwise vertices that define the polygon as columns of the following array.

% Vertices
vertices = [[0;0],[-2;9],[4;11],[2;5],[9;3]];

%% Vertices plot.

% Plot parameters.
lwAuxiliary = 1.5; 

titleFontsize = 34; 
ticksFontsize = 16; 

figure(1);
ax_main = axes;
hold(ax_main, 'on');
grid(ax_main, 'on');
xlabel('X axis [u]')
ylabel('Y axis [u]')
title('Trajectory', ...
    'FontSize', titleFontsize, ...
    'FontName', 'Times New Roman', ...
    'FontWeight', 'bold', ...
    'Interpreter', 'none', ...
    'Color', 'k');
ax_main.FontSize = ticksFontsize;
ax_main.LineWidth = lwAuxiliary;
     
plot([vertices(1,:) vertices(1,1)], [vertices(2,:) vertices(2,1)], 'Color', 'blue', 'Marker', 'o', 'LineWidth', 2, 'DisplayName', 'Vertices')

%% Trajectory computation.

h = 0.1;  % Reduced área offset.
d = 0.25; % Spray fumigation width.
psi = 120; % Trajectory orientation from +X. [°]
[trajectoryPoints, coveredArea] = generateCoverageTrajectory(vertices, h, d, psi);

%% Remove paths

rmpath("core\.")
rmpath("decomposition\.")
rmpath("geometry\.")
rmpath("utils\.")

%% ========== FIGURE PLOTS ========== 

plot(coveredArea, 'DisplayName', 'Covered Area')
for k = 1:size(trajectoryPoints,2)-1
    if mod(k,2) == 0
        color = 'k'; % Black
        lineStye = '--';
        lineWidth = 1;
    else
        color = '#77AC30'; % Green
        lineStye = '-';
        lineWidth = 2;
    end
    aux = plot(trajectoryPoints(1,k:k+1),trajectoryPoints(2,k:k+1),'Color', color,'LineWidth', lineWidth, 'LineStyle', lineStye);
    aux.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
plot(trajectoryPoints(1,1), trajectoryPoints(2,1), 'Color', '#A2142F', 'LineWidth', 2, 'Marker', 'pentagram', 'DisplayName', 'Start point')
plot(trajectoryPoints(1,end), trajectoryPoints(2,end), 'Color', '#4DBEEE', 'LineWidth', 2, 'Marker', 'pentagram', 'DisplayName', 'End point')

lgd = legend('show', 'Location', 'northeast');
lgd.Box = 'on';
lgd.Color = 'white';
lgd.EdgeColor = 'black';
lgd.LineWidth = 1;
    
    
