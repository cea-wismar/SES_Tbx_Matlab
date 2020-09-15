function [ cellArray ] = parallelSerialCpl( Parent, Children, type )
%parallelSerialCpl Creates Parallel or Serial Coupling according to
%input Parameter type
%   cellArray must have the form:
%   {sourcecomp1,sourceport1,sinkcomp1,sinkport1;
%    sourcecomp2,sourceport2,sinkcomp2,sinkport2;
%    ...}


switch type
    
    case 'parallel'
        cellArray = cell(length(Children)*2,4);
        for i=1:length(Children)
            cellArray(i,:) = {Parent,'in',Children{i},'in'};
            cellArray(length(Children)+i,:) = {Children{i},'out',Parent,'out'};
        end
    case 'serial'
        cellArray = cell(length(Children)+2,4);
        cellArray(1,:) = {Parent,'in',Children{1},'in'};
        cellArray(end,:) = {Children{end},'out',Parent,'out'};
        for i=1:length(Children)-1
            cellArray(i+1,:) = {Children{i},'out',Children{i+1},'in'};
        end

    otherwise
        cellArray = cell(1,4);
end

