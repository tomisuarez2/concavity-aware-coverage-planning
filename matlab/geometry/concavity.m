function [pointType] = concavity(vertices)
% CONCAVITY Determines whether each vertex of a polygon is concave or convex.
%
% The function assumes that the polygon vertices are ordered clockwise.
% Additionally, concave vertices are classified as Type 1 or Type 2
% according to their orientation with respect to a horizontal line (+X axis).
%
% Input:
%   vertices : 2xN matrix containing the polygon vertices.
%
% Output:
%   pointType(1,:) : 1 if the vertex is concave, -1 if convex.
%   pointType(2,:) : For concave vertices:
%                       -1 -> Type 1
%                        1 -> Type 2
%                   (0 for convex vertices)

    tolerance = 1e-6; % Numerical tolerance to avoid floating-point errors
    N = length(vertices);
    pointType = zeros(2,N);

    %======================================================================
    % For each vertex, compute the cross product between adjacent edges
    % to determine whether the vertex is concave or convex.
    %======================================================================

    for i = 1 : N

        previousIndex  = circularIndex(i-1,N);
        nextIndex      = circularIndex(i+1,N);

        previousVector = vertices(:,i)         - vertices(:,previousIndex);
        nextVector     = vertices(:,nextIndex) - vertices(:,i);

        crossProduct   = cross2D(previousVector, nextVector);

        if(crossProduct > 0)

            pointType(1,i) = 1; % Concave vertex

            %==============================================================
            % Determine the concavity type using the external bisector
            % of the two adjacent edges.
            %==============================================================

            previousVector = previousVector/norm(previousVector); 
            previousVector = -previousVector; % Unit vector pointing toward previous vertex

            nextVector = nextVector/norm(nextVector); % Unit vector to next vertex

            % Approximate outward bisector direction
            bisector = (previousVector + nextVector)/norm(previousVector + nextVector);

            % Angle of the bisector with respect to +X axis in degrees (we
            % assume X axis is parallel to heading direction)
            phi = angleFromX(bisector);

            % Correct rotation angle to align the bisector with +X
            if(phi <= 90)
                phiC = -phi;
            elseif(phi <= 270)
                phiC = 180 - phi; 
            else
                phiC = 360 - phi;
            end

            % Rotate both adjacent vectors
            previousVectorRot = rot2D(phiC,previousVector);
            nextVectorRot     = rot2D(phiC,nextVector);

            % Compute angles with respect to +X axis
            thetaPrevious = angleFromX(previousVectorRot);
            thetaNext     = angleFromX(nextVectorRot);

            %==============================================================
            % Determine concavity type depending on angular ordering
            %==============================================================

            if((thetaPrevious-thetaNext) > 0)

                if(phi >= thetaNext - tolerance && phi <= thetaPrevious + tolerance)
                    pointType(2,i) = -1; % Type 1 concavity
                else
                    pointType(2,i) = 1; % Type 2 concavity
                end

            else

                if(phi >= thetaNext - tolerance || phi <= thetaPrevious + tolerance)
                    pointType(2,i) = -1; % Type 1 concavity
                else
                    pointType(2,i) = 1; % Type 2 concavity
                end

            end

        else

            pointType(1,i) = -1; % Convex vertex

        end

    end
end
