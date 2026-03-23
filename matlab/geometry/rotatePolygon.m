function [rotatedPoints] = rotatePolygon(points, center, alfa)
% ROTATEPOLYGON Rotates a polygon in the plane by a given angle.
%
% The polygon is defined by vertices ordered clockwise. The rotation is
% performed around the centroid of the polygon.
%
% Input:
%   points : 2xN matrix containing the polygon vertices
%   center : 2x1 array cointainig the rotation center
%   alfa   : rotation angle in degrees
%
% Output:
%   rotatedPoints : 2xN matrix containing the rotated polygon vertices

    N = length(points);

    rotatedPoints = zeros(2,N); % Rotated vertices

    for i = 1:N

        % Translate point to centroid, rotate, and translate back
        rotatedPoints(1,i) = (points(1,i) - center(1))*cosd(alfa) ...
                           - (points(2,i) - center(2))*sind(alfa) ...
                           + center(1);

        rotatedPoints(2,i) = (points(1,i) - center(1))*sind(alfa) ...
                           + (points(2,i) - center(2))*cosd(alfa) ...
                           + center(2);

    end

end

