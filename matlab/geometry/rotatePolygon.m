function [rotatedPoints] = rotatePolygon(points, alfa)
% ROTATEPOLYGON Rotates a polygon in the plane by a given angle.
%
% The polygon is defined by vertices ordered clockwise. The rotation is
% performed around the centroid of the polygon.
%
% Input:
%   points : 2xN matrix containing the polygon vertices
%   alfa   : rotation angle in degrees
%
% Output:
%   rotatedPoints : 2xN matrix containing the rotated polygon vertices

    N = length(points);

    centroid = mean(points,2); % Polygon centroid

    rotatedPoints = zeros(2,N); % Rotated vertices

    for i = 1:N

        % Translate point to centroid, rotate, and translate back
        rotatedPoints(1,i) = (points(1,i) - centroid(1))*cosd(alfa) ...
                           - (points(2,i) - centroid(2))*sind(alfa) ...
                           + centroid(1);

        rotatedPoints(2,i) = (points(1,i) - centroid(1))*sind(alfa) ...
                           + (points(2,i) - centroid(2))*cosd(alfa) ...
                           + centroid(2);

    end

end

