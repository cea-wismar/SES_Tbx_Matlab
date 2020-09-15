classdef fpes < pes
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    properties
    end
    methods
        function obj = fpes(SES)
            obj = obj@pes(SES);
        end%constructor
        function flatten(obj)
            [cPES] = obj.copySES(obj); %copy of obj
            %remove all nodes from fpes
            Keys = keys(obj.nodes);
            remove(obj.nodes,Keys);
            %find leaves with equal names and change name and coupling
            [cPES] = obj.changeEqualLeaves(cPES);
            %add root to fpes nodes
            [rootpath] = cPES.getRootPath; 
            root = cPES.nodes(rootpath);
            obj.nodes(root.treepath) = root;
            %add first Decomposition
            ChildPath = root.getChildrenPath;
            if ~isempty(ChildPath)
                firstDec = cPES.nodes(ChildPath{1});
                obj.nodes(firstDec.treepath) = firstDec;
                %start recursive flattening
                obj.recFlattening(firstDec,cPES) 
                %set the right Children and Parent and treepathes
                obj.correctProperties
            end       
        end%function
        function cPES = changeEqualLeaves(~,cPES)
            allNodes = values(cPES.nodes);
            for i=1:cPES.nodes.Count
                nextNode = allNodes{i};
                %if node is leaf
                if isempty(nextNode.children)
                    %check if name exist more than one time
                    equal = 0;
                    for j=1:cPES.nodes.Count
                        compareNode = allNodes{j};
                        equal = equal + strcmp(nextNode.name,compareNode.name);
                    end
                    %if equal > 1 than rename nodes and coupling
                    if equal > 1
                        ind = 1;
                        nextNodeName = nextNode.name;
                        for j=cPES.nodes.Count:-1:1
                            compareNode = allNodes{j};
                            if strcmp(nextNodeName,compareNode.name)
                                remove(cPES.nodes,compareNode.treepath);
                                %find a name that is not key in containers.Map
                                while isKey(cPES.nodes,[compareNode.name,num2str(ind)]) %iskey() to isKey() 25.09.2015
                                    ind = ind+1;
                                end
                                compareNode.name = [compareNode.name,num2str(ind)];
                                parentPath = compareNode.getParentPath;
                                parentNode = cPES.nodes(parentPath);
                                treepath = [parentPath,'/',compareNode.name];
                                compareNode.treepath = treepath;
                                cPES.nodes(compareNode.treepath) = compareNode;
                                %change coupling
                                if strcmp(parentNode.type,'Aspect')
                                    Coupling = parentNode.coupling;
                                    firstRowName = strcmp(nextNodeName,Coupling(:,1));
                                    thirdRowName = strcmp(nextNodeName,Coupling(:,3));
                                    Coupling(firstRowName,1) = {compareNode.name};
                                    Coupling(thirdRowName,3) = {compareNode.name};
                                    parentNode.coupling = Coupling;
                                end
                                %change childrenName in Parent
                                equalChildName = strcmp(nextNodeName,parentNode.children);
                                parentNode.children(equalChildName) = {compareNode.name};
                                ind = ind+1;
                            end
                        end
                    end
                end
            end
        end%function
        function recFlattening(obj,nodeObj,PES)
            [ChildrenPath] = nodeObj.getChildrenPath;
            %if node is leaf and has no children
            if isempty(ChildrenPath)
                obj.nodes(nodeObj.treepath) = nodeObj;
            else
                %goto next Children
                for i=1:length(ChildrenPath)
                    nextChild = PES.nodes(ChildrenPath{i});
                    if strcmp(nextChild.type,'Aspect')
                        %get firstDec node
                        [rootpath] = PES.getRootPath;
                        root = PES.nodes(rootpath);
                        firstDecPath = root.getChildrenPath;
                        firstDec = obj.nodes(firstDecPath{1});
                      
                        %add coupling to firstDec
                        [ParentPath] = nextChild.getParentPath;
                        parentNode = PES.nodes(ParentPath);
                        parentName = parentNode.name;
                        Coupling = nextChild.coupling;
                        %replace father depended coupling
                        for j=1:size(Coupling,1)
                            for jj=1:size(firstDec.coupling,1)
                                if ~ismember(false,strcmp(firstDec.coupling(jj,3:4),Coupling(j,1:2))) && strcmp(Coupling(j,1),parentName)
                                    %firstDec.coupling(jj,3:4) = Coupling(j,3:4);
                                    newCoupLine = [firstDec.coupling(jj,1:2),Coupling(j,3:4)];
                                    firstDec.coupling(size(firstDec.coupling,1)+1,:) = newCoupLine;
                                end
                                if ~ismember(false,strcmp(firstDec.coupling(jj,1:2),Coupling(j,3:4))) && strcmp(Coupling(j,3),parentName)
                                    %firstDec.coupling(jj,1:2) = Coupling(j,1:2);
                                    newCoupLine = [Coupling(j,1:2),firstDec.coupling(jj,3:4)];
                                    firstDec.coupling(size(firstDec.coupling,1)+1,:) = newCoupLine;
                                end
                            end
                        end
                        %Delete all FatherCouplings
                        for jj=size(firstDec.coupling,1):-1:1
                            nxtCoup = firstDec.coupling(jj,:);
                            if ismember(parentName,{nxtCoup{1},nxtCoup{3}})                              
                                firstDec.coupling(jj,:) = [];  %delete cell row                               
                            end
                        end
                        %find coupling that depends not on father and add
                        %                         disp(' ------------------------------------- ')
                        %                         Coupling
                        isrow1Parent = strcmp(Coupling(:,1),parentName);
                        isrow3Parent = strcmp(Coupling(:,3),parentName);
                        rowNoParent = ~isrow1Parent & ~isrow3Parent;
                        addCoupling = Coupling(rowNoParent,:);
                        
                        %FIXME for addCoupling is {[] [] [] []} and not 0×4 empty cell array
%                         for kk = 1 : size(addCoupling,1)
%                             if isempty(addCoupling{kk,1})||isempty(addCoupling{kk,3})
%                                 addCoupling(kk,:)= [];
%                             end
%                         end
                        firstDec.coupling = [firstDec.coupling;addCoupling];   
                        
                    end
                    %recursive Pruning!!!
                    obj.recFlattening(nextChild,PES);
                end
            end
        end%function
        function correctProperties(obj)
            allNodes = values(obj.nodes);
            [rootpath] = obj.getRootPath;
            root = obj.nodes(rootpath);
            firstDecPath = root.getChildrenPath;
            firstDec = obj.nodes(firstDecPath{1});
            firstDec.children = {};
            firstDec.coupling(cellfun(@isempty,firstDec.coupling(:,1)),:) = [];  %delete empty cell entries
            if isempty(firstDec.coupling)
                firstDec.coupling = cell(1,4);
            end
            for i=1:obj.nodes.Count
                nodeObj = allNodes{i};
                if isempty(nodeObj.parent) || strcmp(nodeObj.parent,root.name)
                    %nevermind
                elseif isempty(nodeObj.children)
                    nodeObj.parent = firstDec.name;
                    firstDec.children = [firstDec.children,nodeObj.name];
                    oldPath = nodeObj.treepath;
                    nodeObj.treepath = [firstDec.treepath,'/',nodeObj.name];
                    remove(obj.nodes,oldPath);
                    obj.nodes(nodeObj.treepath) = nodeObj;
                end
            end
        end%function
        function [LeafNodes,Coupling,Parameters,Validity] = getResults(obj)
            LeafNodes = {};        
            Parameters = {};
            allNodes = values(obj.nodes);
            for i=1:obj.nodes.Count
                nodeObj = allNodes{i};
                if isempty(nodeObj.children)
                    LeafNodes(end+1) = {nodeObj.name};
                    Attributes = nodeObj.attributes;
                    Attributes(cellfun(@isempty,Attributes(:,1)),:) = [];  %delete empty cell entries
                    for l=1:size(Attributes,1)
                        row = cell(1,3);
                        row(1) = {nodeObj.name};
                        row(2) = Attributes(l,1);
                        row(3) = Attributes(l,2);
                        Parameters(end+1,:) = row;
                    end
                elseif strcmp(nodeObj.type,'Aspect')
                    Coupling = nodeObj.coupling;
                    Coupling(cellfun(@isempty,Coupling(:,1)),:) = [];  %delete empty cell entries
                end
            end
            Validity = obj.validity;
        end%function
    end
end
