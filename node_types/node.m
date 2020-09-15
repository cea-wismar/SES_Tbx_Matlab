classdef node < hgsetget %handle
    properties %,Hidden)
        name
        treepath
        parent
        children
        type
        comment = 'MY NODE COMMENT'
%         childnr  %only important after saving an SES to generate same appearance when opening the SES again
    end
    methods
        function [obj] = node(name,treepath,parent,children,type)    %Constructor    
            switch nargin
                case 0
                    %never mind
                case 1
                    obj.name        = name;
                case 2
                    obj.name        = name;
                    obj.treepath    = treepath;
                case 3
                    obj.name        = name;
                    obj.treepath    = treepath;
                    obj.parent      = parent;
                case 4
                    obj.name        = name;
                    obj.treepath    = treepath;
                    obj.parent      = parent;
                    obj.children    = children;
                case 5
                    obj.name = name;
                    obj.treepath    = treepath;
                    obj.parent      = parent;
                    obj.children    = children;
                    obj.type        = type;
                otherwise
                    %never mind
            end
            if isempty(obj.type)
                obj.type = ' ';
            end
        end%function
        function [ParentPath] = getParentPath(obj)
            lastSlash = strfind(obj.treepath,'/');
            if ~isempty(lastSlash)
                lastSlash = lastSlash(end);
                ParentPath = obj.treepath(1:lastSlash-1);
            else
                ParentPath = [];
            end
        end%function
        function [ChildrenPath] = getChildrenPath(obj)
            ChildrenPath = cell(length(obj.children),1);
            for i=1:length(obj.children)
                ChildrenPath{i} = [obj.treepath,'/',obj.children{i}];
            end          
        end%function
    end
end
