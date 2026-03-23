function [trajectoryPoints, coveredArea] = generateCoverageTrajectory(waypoints, h, d, psi)
% GENERATECOVERAGETRAJECTORY Generates a coverage trajectory over a polygonal area.
%
% The function computes a lawnmower (back-and-forth) trajectory to cover a
% polygonal area, considering a desired orientation angle. The pipeline
% includes polygon reduction, rotation, concavity-based decomposition, and
% scanline-based path generation.
%
% Input:
%   waypoints : 2xN matrix defining the polygon vertices
%   h         : inward offset distance (safety margin)
%   d         : spray width (distance between scanlines)
%   psi       : desired orientation angle (rad), 0 aligned with +X
%
% Output:
%   trajectoryPoints : 2xM matrix of trajectory points
%   coveredArea      : polyshape object of the reduced area

    %==============================================================
    % Step 1: Reduce polygon (inward offset)
    %==============================================================
    reducedPoints = reducedArea(waypoints, h);
    coveredArea = polyshape(reducedPoints(1,:), reducedPoints(2,:));

    %==============================================================
    % Step 2: Rotate polygon to align scan direction
    %==============================================================
    centroid = mean(reducedPoints,2); % Polygon centroid
    rotatedPoints = rotatePolygon(reducedPoints, centroid, -psi);

    %==============================================================
    % Step 3: Decompose polygon (remove concavities)
    %==============================================================
    [subPolygonsPoints,maxPointNumber] = ...
        decomposePolygonByConcavity(rotatedPoints,d);

    trajectoryPoints = zeros(2,maxPointNumber);

    numberSubAreas = max(subPolygonsPoints(3,:));
    start = 1;
    finish = 1;
    nTotal = length(subPolygonsPoints(3,:));
    iAbsolut = 1;

    %==============================================================
    % Step 4: Generate scanline trajectories per subarea
    %==============================================================
    for a = 1:numberSubAreas

        flag = false;

        % Find indices corresponding to current subarea
        while (~flag && finish < nTotal)
            if(subPolygonsPoints(3,finish) < a+1)
                finish = finish + 1;
            else
                flag = true;
                finish = finish - 1;
            end
        end

        currentPolygonPoints = subPolygonsPoints(1:2,start:finish);

        % Reorder vertices so lowest point is first
        currentPolygonPoints = reorderPolygonVertices(currentPolygonPoints);

        yMinimun = min(currentPolygonPoints(2,:));
        yMaximun = max(currentPolygonPoints(2,:));

        % Number of scanlines
        numberOfPaths = floor((yMaximun - yMinimun)/d);

        % Generate horizontal sweep (lawnmower pattern)
        for i = numberOfPaths : -1 : 1 

            yCurrent = yMinimun + i*d - d/2;

            pointsToAdd = ...
                computeHorizontalLineIntersections(currentPolygonPoints,yCurrent);

            % Alternate direction (zig-zag)
            if(~(mod(i,2)>1e-2))
                pointsToAdd = fliplr(pointsToAdd);
            end

            numberOfPointsToAdd = size(pointsToAdd,2);

            trajectoryPoints(:,iAbsolut:iAbsolut+numberOfPointsToAdd-1) = ...
                pointsToAdd;

            iAbsolut = iAbsolut + numberOfPointsToAdd;
        end

        start = finish + 1;
    end

    % Trim unused memory
    trajectoryPoints = trajectoryPoints(:,1:iAbsolut-1);

    %==============================================================
    % Step 5: Rotate trajectory back to original frame
    %==============================================================
    trajectoryPoints = rotatePolygon(trajectoryPoints, centroid, psi);
end