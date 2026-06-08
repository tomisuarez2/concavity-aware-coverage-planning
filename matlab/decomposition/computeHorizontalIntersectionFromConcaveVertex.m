function [intersection] = computeHorizontalIntersectionFromConcaveVertex(vertices, i)
% COMPUTEHORIZONTALINTERSECTIONFROMCONCAVEVERTEX Computes the intersection
% between a horizontal ray originating from a concave vertex and a polygon.
%
% The function casts a horizontal line (parallel to the X-axis) from a
% concave vertex and finds valid intersection points with the polygon edges.
% Only intersections that lie within the internal angle of the vertex are
% considered. Among them, the farthest valid intersection is selected.
%
% Input:
%   vertices : 2xN matrix containing polygon vertices (clockwise order)
%   i        : index of the concave vertex
%
% Output:
%   intersection : 3x1 vector containing the selected intersection point
%   and the index of the previuos vertex where it should be in the array.

    N = length(vertices);
    yCurrent = vertices(2,i);

    % Vectors to adjacent vertices
    vPrevious  = vertices(:,circularIndex(i-1,N)) - vertices(:,i);
    vNext = vertices(:,circularIndex(i+1,N)) - vertices(:,i);

    % Angular limits of the internal vertex region
    thetaA = angleFromX(vPrevious); 
    thetaP = angleFromX(vNext);

    %==========================================================
    % Traverse polygon edges to find intersection candidates
    %==========================================================
    intersection = zeros(3,2); % Max two valid intersections
    intersection(1:2,1) = vertices(:,i); % Neutral initialization
    intersection(1:2,2) = vertices(:,i);

    iAbsolut = 1;

    for j = 1:N

        previousIndex = circularIndex(j-1,N);

        if(j ~= i && previousIndex ~= i)

            xj = vertices(1,j);
            yj = vertices(2,j);

            xi = vertices(1,previousIndex);
            yi = vertices(2,previousIndex);

            % Compute intersection with horizontal line y = yactual
            x = (yCurrent - yj) * (xj - xi)/(yj - yi) + xj;

            % Check if intersection lies within segment bounds
            if(x >= min(xj, xi) && x <= max(xj, xi) && ...
               yCurrent >= min(yj, yi) && yCurrent <= max(yj, yi))

                % Vector from vertex to intersection
                intersectionVector = [x; yCurrent] - vertices(:,i);
                theta = angleFromX(intersectionVector);

                % Check if intersection lies within internal angle
                if((thetaA - thetaP) < 0)
                    if(theta >= thetaA && theta <= thetaP)
                        intersection(1:2,iAbsolut) = [x; yCurrent];
                        intersection(3,iAbsolut) = previousIndex;
                        iAbsolut = iAbsolut + 1;
                    end
                else
                    if(theta >= thetaA || theta <= thetaP)
                        intersection(1:2,iAbsolut) = [x; yCurrent];
                        intersection(3,iAbsolut) = previousIndex;
                        iAbsolut = iAbsolut + 1;
                    end
                end
            end 
        end
    end

    %==========================================================
    % Select the farthest valid intersection
    %==========================================================
    distance = zeros(1,size(intersection,2));

    for k = 1:length(distance)
        distance(k) = norm(intersection(1:2,k) - vertices(:,i));
    end

    [~,imax] = max(distance);
    intersection = intersection(:,imax);
end

