classdef spec < node
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    properties %,Hidden)
        specrule
    end
    methods
        function [obj] = spec(name,treepath,parent,children,type,specrule)    %Constructor
            obj = obj@node(name,treepath,parent,children,type);
            if nargin  == 6            
                   obj.specrule = specrule;
            elseif nargin > 6 
                disp('Error! Wrong Nr of Input Parameters for the Constructor!')                                            
            end
            if isempty(obj.specrule)
            obj.specrule = cell(1,2);
            end
        end%function        
    end
end
