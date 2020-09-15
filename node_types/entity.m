classdef entity < node
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    properties %,Hidden)
        attributes
    end
    methods
        function [obj] = entity(name,treepath,parent,children,type,attributes)    %Constructor
            obj = obj@node(name,treepath,parent,children,type);
            if nargin  == 6            
                   obj.attributes = attributes;
            elseif nargin > 6 
                disp('Error! Wrong Nr of Input Parameters for the Constructor!')                                            
            end
            if isempty(obj.attributes)
            obj.attributes = cell(1,2);
            end
        end%function
    end
end
