function [newVertices,newIndexConcavePoint,newPointIndex] = insertVertexPreservingOrder(vertices,concavePointIndex,newVertex)
% INSERTVERTEXPRESERVINGORDER Inserts a new vertex into a polygon while
% preserving clockwise ordering and updating reference indices.
%
% If the point already exists, no insertion is performed. Otherwise, the
% point is inserted and all vertices are reordered based on their angle
% with respect to the centroid to maintain clockwise ordering.
%
% Input:
%   vertices             : 2xN matrix of polygon vertices (clockwise order)
%   concavePointIndex    : index of the reference (concave) vertex
%   newVertex            : 2x1 vector of the vertex to insert
%
% Output:
%   newVertices               : updated vertex array
%   newIndexConcavePoint      : updated index of the reference vertex
%   newPointIndex             : index of the inserted vertex

    inserted = false;

    %==============================================================
    % Check if the point already exists in the polygon
    %==============================================================
    [isInside, index] = ismember(newVertex', vertices', 'rows');

    if(isInside)
        inserted = true;
        newVertices = vertices;
        newPointIndex = index;
        newIndexConcavePoint = concavePointIndex;
    end

    %==============================================================
    % Insert point and reorder vertices (clockwise)
    %==============================================================
    if(~inserted)

        % Compute centroid
        centroid = mean(vertices, 2);

        % Compute angles of existing points
        angles = atan2(vertices(2,:) - centroid(2), ...
                        vertices(1,:) - centroid(1));

        % Compute angle of new point
        newAngle = atan2(newVertex(2) - centroid(2), ...
                            newVertex(1) - centroid(1));

        % Append new point
        extendedVertices = [vertices newVertex];
        extendedAngles = [angles newAngle];

        % Sort in descending order → clockwise orientation
        [~, sortIndices] = sort(extendedAngles, 'descend');

        newVertices = extendedVertices(:,sortIndices);

        % Update indices
        newIndexConcavePoint = find(sortIndices == concavePointIndex);
        newPointIndex = find(sortIndices == size(extendedVertices,2));
    end
end