function sidePositions = getBlockSidePositions(blocks, side)
% Returns the unique block positions for a given side of a set of blocks
%
%   Inputs:
%       blocks  Cell array of one or more blocks
%       side    Number, respesenting the following
%                   1 - Left
%                   2 - Top
%                   3 - Right
%                   4 - Bottom
%                   5 - Midpoint between results of 1 and 3
%                   6 - Midpoint between results of 2 and 4

    if side == 5
        sidePositions = [];
        for i = 1:length(blocks)
            if iscell(blocks{i})
                blocks{i} = char(blocks{i});
            end
            pos = get_param(blocks{i}, 'Position');
            midX = (pos(1) + pos(3)) / 2;
            if ~ismember(midX, sidePositions)
                sidePositions = [sidePositions, midX];
            end
        end
        
    elseif side == 6
        sidePositions = [];
        for i = 1:length(blocks)
            if iscell(blocks{i})
                blocks{i} = char(blocks{i});
            end
            pos = get_param(blocks{i}, 'Position');
            midY = (pos(2) + pos(4)) / 2;
            if ~ismember(midY, sidePositions)
                sidePositions = [sidePositions, midY];
            end
        end
        
    else
        sidePositions = [];
        for i = 1:length(blocks)
            if iscell(blocks{i})
                blocks{i} = char(blocks{i});
            end
            pos = get_param(blocks{i}, 'Position');
            if ~ismember(pos(side), sidePositions)
                sidePositions = [sidePositions , pos(side)];
            end
        end
    end
end