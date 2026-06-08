function rotVector = rot2D(angleD,vector)
%ROT2D Computes the 2D rotation of a 2x1 vector.
%
%   result = ROT2D(angleD,vector) returns the rotated vector corresponding to the
%   2x2 rotation matrix from the desired angle and the 2x1 vector.
%
%   Inputs:
%       angleD : Rotation angle in degrees
%       vector : 2x1 vector
%
%   Output:
%       rotVector : 2x1 rotated vector
    rotVector = [cosd(angleD) -sind(angleD); sind(angleD) cosd(angleD)]*vector;
end

