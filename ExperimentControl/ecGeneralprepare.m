function [objects, couplings] = ecGeneralprepare(FPES)
%do preprocessing of FPES so moBuild can directly build
%   general function for EC

% get model data from FPES
[leafNodes, couplings, parameters, isValid] = FPES.getResults;
if ~isValid
    disp('FPES is not valid!')
    return
end
% collect each element of Da and Parameters in object
objects = struct('name', [ ], 'mb', [ ], 'parameters', [ ]);
for k=1:length(leafNodes)
    % store name
    objects(k).name = leafNodes{k};
    fieldTemp={ };
    contentTemp={ };
    for l = 1:size(parameters,1)
        if strcmp(parameters{l,1},leafNodes{k})
            switch parameters{l,2}
                % store type
                case 'mb'
                    objects(k).mb = eval(parameters{l,3});
                    % store parameters
                otherwise
                    fieldTemp(end+1) = parameters(l,2);
                    val = parameters(l,3);
                    % strip extra ''
                    if val{1}(1) == ''''
                        val{1} = val{1}(2:end-1);
                    end
                    contentTemp(end+1) = val;
            end
        end
    end
    objects(k).parameters = cell2struct(contentTemp,fieldTemp,2);
end

% remove NONE elements from list; C.D. 23.09.2020
valid_objects= struct('name','','mb','','parameters',''); % create the structure to allow concatening
for k = 1 : length(objects)
    object_name = objects(k).name;
    if length(object_name) >=4
        if ~strcmp(object_name(1:4), 'NONE')                  % just add valid objects
            valid_objects = [valid_objects,objects(k)];
        end
    else
        valid_objects = [valid_objects,objects(k)];
    end
end

objects=valid_objects(2:end);                             % remove the first dummy entry
%%%%%%%%%%%%%% end remove NONE elements from list
end