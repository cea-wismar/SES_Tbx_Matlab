classdef maspect < node
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    properties %,Hidden)
        aspectrule
        coupling
        interval
        numRep
        priority = '1';
    end
    methods
        function [obj] = maspect(name,treepath,parent,children,type,aspectrule,coupling,interval,numRep)    %Constructor
            obj = obj@node(name,treepath,parent,children,type);
            if nargin  == 7
                obj.aspectrule = aspectrule;
%             elseif nargin  == 7
%                 obj.aspectrule = aspectrule;
%                 obj.coupling = coupling;
            elseif nargin == 8
                obj.aspectrule = aspectrule;
                obj.coupling = coupling;
                obj.interval = interval;
            elseif nargin == 9
                obj.aspectrule = aspectrule;
                obj.coupling = coupling;
                obj.interval = interval;
                obj.numRep  = numRep;
            elseif nargin > 9
                disp('Error! Wrong Nr of Input Parameters for the Constructor!')
            end
            if isempty(obj.aspectrule)
                obj.aspectrule = cell(1,2);
            end
            if isempty(obj.coupling)
                obj.coupling = {cell(1,4)};
                %obj.coupling = cell(1);
                %obj.coupling = cellfun(@(x) cell(1,4),obj.coupling,'UniformOutput',false);
            end
            if isempty(obj.interval)
                obj.interval = uint8([1,1]);
            end
            if isempty(obj.numRep)
                obj.numRep = '';
            end
        end%function
    end
end
