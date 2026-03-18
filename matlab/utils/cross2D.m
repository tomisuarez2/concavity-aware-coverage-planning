function result = cross2D(v1, v2)
% CROSS2D Computes the 2D cross product (scalar) between two vectors.
%
%   result = CROSS2D(v1, v2) returns the scalar value corresponding to the
%   z-component of the 3D cross product between the vectors [v1 0] and [v2 0].
%
%   Inputs:
%       v1 : 2x1 or 1x2 vector
%       v2 : 2x1 or 1x2 vector
%
%   Output:
%       result : scalar equal to v1_x * v2_y - v1_y * v2_x

    result = v1(1) * v2(2) - v1(2) * v2(1);

end
