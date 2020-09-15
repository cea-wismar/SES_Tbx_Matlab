


classdef ses < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    properties %(SetAccess = private)%,Hidden)
        parent
        nodes % containers.Map; identifiers are the treepaths
        var
        fcn
        Semantic_Conditions
        Selection_Constraints = struct('Pathes',[],'Color',[]);
        comment = 'PURPOSE OF MY SES'
    end
    methods
        function obj = ses(parent)    %Constructor
            if nargin == 1
                obj.parent = parent;
            elseif nargin == 0
                obj.parent = [];
            end
            obj.nodes = containers.Map('KeyType','char','ValueType','any');
            obj.var = cell(1,2);
            obj.Selection_Constraints.Pathes = cell(1,2);
            obj.fcn = cell(1);
            obj.fcn{1} = struct('Filename','','Path','','Data',{''});
            obj.Semantic_Conditions = cell(1);
        end%function
        %% Add Node in SES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        function addNode(obj,childNode)
            newName = obj.getName(childNode);
            parentNode = childNode.getParent;
            level = childNode.getLevel;
            [Treepath] = obj.getTreepath(childNode);  %treepath from childNode
            if level/2 == round(level/2)  %if descriptive node
                newNode = node(char(newName),Treepath,char(obj.getName(parentNode)));             %undefined type for now    
            else                             
                newNode = entity(char(newName),Treepath,char(obj.getName(parentNode)),[],'Entity');           %else entity node               
            end         
            obj.nodes(newNode.treepath) = newNode; %identifier:treepath ContainerMap
            %give parent a child except the root
            if ~parentNode.isRoot      %if parent is not the root
                [Treepath] = obj.getTreepath(parentNode);  %treepath from parent
                curNode = obj.nodes(Treepath);
                selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                levelSelNode = selNode.getLevel;
                if levelSelNode == level %add sibling Node
                    %                      curNode.children{end+1} = char(newName); %node that belongs to parent
                    Children = parentNode.children;
                    i = 0;
                    while Children.hasMoreElements
                        i = i+1;
                        nextChild = Children.nextElement;
                        ChildName = obj.getName(nextChild);
                        if strcmp(ChildName,newName)
                            break
                        end
                    end
                    oldChildren = curNode.children;
                    try
                        newChildren = [oldChildren(1:i-1),{char(newName)},oldChildren(i:end)];
                    catch
                        newChildren = [oldChildren,char(newName)]; 
                    end
                    curNode.children = newChildren;                 
                else %add sub Node
                    oldChildren = curNode.children;
                    newChildren = [{char(newName)},oldChildren];
                    curNode.children = newChildren;    
                end
            else %parent is root then delete the parent of the node
                set(newNode,'parent',[])
            end           
        end%addnode
        %% Delete Node in SES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function deleteNode(obj,node)         
            %---------------------- "ses-class": delete node object--------------------    
            nodeName = obj.getName(node);
            parentNode = node.getParent;
            [Treepath] = obj.getTreepath(node);  %treepath from node
            %--------------------------------------------------------------------------
            NrofObj = length(obj.nodes);
            ObjTreepath = keys(obj.nodes);
            n = length(Treepath);
            for i = NrofObj:-1:1
                %                ObjTreepath = obj.nodes{i}.treepath;
                rightObj = strncmp(Treepath,ObjTreepath(i),n);
                if rightObj
                    remove(obj.nodes,ObjTreepath(i));
                end
                %                
            end%for
            % -----delete child from father------------------------------------------
            if ~parentNode.isRoot   %only if parent is not the root
                [Treepath] = obj.getTreepath(parentNode);  %treepath from parent
                curNode = obj.nodes(Treepath);   
                childCount = length(curNode.children);
                for i=1:childCount
                    equalNames = strcmp(curNode.children{i},nodeName);
                    if equalNames 
                        curNode.children(i) = [];
                        break
                    end
                end
            end
        end%function
        %% Rename Node in SES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function renameNode(obj,node,futureName)
            parentNode = node.getParent;
            nodeName = obj.getName(node);
            children = node.children;
            %-----rename child from parent------------------------------------------
            if ~parentNode.isRoot   %only if parent is not the root
                [Treepath] = obj.getTreepath(parentNode);  %treepath from parent
                curNode = obj.nodes(Treepath);   
                childCount = length(curNode.children);
                for i=1:childCount
                    equalNames = strcmp(curNode.children{i},nodeName);
                    if equalNames 
                        curNode.children{i} = futureName;
                        break
                    end
                end
            end
            %-----rename parent from children------------------------------------------
            while children.hasMoreElements   %only if children exist
                nextChild = children.nextElement;
                [Treepath] = obj.getTreepath(nextChild);  %treepath from nextChild
                curNode = obj.nodes(Treepath);
                set(curNode,'parent',futureName);   
            end
            %-----rename treepath of node and children---------------------------------
            [Treepath] = obj.getTreepath(node);  %treepath from node
            curNode = obj.nodes(Treepath);
            set(curNode,'name',futureName);     %rename the selected node    
            keyWords = keys(obj.nodes);
            valueWords = values(obj.nodes);
            n = length(Treepath);                   %treepath of node
            % isPath = strncmp(keyWords,Treepath,n)     %is part of the Path!!!!!!!!!!!!!!!!!!!!!
            isPath = false(1,length(keyWords));
            for i=1:length(keyWords)
                keyTP = keyWords{i};
                if length(keyTP)==n
                    isPath(i) = (strncmp(keyTP,Treepath,n));
                elseif length(keyTP)>n
                    isPath(i) = (strncmp(keyTP,Treepath,n)) & keyTP(n+1)=='/';
                end
            end
            relVal = valueWords(isPath);
            relKey = keyWords(isPath);
            wordLength = length(nodeName);
            pathLength = length(Treepath);
            firstEnd = pathLength - wordLength;
            lastStart = pathLength + 1;
            NodeNr = length(relVal);
            for i=1:NodeNr
                path = relVal{i}.treepath;
                if strcmp(path,Treepath)
                    newPath = [path(1:firstEnd),futureName];   
                else
                    newPath = [path(1:firstEnd),futureName,path(lastStart:end)];
                end
                relVal{i}.treepath = newPath;       %change Treepath
                obj.nodes(newPath) = relVal{i};     %change Identifier
            end
            remove(obj.nodes,relKey);        %delete all old keys
        end%function
        %% Replace Node in SES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function replaceNode(obj,oldNode,newNode)
            parentNode = oldNode.getParent;
            %parentNode = oldNode.parent;
            %nodeName = obj.getName(oldNode);
            %nodeName = oldNode.name;
            nodeName = oldNode.getName;
            %newNodeName = char(newNode.name);
            newNodeName = char(newNode.getName);
            [Treepath] = obj.getTreepath(parentNode);  %treepath from parent
            %-----rename child from parent------------------------------------------
            if ~parentNode.isRoot   %only if parent is not the root
                curNode = obj.nodes(Treepath);   
                childCount = length(curNode.children);
                for i=1:childCount
                    equalNames = strcmp(curNode.children{i},nodeName);
                    if equalNames 
                        curNode.children{i} = newNodeName;
                        break
                    end
                end
            end
            allNewNodes=newNode.depthFirstEnumeration; %alle Knoten die hinzugef�gt werden m�ssen
            StartPath = [Treepath,'/',newNodeName];     %erster Pfad f�r den ersten Knoten
            %ermittle wann im pfad relevanter Teil beginnt
            [newNodeTP] = obj.getTreepath(newNode);  %treepath from newNode
            lastPathSt = length(newNodeTP) + 1; %last Path Start
            keyWords = keys(obj.nodes);
            valueWords = values(obj.nodes);
            Path = StartPath;
            while allNewNodes.hasMoreElements
                %generate a copy of the next node
                nextNode = allNewNodes.nextElement;
                [nextNodeTP] = obj.getTreepath(nextNode);
                rightNode = strcmp(keyWords,nextNodeTP);    %is part of the Path
                val = valueWords(rightNode);
                val = val{1};
                Clone = obj.copy(val);        %Kopie des vorhandenen Objektes    
                if strcmp(Clone.name, newNodeName) %Wenn clone der 1. neue knoten ist
                    newPath = Path;
                    if parentNode.isRoot %wenn der vater wurzel ist gibts keinen Vater
                        set(Clone,'parent',[]);
                    else
                        Clone.parent = char(obj.getName(parentNode));   %renaming Parent of the first added node
                        set(Clone,'parent',char(obj.getName(parentNode)));
                    end
                else
                    newPath = [Path,nextNodeTP(lastPathSt:end)];
                end
                set(Clone,'treepath',newPath);
                obj.nodes(newPath) = Clone;  
            end%while
            %remove the selected old Node
            deleteNode(obj,oldNode)
        end%function
        %% get all nodes  from root to specified path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [allNodes] = PathFromRoot2Node(obj,nodeObj)
            %get Nr Of Nodes from Root to node
            nrOfNodes = length(strfind(nodeObj.treepath,'/')) + 1;
            allNodes = cell(1,nrOfNodes);
            allNodes{end} = nodeObj;
            oldParentNode = nodeObj;
            for i=nrOfNodes-1:-1:1
                [ParentPath] = oldParentNode.getParentPath;
                newParentNode = obj.nodes(ParentPath);
                allNodes{i} = newParentNode;
                oldParentNode = newParentNode;      
            end%for
        end%function
        %% helpful - copying handle objects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [new] = copy(~,this)
            emptyVal = cell(1,5);
            new = feval(class(this),emptyVal{:});
            p = properties(this);
            baseProp = {'name','treepath','parent','children','type'};
            for i = 1:length(p)
                if ismember(p{i},baseProp)
                    new.(p{i}) = this.(p{i});
                end
            end           
            %
        end%function        
        %% helpful - get Type of Node %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [Type] = getType(obj,Node)
            try    
                [treepath] = obj.getTreepath(Node);
                nodeObj = obj.nodes(treepath);
                Type = nodeObj.type;
            catch
                Type = '';
            end
        end%function
        %% helpful - get Name of Node according to Treepath or TreeNode%%%%%%%%%%%%
        function [name] = getNameFromPath(obj,treepath)  
            try
                nodeObj = obj.nodes(treepath);
                name = nodeObj.name;
            catch
                name = '';
            end 
        end%function
        %% helpful - get Treepath of Node %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        function [treepath] = getTreepath(obj,node)
            root = node.getRoot;
            path = node.pathFromAncestorEnumeration(root);          
            treepath=[];
            while path.hasMoreElements
                nextNodeName = path.nextElement;
                treepath = [treepath,'/',char(obj.getName(nextNodeName))];              
            end 
            if isEmpty(root.getName)
                treepath = treepath(3:end);
            else
                treepath = treepath(2:end);
            end
        end%function       
        %% helpful - get the right node according to the specified Treepath %%%%%%%
        function [treenode] = getTreeNode(obj,treepath)
            lengthPath = length(treepath);
            start = 1;
            %start treenode is the SES root
            treenode = obj.parent.Hierarchy.hData.Trees.root1.getFirstChild;
            slashLocation = strfind(treepath,'/');%contains all Positions of Slashes /
            while lengthPath>0
                nodeName = char(obj.getName(treenode));
                lengthName = length(nodeName);
                slashExist = ismember('/',treepath(start:end));
                try 
                    treepart = treepath(start:start+lengthName-1);
                    nameRight = strcmp(nodeName,treepart); 
                catch
                    nameRight = false;
                end
                if slashExist %not the right level�              
                    slashRight = ismember(start+lengthName,slashLocation);
                    if nameRight && slashRight
                        treenode = treenode.getFirstChild;
                        start = start+lengthName+1;
                        lengthPath = lengthPath-lengthName-1;
                    else
                        treenode = treenode.getNextSibling;
                    end
                else %the right level
                    if nameRight && (lengthPath-lengthName==0)
                        lengthPath = lengthPath-lengthName;
                    else
                        treenode = treenode.getNextSibling;
                    end
                end
            end
        end%function
        %% helpful - get the parent Treepath of a selected Node %%%%%%%%%%%%%%%%%%%
        function [Parentpath] = getParentpathFromTreepath(~,Treepath)
            lastSlash = strfind(Treepath,'/');
            if ~isempty(lastSlash)
                lastSlash = lastSlash(end);
                Parentpath = Treepath(1:lastSlash-1);
            else
                Parentpath = [];
            end
        end%function
        %% find rootpath in nodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [rootpath] = getRootPath(obj)
            rootpath = [];
            allNodeObj = values(obj.nodes);
            for i=1:obj.nodes.Count
                nextNodeObj = allNodeObj{i};
                if isempty(nextNodeObj.parent)
                    rootpath = nextNodeObj.treepath;
                    return
                end
            end
        end%function
        %% getName - get Name of Node according to TreeNode %%%%%%%%%%%%%%%%%%%%%%%
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
        %% convert2str - convert every data format to a string %%%%%%%%%%%%%%%%%%%%
        function [string] = convert2str(~,datatype)
            if isnumeric(datatype) || islogical(datatype)
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
        
        %%
        function disp(obj)    
            disp@handle(obj)%to avoid recursion
            disp(' ')
            
            keys = obj.nodes.keys;
            fprintf(2,'SES TREE:\n')
            for k = 1:obj.nodes.Count
                Node = obj.nodes(keys{k});
                layer = sum(strfind(Node.treepath,'/')>0);
                fprintf(1,'%7s: %s %s\n',Node.type, blanks(layer*2),Node.name)
            end
        end
    end%methods
end%classdef
