function [reducedPoints] = reducedArea(vertices,h)
% REDUCEDAREA Computes an inward offset of a polygon by a distance h.
%
% The polygon is defined by vertices ordered clockwise. Each vertex is
% displaced along the angle bisector of its adjacent edges so that the
% resulting polygon is approximately parallel to the original edges.
%
% Input:
%   vertices : 2xN matrix containing the polygon vertices
%   h        : offset distance
%
% Output:
%   reducedPoints : 2xN matrix containing the vertices of the reduced polygon

    c = @(x, n) (1 + mod(x-1, n)); % Circular indexing
    N = length(vertices);

    C = zeros(2,N);        % Direction of the vertex displacement
    theta = zeros(1,N);    % Interior angles at each vertex

    verticesType = concavity(vertices); % Determine concave/convex vertices
    reducedPoints = zeros(2,N);

    for i = 1 : N

        previousIndex = c(i-1,N);
        nextIndex = c(i+1,N);

        % Adjacent edge vectors
        previousVector = vertices(:,previousIndex) - vertices(:,i);
        nextVector = vertices(:,nextIndex) - vertices(:,i);

        % Unit vectors along both edges
        d1 = previousVector/norm(previousVector);
        d2 = nextVector/norm(nextVector);

        % Angle bisector direction
        C(:,i) = d1 + d2;

        % Interior angle at the vertex
        theta(i) = acos(dot(d1,d2)/(norm(d1)*norm(d2)));

        % Vertex displacement along the bisector
        reducedPoints(:,i) = vertices(:,i) ...
            - verticesType(1,i) * h/sin(theta(i)/2) * (C(:,i)/norm(C(:,i)));

    end 
end

