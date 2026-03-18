function [reorderedPoints] = reorderPolygonVertices(points)
% REORDERPOLYGONVERTICES Reorders the vertices of a clockwise polygon.
%
% The function rotates the ordering of the vertices so that the first
% element in the array corresponds to the vertex immediately after the
% one with the smallest Y coordinate (and smallest X in case of ties).
%
% Input:
%   puntos : 2xN matrix containing the polygon vertices
%
% Output:
%   reorderedPoints : reordered vertices preserving the clockwise order

    % Search for the vertex with the smallest Y coordinate
    % (and smallest X in case of ties)
    ymin = points(2,1);
    xmin = points(1,1);
    N = length(points);

    indmin = 1; % Index of the minimum vertex

    for i = 1:N

        if(points(2,i) < ymin)

            ymin = points(2,i);
            xmin = points(1,i);
            indmin = i;

        elseif(points(2,i) == ymin)

            if(points(1,i) < xmin)

                ymin = points(2,i);
                xmin = points(1,i);
                indmin = i;

            end   
        end   

    end

    % Circularly shift the vertices so the sequence starts after indmin
    if(indmin ~= N) 
        reorderedPoints = [points(:,indmin+1:end), points(:,1:indmin)];
    else
        reorderedPoints = points;
    end

end

