function [intersection] = computeHorizontalLineIntersections(vertices, yCurrent)
% COMPUTEHORIZONTALLINEINTERSECTIONS Computes intersection points between
% a horizontal line and a polygon.
%
% The function finds all intersection points between the polygon edges and
% a horizontal line defined by y = yCurrent. Only valid intersections within
% segment bounds are considered. Duplicate intersections are removed.
%
% Input:
%   vertices : 2xN matrix of polygon vertices (clockwise order)
%   yCurrent : y-coordinate of the horizontal line
%
% Output:
%   intersection : 2xM matrix containing intersection points

    % Circular indexing helper
    c = @(x, n) (1 + mod(x-1, n));

    intersection = [];
    N = length(vertices);

    %==========================================================
    % Traverse polygon edges and compute intersections
    %==========================================================
    for j = 1:N

        previousIndex = c(j-1,N);

        xj = vertices(1,j);
        yj = vertices(2,j);

        xi = vertices(1,previousIndex);
        yi = vertices(2,previousIndex);

        % Compute intersection with horizontal line y = yactual
        x = (yCurrent - yj) * (xj - xi)/(yj - yi) + xj;

        % Check if intersection lies within segment bounds
        if(x >= min(xj, xi) && x <= max(xj, xi) && ...
           yCurrent >= min(yj, yi) && yCurrent <= max(yj, yi))

            intersection = [intersection [x; yCurrent]];
        end 
    end

    %==========================================================
    % Remove duplicate intersection points
    %==========================================================
    [~,indx] = unique(intersection.','rows','stable');
    intersection = intersection.';
    intersection = intersection(indx,:);
    intersection = intersection.';
end