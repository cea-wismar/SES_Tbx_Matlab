classdef supportFun < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    properties
        parent
        hData
        
        Default
    end
    methods (Hidden)
        function obj = supportFun()
            obj.Default = DefSett();
        end
        
        %% addTableRow - add a Row in a specified Table %%%%%%%%%%%%%%%%%%%
        function addTableRow( ~, Table , RowData )
            TableData = get(Table,'Data');
            set(Table,'Data',[TableData;RowData]);
        end
        %% deleteTableRow - delete a Row in a specified Table %%%%%%%%%%%%%
        function deleteTableRow( ~, Table, Row )
            oldData = get(Table,'Data');
            [RowCount,ColCount] = size(oldData);
            if RowCount - size(Row,1) == 0
                newData = cell(0,ColCount);
            else
                oldData(Row,:) = [];
                newData = oldData;
            end
            set(Table,'Data',newData);
        end  
        %% nameExist - Check if Node Name allready exist and return identic nodes
        function [ Count, equalNodes ] = nameExist( obj, name, allNodes )
            try % nameExist for uitree
                Count = 0;
                equalNodes = {};
                while allNodes.hasMoreElements  %alle Knoten von Root zu Node durchlaufen
                    curNode = allNodes.nextElement;
                    equal = strcmp(name,obj.getName(curNode));
                    if equal
                        Count = Count + equal; 
                        equalNodes{end+1} = curNode;
                    end
                end
            catch % nameExist for uitable
                equalNodes = find(strcmp(name,allNodes));
                Count = sum(strcmp(name,allNodes));
            end
        end%function
        %% getName - get Name of Node according to TreeNode %%%%%%%%%%%%%%%
        %this fun is important to seperate the name from the possible html part
        function [name,htmlname] = getName(~,Node)  
            htmlname = char(Node.getName);
            if ismember('>',htmlname)
                htmlpart = strfind(htmlname,'>'); 
                htmlpart = htmlpart(end);
                name = htmlname(htmlpart+1:end);
            else
                name = htmlname;
            end
        end%function
        %% setName - set Name of Node according to TreeNode %%%%%%%%%%%%%%%
        %this fun is important to seperate the name from the possible html part
        function setName(~,Node,Name)  
            htmlname = char(Node.getName);
            if ismember('>',htmlname)
                htmlpart = strfind(htmlname,'>'); 
                htmlpart = htmlpart(end);
                newName = [htmlname(1:htmlpart),Name];
                Node.setName(newName)
            else
                Node.setName(Name)
            end
       end%function
        %% convert2str - convert every data format to a string %%%%%%%%%%%%%%%%%%%%
        function [string] = convert2str(~,datatype)
           if isnumeric(datatype)||islogical(datatype)
               if numel(datatype)<2
                    string = num2str(datatype);                                   
               else %datatype results in matrix 
                    string = mat2str(datatype);
                    string(isspace(string)) = ',';
               end       
           elseif ischar(datatype)
               string = ['''',datatype,''''];
           elseif iscell(datatype)
           %datatype results in Set
               string = '{';
               for cl = 1:length(datatype)
                    if isnumeric(datatype{cl})
                        nextVal = num2str(datatype{cl});
                    elseif ischar(datatype{cl})
                        nextVal = ['''',datatype{cl},''''];
                    end
                        string = [string,nextVal,','];   
                end
                string(end) = '}';
                else
                    error('!!! Only data of type ''numeric'', ''cell'', ''vector'' or ''char'' can be converted into char!!!') 
           end
        end%function     
       

    end
end
