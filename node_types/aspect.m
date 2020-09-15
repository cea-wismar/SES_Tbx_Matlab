classdef aspect < node
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    properties %,Hidden)
       aspectrule
       coupling
       priority = '1';
    end
    methods
        function [obj] = aspect(name,treepath,parent,children,type,aspectrule,coupling)    %Constructor 
            obj = obj@node(name,treepath,parent,children,type);
            if nargin  == 6     
                   obj.aspectrule = aspectrule;
            elseif nargin == 7
                    obj.aspectrule = aspectrule;
                    obj.coupling = coupling;
            elseif nargin > 7 
                disp('Error! Wrong Nr of Input Parameters for the Constructor!')                                            
            end
            if isempty(obj.aspectrule)
                obj.aspectrule = cell(1,2);
            end
            if isempty(obj.coupling)
                obj.coupling = cell(0,4);
            end
        end%function
    end
end
