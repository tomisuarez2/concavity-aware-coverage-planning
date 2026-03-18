function [angle] = angleFromX(vector)
% ANGLEFROMX Computes the angle of a 2D vector with respect to the +X axis.
%
% Input:
%   vector : 2D vector.
%
% Output:
%   angle  : Angle in degrees measured from the positive X-axis,
%            in the range [0, 360).

    % Compute the angle using atan2d
    angle = atan2d(vector(2), vector(1));

    % Ensure the angle lies in the range [0, 360)
    if angle < 0
        angle = angle + 360;
    end
end