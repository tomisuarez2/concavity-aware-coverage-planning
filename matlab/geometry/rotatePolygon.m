function [rotatedPoints] = rotatePolygon(points, center, alpha)
% ROTATEPOLYGON Rotates a polygon in the plane by a given angle.
%
% The polygon is defined by vertices ordered clockwise. The rotation is
% performed around the centroid of the polygon.
%
% Input:
%   points : 2xN matrix containing the polygon vertices
%   center : 2x1 array cointainig the rotation center
%   alpha   : rotation angle in degrees
%
% Output:
%   rotatedPoints : 2xN matrix containing the rotated polygon vertices

    N = length(points);

    rotatedPoints = zeros(2,N); % Rotated vertices

    for i = 1:N

        % Translate point to centroid, rotate, and translate back
        rotatedPoints(:,i) = rot2D(alpha, points(:,i) - center) + center;

    end

end

