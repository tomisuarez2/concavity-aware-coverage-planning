function [reorganizedVertices,nMax] = decomposePolygonByConcavity(vertices,sprayWidth)
% DECOMPOSEPOLYGONBYCONCAVITY Decomposes a polygon into subareas based on
% Type 2 concave vertices.
%
% The function iteratively splits the polygon at Type 2 concave vertices
% until all resulting sub-polygons are free of such vertices.
%
% Input:
%   vertices   : 2xN matrix containing the polygon vertices
%   sprayWidth : distance between coverage lines
%
% Output:
%   reorganizedVertices(1:2,:) : vertices of all subareas
%   reorganizedVertices(3,:)   : subarea index for each vertex
%   nMax                       : upper bound on trajectory points

    nMax = 1;
    
    %==============================================================
    % Compute concavity type (only Type 2 vertices are relevant)
    %==============================================================
    concavityType = concavity(vertices);
    concavityType = concavityType(2,:);
    
    %==============================================================
    % Count Type 2 concave vertices
    %==============================================================
    type2PointsNumber = 0;
    for j = 1:length(concavityType)
        if(concavityType(j) == 1)
            type2PointsNumber = type2PointsNumber + 1;
        end
    end

    % Preallocate maximum possible storage
    maxPosibleVertices = type2PointsNumber*length(vertices);
    reorganizedVertices = zeros(3,maxPosibleVertices);

    iAbsolut = 1; % Global insertion index
    theresType2 = type2PointsNumber > 0;

    if(theresType2)

        numberSubAreas = 0; % Subarea counter
        type2PointCounter = 0;
        flag = false;
        i = 1;

        %==========================================================
        % Iteratively split the polygon at Type 2 concave vertices
        %==========================================================
        while(~flag && type2PointCounter <= type2PointsNumber)

            type2PointCounter = type2PointCounter + 1;

            % Find next Type 2 vertex
            while(~(concavityType(i) == 1) && i <= length(vertices))
                i = i + 1;
            end

            % Compute intersection used to split the polygon
            intersection = computeHorizontalIntersectionFromConcaveVertex(vertices,i);

            % Insert intersection point into polygon
            [newVertices,newIndexConcavePoint,newPointIndex] = insertVertexPreservingOrder(vertices,i,intersection);

            % Split into two candidate subareas
            if(newIndexConcavePoint < newPointIndex)
                zone1 = [newVertices(:,1:newIndexConcavePoint) newVertices(:,newPointIndex:end)];
                zone2 = newVertices(:,newIndexConcavePoint:newPointIndex);
            else
                zone1 = [newVertices(:,1:newPointIndex) newVertices(:,newIndexConcavePoint:end)];
                zone2 = newVertices(:,newPointIndex:newIndexConcavePoint);
            end 

            numberPointsZone1 = size(zone1,2);
            numberPointsZone2 = size(zone2,2);

            % Check concavity of both subareas
            concavityZone1 = concavity(zone1(1:2,:));
            concavityZone2 = concavity(zone2(1:2,:));

            theresType2Zone1 = ismember(1,concavityZone1(2,:));
            theresType2Zone2 = ismember(1,concavityZone2(2,:));

            %======================================================
            % Select the subarea without Type 2 concavity
            %======================================================

            if(~theresType2Zone1 && theresType2Zone2)

                numberSubAreas = numberSubAreas + 1;
                reorganizedVertices(1:2,iAbsolut:iAbsolut+numberPointsZone1-1) = zone1;
                reorganizedVertices(3,iAbsolut:iAbsolut+numberPointsZone1-1) = numberSubAreas*ones(1,numberPointsZone1);

                iAbsolut = iAbsolut + numberPointsZone1;

                % Estimate trajectory complexity
                nMax = nMax + 2*floor((max(zone1(2,:)) - min(zone1(2,:)))/sprayWidth);

                % Continue splitting remaining area
                vertices = zone2;
                concavityType = concavityZone2(2,:);
                i = 1;

            elseif(theresType2Zone1 && ~theresType2Zone2)

                numberSubAreas = numberSubAreas + 1;
                reorganizedVertices(1:2,iAbsolut:iAbsolut+numberPointsZone2-1) = zone2;
                reorganizedVertices(3,iAbsolut:iAbsolut+numberPointsZone2-1) = numberSubAreas*ones(1,numberPointsZone2);

                iAbsolut = iAbsolut + numberPointsZone2;

                nMax = nMax + 2*floor((max(zone2(2,:)) - min(zone2(2,:)))/sprayWidth);

                vertices = zone1;
                concavityType = concavityZone1(2,:);
                i = 1;

            elseif(~theresType2Zone1 && ~theresType2Zone2)

                % Final split: both subareas are valid
                flag = true;
                numberSubAreas = numberSubAreas + 1;

                reorganizedVertices(1:2,iAbsolut:iAbsolut+numberPointsZone1-1) = zone1;
                reorganizedVertices(3,iAbsolut:iAbsolut+numberPointsZone1-1) = numberSubAreas*ones(1,numberPointsZone1);
                iAbsolut = iAbsolut + numberPointsZone1;

                reorganizedVertices(1:2,iAbsolut:iAbsolut+numberPointsZone2-1) = zone2;
                reorganizedVertices(3,iAbsolut:iAbsolut+numberPointsZone2-1) = (numberSubAreas + 1)*ones(1,numberPointsZone2);
                iAbsolut = iAbsolut + numberPointsZone2;

                nMax = nMax + 2*floor((max(zone1(2,:)) - min(zone1(2,:)))/sprayWidth);
                nMax = nMax + 2*floor((max(zone2(2,:)) - min(zone2(2,:)))/sprayWidth);

            else
                % Continue searching for a valid split
                i = i + 1; 
            end   
        end

        % Trim unused memory
        reorganizedVertices = reorganizedVertices(:,1:iAbsolut-1);

    else
        % No Type 2 concavities → no decomposition needed
        reorganizedVertices = [vertices; ones(1,length(vertices))];

        nMax = 2*floor((max(vertices(2,:)) - min(vertices(2,:)))/sprayWidth);
    end
end

