function [newVertices,newIndexConcavePoint,newPointIndex] = insertVertexPreservingOrder(vertices,concavePointIndex,previousPointIndex,newVertex)
% INSERTVERTEXPRESERVINGORDER Inserts a new vertex into a polygon while
% preserving clockwise ordering and updating reference indices.
%
% If the point already exists, no insertion is performed. Otherwise, the
% point is inserted.
%
% Input:
%   vertices             : 2xN matrix of polygon vertices (clockwise order)
%   concavePointIndex    : index of the reference (concave) vertex
%   previousPointIndex   : index of the previous point
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

        N = size(vertices,2);
        if previousPointIndex < N
            newVertices = [vertices(:,1:previousPointIndex) newVertex vertices(:,previousPointIndex+1:end)];
            newPointIndex = previousPointIndex+1;
        else
            newVertices = [newVertex vertices];
            newPointIndex = 1;
        end

        if concavePointIndex < previousPointIndex
            newIndexConcavePoint = concavePointIndex;
        else
            newIndexConcavePoint = circularIndex(concavePointIndex+1,N+1);
        end
        
    end
end