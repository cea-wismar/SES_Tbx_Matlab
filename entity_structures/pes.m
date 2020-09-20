 classdef pes < ses
    %pes derive a PES from an SES
    %   Detailed explanation goes here
    properties
        varvalues        
        EvalSESVars
        Ses
        sesVars 
        validity   
    end
    
    
    methods
        function obj = pes(SES)
            obj = obj@ses([]);
            [obj.Ses] = obj.copySES(SES);
            obj.Ses.var(cellfun(@isempty,obj.Ses.var(:,1)),:) = [];  %delete empty cell entries
            %copy some relevant information from ses to pes
            obj.var = obj.Ses.var;
            if isempty(obj.var)
                obj.var = cell(1,2);
            end
            obj.fcn = obj.Ses.fcn;
            clear SES
        end%constructor
        
        %%
        function firstLevelPrune(obj,VarValues)
            SES = obj.copySES(obj.Ses);
            % Verify SES Variables
            %check if nr of values equals nr of variables
            if size(SES.var,1)~=length(VarValues)
                warning('Number of inserted SES Variables do not fit the specified SES Variables in the SES')
            end
            % save current SES Variables configuration modified by A. S. 09/08/2017 
            obj.sesVars = {};
            for i = 1:length(VarValues)
                obj.sesVars(end+1,:) = VarValues{i};
            end
            %sort inserted Variables
            obj.varvalues = cell(1,length(VarValues));
            for l=1:length(VarValues)
                nextVar = VarValues{l};
                ind = strcmp(nextVar{1},obj.var(:,1));
                if sum(ind)==0
                    error(['The ',num2str(l),'. inserted SES Variable name does not fit to the SES Variables, that are specified in the SES.'])
                elseif sum(ind)>1
                    error('Some equal Variable names exist.')    
                else
                    obj.varvalues{ind} = nextVar{2};
                    str = obj.convert2str(nextVar{2});
                    obj.var{ind,2} = str;
                end
            end          
            % create imported SES Functions
            obj.insertSESFunctions
            
            % execute Functions in SES Variables
            obj.evalFunInSESVars;
            
            % create executable string of SESVars
            obj.sesVars2EvalStr;
            
            % replace Selection Constraints with the connected Selection Rule
            SES = obj.evalSelectionConstraints(SES);
            
            % check Semantic Conditions
            obj.checkSemanticRels
            
            % Recursive Pruning
            % start the recursive pruning of the SESTree with rootEntity
            RootEntity = SES.nodes(SES.getRootPath);
            obj.recursivePrune(RootEntity,SES);
            
            % change SES Treepathes to PES treepathes
            rootpath = obj.getRootPath;
            rootNode = obj.nodes(rootpath);
            obj.PathesfromSES2PES(rootNode,[],SES)%rootNode.parent = [];
                        
            clear SES           
        end%function
        
        %%
        function pruneEasyAPI(obj,varargin)
            prune(obj,{varargin{:}})
        end
        %%
        function firstLevelPruneEasyAPI(obj,varargin)
            firstLevelPrune(obj,{varargin{:}})
        end
        %%
        function prune(obj,VarValues) 
            SES = obj.copySES(obj.Ses);  
            %disp(SES.nodes)
            %disp(SES.nodes.keys)
            %disp(SES.nodes.values)
            % Verify SES Variables
            % check if nr of values equals nr of variables
            if size(SES.var,1)~=length(VarValues)
                warning('Number of inserted SES Variables does not fit the specified SES Variables in the SES')
            end
            % save current SES Variables configuration modified by A. S. 09/08/2017 
            obj.sesVars = {};
            for i = 1:length(VarValues)
                obj.sesVars(end+1,:) = VarValues{i};
            end
            
            %sort inserted Variables
            obj.varvalues = cell(1,length(VarValues));
            for l=1:length(VarValues)
                nextVar = VarValues{l};
                ind = strcmp(nextVar{1},obj.var(:,1));
                if sum(ind)==0
                    error(['The ',num2str(l),'. inserted SES Variable name does not fit to the SES Variables, that are specified in the SES.'])
                elseif sum(ind)>1
                    error('Some equal Variable(s) names exist.')    
                else
                    obj.varvalues{ind} = nextVar{2};
                    str = obj.convert2str(nextVar{2});
                    obj.var{ind,2} = str;
                end
            end
            % create imported SES Functions
            obj.insertSESFunctions 
            
            % execute Functions in SES Variables
            obj.evalFunInSESVars;
            
            % create executable string of SESVars
            obj.sesVars2EvalStr;
            
            % replace Selection Constraints with the connected Selection Rule
            SES = obj.evalSelectionConstraints(SES);
 
            % check Semantic Conditions
            obj.checkSemanticRels
            
            % Recursive Pruning
            % start the recursive pruning of the SESTree with rootEntity
            RootEntity = SES.nodes(SES.getRootPath);            
            obj.recursivePrune(RootEntity,SES);
            
            % change SES Treepathes to PES Treepathes (7)
            rootpath = obj.getRootPath;
            rootNode = obj.nodes(rootpath);
            obj.PathesfromSES2PES(rootNode,[],SES)%rootNode.parent = [];
            
            %Second Recursive Pruning
            % get the Pes after one Recursive Pruning (copied)
            newSES = obj.getPesBeforeFinalState;
 
            % execute Functions and SES Variables in Priorities
            newSES = obj.evalFunVarsInPrio(newSES);
            
            % evaluate Priorities and generate new Selection Rules
            newSES = obj.evalGlobalPriorities(newSES);
            
            %clear all old pes nodes from first pruning
            obj.nodes = containers.Map('KeyType','char','ValueType','any');
            
            % Recursive Pruning (Second time)
            RootEntity = newSES.nodes(newSES.getRootPath);
            obj.recursivePrune(RootEntity,newSES); 

            % change SES Treepathes to PES Treepathes again (7)
            rootpath = obj.getRootPath;
            rootNode = obj.nodes(rootpath);
            obj.PathesfromSES2PES(rootNode,[],newSES)%rootNode.parent = [];
           
            %Third recursive pruning
            % get the Pes after second Recursive Pruning (copied)
            newSES2 = obj.getPesBeforeFinalState;
            
            %clear all old pes nodes from second pruning
            obj.nodes = containers.Map('KeyType','char','ValueType','any');
            
            % Recursive Pruning (Third time)
            RootEntity = newSES2.nodes(newSES2.getRootPath);
            obj.recursivePrune(RootEntity,newSES2); 

            % change SES Treepathes to PES Treepathes again (7)
            rootpath = obj.getRootPath;
            rootNode = obj.nodes(rootpath);
            obj.PathesfromSES2PES(rootNode,[],newSES2)%rootNode.parent = [];
            
            clear SES
        end%pruning
        
        %%
        function checkSemanticRels(obj)
            Sem_Rel = obj.Ses.Semantic_Conditions;
            Sem_Rel(cellfun(@isempty,Sem_Rel(:,1)),:) = [];  %delete empty cell entries
            obj.validity = true;
            if ~isempty(Sem_Rel)
                eval(obj.EvalSESVars)
                for i=1:length(Sem_Rel)
                    nextSem_Rel = Sem_Rel{i};
                    evalCond = eval(nextSem_Rel);
                    if ~evalCond
                        obj.validity = false;
                        break
                    end
                end
            end
        end%function
        function [SES] = evalSelectionConstraints(obj,SES)
            %get for every Node real rule that is linked by Selection Constraints
            %get all ses variables into workspace
            eval(obj.EvalSESVars)
            Sel_Con = SES.Selection_Constraints.Pathes;
            Sel_Con(cellfun(@isempty,Sel_Con(:,1)),:) = [];  %delete empty cell entries
            for i=1:size(Sel_Con,1)
                %get all the nodes, whose rule shall be set by sourcerule
                sinkPathes = Sel_Con{i,2};
                sinkNodes = cellfun(@(x) SES.nodes(x),sinkPathes,'UniformOutput',false);                
                %get rule and name that shall be replaced in the rule by
                %sink name
                sourcePath = Sel_Con{i,1};
                sourceNode = SES.nodes(sourcePath);
                if strcmp(sourceNode.type,'Spec')
                    sourcePath = sourceNode.getParentPath;
                    sourceNode = SES.nodes(sourcePath);
                end
                %                 sourceName = sourceNode.name;
                [allNodes] = SES.PathFromRoot2Node(sourceNode);
                %add all rules that leads to the sourceNode
                SourceRule = true;
                for ii=1:length(allNodes)
                    nextNode = allNodes{ii};
                    switch nextNode.type
                        case 'Spec'
                        Selections = nextNode.specrule(:,1);
                        Selections(cellfun(@isempty,Selections),:) = [];  %delete empty cell entries
                        %darauf achten dass Entity immer Blatt ist, sonst kein Pruning m�glich
                        if ii+1>length(allNodes)
                            error('Descriptive nodes must not be leaf nodes!')
                        end
                        rightRow = strcmp(allNodes{ii+1}.name,Selections);
                        if sum(rightRow) == 1
                            cond = nextNode.specrule{rightRow,2};
                            evalCond = eval(cond);                            
                            SourceRule = SourceRule & evalCond;
                        elseif sum(rightRow) == 0
                            SourceRule = false;
                        end
                        case {'Aspect','MAspect'}
                        %                             if ii+1>length(allNodes)
                        %                                 error('Descriptive nodes must not be leaf nodes!')
                        %                             end
                        %check if node is a descission node
                        [ParentPath] = nextNode.getParentPath;
                        [SiblingPath] = SES.nodes(ParentPath).getChildrenPath;
                        AspCount = 0;
                        for kk=1:length(SiblingPath)
                            nodeType = SES.nodes(SiblingPath{kk}).type;
                            if strcmp(nodeType,'Aspect') || strcmp(nodeType,'MAspect')
                                AspCount = AspCount + 1;
                            end
                        end
                        if AspCount > 1
                            Selections = nextNode.aspectrule(:,1);
                            Selections(cellfun(@isempty,Selections),:) = [];  %delete empty cell entries
                            rightRow = strcmp(nextNode.name,Selections);
                            if sum(rightRow) == 1
                                cond = nextNode.aspectrule{rightRow,2};
                                evalCond = eval(cond);                                
                                SourceRule = SourceRule & evalCond;
                            elseif sum(rightRow) == 0
                                SourceRule = false;
                            end
                        end
                    end 
                end
                %add SourceRule to all sink nodes
                for ii=1:length(sinkNodes)
                    nextNode = sinkNodes{ii};
                    selection = nextNode.name;
                    if SourceRule
                        condition = 'true';
                    else
                        condition = 'false';
                    end
                    switch nextNode.type
                        case 'Entity'
                        parentpath = nextNode.getParentPath;
                        parentnode = SES.nodes(parentpath);
                        Specrule = parentnode.specrule;
                        Specrule(cellfun(@isempty,Specrule(:,1)),:) = [];  %delete empty cell entries
                        parentnode.specrule = [Specrule;{selection,condition}];
                        case {'Aspect','MAspect'}
                        parentpath = nextNode.getParentPath;
                        parentnode = SES.nodes(parentpath);
                        childrenpath = parentnode.getChildrenPath;
                        %give all AspSibling the Sourcerule
                        for kk=1:length(childrenpath)
                            aspSibNode = SES.nodes(childrenpath{kk});
                            if ismember(aspSibNode.type,{'Aspect','MAspect'})
                                Aspectrule = aspSibNode.aspectrule;
                                Aspectrule(cellfun(@isempty,Aspectrule(:,1)),:) = [];  %delete empty cell entries
                                aspSibNode.aspectrule = [Aspectrule;{selection,condition}];
                            end
                        end
                    end
                end
            end
        end%function
        
        %%
        function insertSESFunctions(obj)
            %check if SES Functions already existin current folder. if not, create them    
            fun = obj.fcn;
                  
                
            while exist('+SES_Functions','dir')==7 %explicite using while here!!
                rmdir('+SES_Functions','s')%delete Folder 
            end
            try
                mkdir('+SES_Functions')
            catch
            end
            
            oldFolder = cd('+SES_Functions');
            
            for i=1:length(fun)
                if ~isempty(fun{i}.Filename)
                    if exist(fun{i}.Filename,'file') == 0 %no m-function exist with the specified name
                        %so create function     
                        
                        fileID = fopen(fun{i}.Filename,'w');
                        fprintf(fileID,'%s',fun{i}.Data{:});
                        fclose(fileID);
                        %this is importent, because function needs a bit
                        %time for creation; after fun is created, continue
                        while exist(fun{i}.Filename,'file')~=2
                            drawnow,pause(0.1)
                        end
                    end
                end
            end            
            cd(oldFolder)            
        end%function
        
        %%
        function entNode = evalFunInAtt(obj,entNode)
            % This method evaluates SESFunctions in node attributes
            % (only for type entity!!!)
            %get all ses variables into workspace
            
            import SES_Functions.*
            
            eval(obj.EvalSESVars)
            % get the attribute structure from nodeObj
            Attributes = entNode.attributes;
            for i=1:size(Attributes,1)
                nextValue = Attributes{i,2};
                %delete empty spaces in nextValue
                try %BUGFIX
                    nextValue = strtrim(nextValue);%remove tailing leading ws  
                catch 
                    %nextValue can be [], so strtrim fails
                end

                % Empty Value----------------------------------------------
                if isempty(nextValue)
                    %never mind deblank(chr)
                    %MultiOutputFunction ---------------------------------------
                elseif nextValue(1) == '#'
                    evalAttValue = eval(nextValue(2:end));
                    if ~iscell(evalAttValue)
                        error('Output of MultiOutputFun must be a cell array!')
                    end
                    %anonym.Fun results in Set
                    cellstring = '#{';
                    for cl = 1:length(evalAttValue)
                        if isnumeric(evalAttValue{cl})
                            nextVal = num2str(evalAttValue{cl});
                        elseif ischar(evalAttValue{cl})
                            nextVal = ['''',evalAttValue{cl},''''];
                        end
                        cellstring = [cellstring,nextVal,','];   
                    end
                    cellstring(end) = '}';
                    entNode.attributes{i,2} = cellstring;
                    % Set -----------------------------------------------------    
                    % check: is the field value a cell-array?
                else
                    evalnxtVal = eval(nextValue);
                    [str] = obj.convert2str(evalnxtVal); 
                    entNode.attributes{i,2} = str;                    
                end
            end
        end%function
        
        %%
        function [aspNode] = evalFunInCoup(obj,aspNode)
            % This method evaluates SESFunctions in node coupling
            % (only for type (m)aspect!!!)
            
            import SES_Functions.*
            
            %get all ses variables into workspace
            eval(obj.EvalSESVars)
            %replace Childern and Parent argument by real Children/Parent
            
            childCh = sprintf('{%s',sprintf('''%s'',',aspNode.children{:}));
            childCh(end) = '}';
                      
            str = aspNode.coupling;
            newStr = strrep(str,'Children',childCh);
            newStr = strrep(newStr,'Parent',['''',aspNode.parent,'''']);
            
            Coupling = eval(newStr);
            %save results 
            aspNode.coupling = Coupling;
        end%function
        
        %%
        function [SES] = evalFunVarsInPrio(obj,SES)
            % This method evaluates SESFunctions and Variables inPriorities
            % (only for type aspect and maspect!!!)
            %get all ses variables into workspace
            
            import SES_Functions.*
            
            eval(obj.EvalSESVars)
            allNodeObj = values(SES.nodes);
            for i=1:length(allNodeObj)
                nextNodeObj = allNodeObj{i};
                if ismember(nextNodeObj.type,{'Aspect','MAspect'})
                    Priority = eval(nextNodeObj.priority);
                    % check: is the field value a cell-array?
                    if iscell(Priority)||ischar(Priority)
                        error('Only integer numbers are allowed for Priority Input!')
                    else %numeric or variable input
                        evalPriority = Priority;
                    end
                    nextNodeObj.priority = num2str(evalPriority);
                end      
            end
        end%function
        
        %%
        function [maspNode] = evalFunInNumRep(obj,maspNode)
            % This method evaluates SESFunctions in node numrep
            % (only for type (m)aspect!!!)
            %get all ses variables into workspace
            
            import SES_Functions.*
            
            eval(obj.EvalSESVars)
            evalNumRep = eval(maspNode.numRep);
            if ~(iscell(evalNumRep)||ischar(evalNumRep))
                maspNode.numRep = num2str(evalNumRep);
            else
                error('Only integer numbers are allowed for Numrep Input!')
            end
        end%function
        
        %%
        function evalFunInSESVars(obj)
            % This method evaluates SESFunctions in SESVars
            % (only for SESVars!!!)
            % get SESVars from obj
            % sesvars = obj.varvalues;
            
            import SES_Functions.*
            
            sesVars = obj.var;   
            sesVars(cellfun(@isempty,sesVars(:,1)),:) = [];  %delete empty cell entries
            varValues = cell(1,size(sesVars,1)); 
            NrOfVars = length(varValues);
            %prepare cellarray where executed vars will be saved
            evalsesvars = cell(NrOfVars,1);
            loop = 0;
            flag = true;
            while flag && loop<=NrOfVars
                loop = loop + 1;
                flag = false;
                % check each SESVars for SESFunctions
                for i=1:NrOfVars
                    %check if variable is not yet evaluated
                    if isempty(evalsesvars{i})
                        try
                            evalsesvars{i} = eval(sesVars{i,2});
                            [str] = obj.convert2str(evalsesvars{i});
                            str = [sesVars{i,1},' = ',str,'; '];
                            eval(str)
                        catch %some input parameters are not defined yet, so try in next loop
                            evalsesvars{i} = [];
                            flag = true; %another while loop is needed
                        end              
                    end
                end
            end%while
            if loop>NrOfVars && NrOfVars>0
                error('Value assignment for SES variables fails.')
            end       
            % update SESVars 
            obj.varvalues = evalsesvars;           
        end%function
        
        %%
        function sesVars2EvalStr(obj)
            % This method creates a executable string with SESVars (using
            % eval)
            evalSESVars ='';
            values = obj.varvalues;
            varnames = obj.var(:,1);
            varnames(cellfun(@isempty,varnames)) = [];  %delete empty cell entries
            for i=1:length(varnames)
                str = obj.convert2str(values{i});
                str = [varnames{i},' = ',str,'; '];
                evalSESVars = [evalSESVars,str];  %#ok<*AGROW>
            end            
            obj.EvalSESVars = evalSESVars;
        end%function
        
        %%
        function setRightCoupling(obj)
            allPnodes = values(obj.nodes);
            for i=1:length(allPnodes)
                nextPnode = allPnodes{i};
                if strcmp(nextPnode.type,'Aspect')
                    Coupling = nextPnode.coupling;
                    father = nextPnode.parent;
                    childrenName = nextPnode.children;
                    rightNames = [childrenName,father];
                    %find a name in coupling that doesnt belog to the
                    %acceptable nodes -> than replace it by new father
                    %name, because this is the old father name
                    row1 = ~ismember(Coupling(:,1),rightNames);
                    row3 = ~ismember(Coupling(:,3),rightNames);
                    Coupling(row1,1) = {father};
                    Coupling(row3,3) = {father};
                    nextPnode.coupling = Coupling;
                end
            end
        end%function
        
        %%
        function PathesfromSES2PES(obj,nodeObj,parentPath,SES)
            SESpath = nodeObj.treepath;
            %change path only if it is a key
            if isKey(obj.nodes,SESpath)
                PESpath = [parentPath,nodeObj.name];
            else
                PESpath = parentPath(1:end-1);
            end
            %if node has children
            if ~isempty(nodeObj.children)
                SESnodeObj = SES.nodes(SESpath);
                for i=1:length(SESnodeObj.children)
                    nextChildName = SESnodeObj.children{i};
                    nextChildPath = [SESpath,'/',nextChildName]; %SESpath
                    if isKey(obj.nodes,nextChildPath)
                        nextChildNode = obj.nodes(nextChildPath);
                    else
                        %disp(nextChildPath);
                        %disp(SES.nodes(nextChildPath));
                        nextChildNode = SES.nodes(nextChildPath);   
                    end
                    %RECURSIVE CALL
                    parentPath = [PESpath,'/'];
                    obj.PathesfromSES2PES(nextChildNode,parentPath,SES)
                end
            end
            if isKey(obj.nodes,SESpath)
                %if PES path is different from SES path
                if ~strcmp(SESpath,PESpath)
                    nodeObj.treepath = PESpath;
                    obj.nodes(nodeObj.treepath) = nodeObj;
                    remove(obj.nodes,SESpath);
                end
            end
        end%function
        
        %%
        function createMultChildren(obj,nodeObj,SES,chlst)
            % execute all SESVars using eval
            %disp(nodeObj);
            eval(obj.EvalSESVars);     
            ChildrenPath = nodeObj.getChildrenPath;
            ChildrenPath = ChildrenPath{:};
            childNode = SES.nodes(ChildrenPath);
            % eval all SESFunctions in Attributes of a entity
            [childNode] = obj.evalFunInAtt(childNode);
            %             if iscell(eval(nodeObj.numRep))
            %                % eval SESFunctions in NumRep of an maspect
            [nodeObj] = obj.evalFunInNumRep(nodeObj);
            %             end
            if isnumeric(eval(nodeObj.numRep))
                if length(eval(nodeObj.numRep))==1
                    if eval(nodeObj.numRep)>0 && uint16(eval(nodeObj.numRep)) == eval(nodeObj.numRep)
                        %everything ok
                        Err = false;
                    else
                        Err = true;
                    end
                else
                    Err = true;
                end
            else
                Err = true;
            end
            if Err 
                error(['Numrep Value of MultiAspect ',nodeObj.name,' must be integer greater than 0!'])
            end
            %get childrens (entity) of the currentNode (multiaspect)
            childbasename = childNode.name; 
            newChildren = cell(1,eval(nodeObj.numRep));
            for i = 1:eval(nodeObj.numRep)
                % create new node (entity)
                name = [childbasename,'_',num2str(i)];
                treepath = [childNode.treepath,'_',num2str(i)];
                parent = childNode.parent;
                % get also children C.D. 17.09.19
                children = childNode.children;
                % END get also children C.D. 17.09.19
                attributes = childNode.attributes;
                attributes(cellfun(@isempty,attributes(:,1)),:) = [];  %delete empty cell entries
                %modify attributes for each created child------------------
                for kk = 1:size(attributes,1)
                    nextAttVal = attributes{kk,2};
                    if nextAttVal(1) == '#'
                        Set = eval(nextAttVal(2:end));
                        if i>length(Set)
                            attributes{kk,2} = [];
                            warning(['A MultiOutputSet in Attributes of ',nodeObj.name,'''s children contains to less elements!'])
                        else   
                            value = Set{i};
                            if isnumeric(value)
                                if numel(value) <2
                                    attributes{kk,2} = num2str(Set{i});
                                    %anonym.Fun results in matrix  
                                else
                                    attributes{kk,2} = mat2str(Set{i});
                                    attributes{kk,2}(isspace(attributes{kk,2})) = ',';
                                end
                            elseif ischar(value)
                                attributes{kk,2} = ['''',value,''''];
                            end
                        end    
                    end
                end%for
                %----------------------------------------------------------
                %newNode = entity(name,treepath,parent,[],childNode.type,attributes); 
                newNode = entity(name,treepath,parent,children,childNode.type,attributes);
                %disp(newNode);
                
                % update NodesContainersMap of obj
                obj.nodes(newNode.treepath) = newNode; 
                newChildren{i} = name;
                
                % add the subtree  
                for j=1:numel(chlst)
                    %oldtreepath = chlst{j}.treepath;
                    chlst{j}.treepath = strrep(chlst{j}.treepath,['/',childbasename,'/'],['/',name,'/']);   %adapt the treepath to the new name
                    chlst{j}.parent = strrep(chlst{j}.parent,childbasename,name);       %adapt the parent to the new name
                    %copy node -> create empty class of node, copy the properties
                    copyNde = feval(class(chlst{j}),[],[],[],[],[]);
                    pnode = properties(chlst{j});
                    for jj = 1:length(pnode)
                        copyNde.(pnode{jj}) = chlst{j}.(pnode{jj}); 
                    end
                    obj.nodes(chlst{j}.treepath) = copyNde;
                    %node is copied in obj
                    chlst{j}.treepath = strrep(chlst{j}.treepath,['/',name,'/'],['/',childbasename,'/']);   %change back in the list
                    chlst{j}.parent = strrep(chlst{j}.parent,name,childbasename);       %change back in the list
                end
                
                %a = values(obj.nodes); %View the nodes in debugger
                
                % AND add new nodes to NodesContainersMap of original SES.... 19.07.2019
                SES.nodes(newNode.treepath) = newNode;
                
                % add the subtree
                for j=1:numel(chlst)
                    chlst{j}.treepath = strrep(chlst{j}.treepath,['/',childbasename,'/'],['/',name,'/']);   %adapt the treepath to the new name
                    chlst{j}.parent = strrep(chlst{j}.parent,childbasename,name);       %adapt the parent to the new name
                    %copy node -> create empty class of node, copy the properties
                    copyNde = feval(class(chlst{j}),[],[],[],[],[]);
                    pnode = properties(chlst{j});
                    for jj = 1:length(pnode)
                        copyNde.(pnode{jj}) = chlst{j}.(pnode{jj}); 
                    end
                    SES.nodes(chlst{j}.treepath) = copyNde;
                    %node is copied in SES
                    chlst{j}.treepath = strrep(chlst{j}.treepath,['/',name,'/'],['/',childbasename,'/']);   %change back in the list
                    chlst{j}.parent = strrep(chlst{j}.parent,name,childbasename);       %change back in the list
                end    
                
                %a = values(obj.nodes); %View the nodes in debugger
  
            end 
            % AND to the original SES....19.07.2019
            nodeObj.children = newChildren;
            
            %a = values(obj.nodes);  %Test which nodes are in obj

            %disp('obj after adding new nodes')
            %disp(obj)
            %disp('SES after adding new nodes')
            %disp(SES)
            %disp('nodeObj after adding new nodes')
            %disp(nodeObj)

        end%function
        
        %% collect children of the node CP recursively and place in chlst
        function chlst = recursiveChildrenCollect(obj,nodeObj,chlst,SES)
            CP = nodeObj.getChildrenPath;
            if ~isempty(CP)
                numCP = numel(CP);
                for i = 1:numCP
                    CPA = CP{i};
                    childN = SES.nodes(CPA);
                    chlst{end+1} = childN;
                    chlst = recursiveChildrenCollect(obj,childN,chlst,SES);
                end
            end
        end%function
        
        %%
        function recursivePrune(obj,nodeObj,SES)           
            %% Top-Down Recursion
            %get all ses variables into workspace
            eval(obj.EvalSESVars)
            switch nodeObj.type
                case 'Entity'                    
                % evaluate Functions in attributes-------------------------
                Attributes = nodeObj.attributes;
                Attributes(cellfun(@isempty,Attributes(:,1)),:) = [];  %delete empty cell entries
                % check: nodeObj has any attributes?
                if ~isempty(Attributes)
                    % eval all SESFunctions in Attributes of a entity
                    [nodeObj] = obj.evalFunInAtt(nodeObj); 
                end
                % add node to PES------------------------------------------
                newNode = obj.copy(nodeObj);
                newNode.attributes = nodeObj.attributes;
                obj.nodes(newNode.treepath) = newNode;
                %if node has children-> get next child of node
                [ChildrenPath] = nodeObj.getChildrenPath;
                for i=1:length(nodeObj.children)
                    nextChildPath = ChildrenPath{i};
                    try
                        nextnodeObj = SES.nodes(nextChildPath);
                        % REKURSIVE FUNCTION CALL!!!!!
                        obj.recursivePrune(nextnodeObj,SES); %transfer child and repeat algorithm
                    catch
                    end
                end                
                case 'Spec'
                Specrule = nodeObj.specrule;
                Specrule(cellfun(@isempty,Specrule(:,1)),:) = [];  %delete empty cell entries
                %check: only one condition is true?-------------------
                %if not -> errormessage
                %else -> evaluate Functions in specrule
                nrOfWays = zeros(1,size(Specrule,1));
                for ii=1:size(Specrule,1)
                    nextCond = Specrule{ii,2};
                    evalCond = eval(nextCond);
                    if evalCond
                        nrOfWays(ii) = true;
                    end
                end
                if sum(nrOfWays)>1
                    trues = find(nrOfWays==true);
                    error(['More than one possible alternative in a decision is not allowed \n',...
                    'Error in Node: ',nodeObj.name,'\n',...
                    'Treepath: ',nodeObj.treepath,'\n',...
                    'Wrong Rule Cases',trues])
                end      
                %get selected child of node (by evaluating the conditions)
                for i=1:size(Specrule,1)
                    nextCond = Specrule{i,2};
                    evalCond = eval(nextCond);
                    if evalCond
                        nextChildPath = [nodeObj.treepath,'/',Specrule{i,1}];
                        nextnodeObj = SES.nodes(nextChildPath);
                        % REKURSIVE FUNCTION CALL!!!!!
                        obj.recursivePrune(nextnodeObj,SES);  %transfer child and repeat algorithm
                    end
                end
                case {'Aspect','MAspect'}
                %check: node is decision node?---------------------------
                %find AspectNodes and MAspectNodes in Siblings
                ParentPath = nodeObj.getParentPath;
                ParentNode = SES.nodes(ParentPath);
                ChildrenPath = ParentNode.getChildrenPath;
                AspCount = 0;
                for jj=1:length(ChildrenPath)
                    Sibling = SES.nodes(ChildrenPath{jj});
                    if strcmp(Sibling.type,'Aspect') || strcmp(Sibling.type,'MAspect')
                        AspCount = AspCount+1;
                    end
                end
                %Yes: node is a decision node----------------------------
                if AspCount~=1
                    %Have the nodes been brothers in the SES? -> Get by
                    %prority deleted aspectrules back (deleted in function
                    %evalGlobalPriorities)
                    sesNodes = values(obj.Ses.nodes);   %nodes of the original SES
                    for kk=1:length(sesNodes)
                        if strcmp(sesNodes{kk}.type, nodeObj.type) && strcmp(sesNodes{kk}.name, nodeObj.name) ...
                                && strcmp(sesNodes{kk}.priority, nodeObj.priority) && strcmp(sesNodes{kk}.comment, nodeObj.comment) %find node in SES
                            %now look whether the node sesNodes{kk} had a
                            %sibling of the same type in the SES -> the same
                            %type, parent, and treepath except last part
                            hasSiblingInSES = 0;
                            for ll=1:length(sesNodes)
                                if strcmp(sesNodes{ll}.type, sesNodes{kk}.type) && strcmp(sesNodes{ll}.parent, sesNodes{kk}.parent) && kk ~= ll %not the same node
                                    lp = sesNodes{ll}.treepath;
                                    lastslash_pos = find(lp == '/', 1, 'last');
                                    lp = lp(1 : lastslash_pos - 1);
                                    kp = sesNodes{ll}.treepath;
                                    lastslash_pos = find(kp == '/', 1, 'last');
                                    kp = kp(1 : lastslash_pos - 1);
                                    if strcmp(lp, kp)
                                        hasSiblingInSES = 1;
                                    end
                                end
                            end
                            if hasSiblingInSES == 1
                                nodeObj.aspectrule = sesNodes{kk}.aspectrule;
                            end                       
                        end
                    end
                    
                    %check: only one condition is true?--------------------
                    %if not->errormessage 
                    %else -> evaluate Functions in aspectrule
                    Aspectrule = nodeObj.aspectrule;
                    Aspectrule(cellfun(@isempty,Aspectrule(:,1)),:) = [];  %delete empty cell entries 
                    %first check if there are more than one possible ways 
                    %if so -> errormessage
                    nrOfWays = zeros(1,size(Aspectrule,1));
                    for ii=1:size(Aspectrule,1)
                        nextCond = Aspectrule{ii,2};
                        evalCond = eval(nextCond);
                        if evalCond
                            nrOfWays(ii) = true;
                        end
                        %check: current node is not selected?--------------
                        if ~evalCond && strcmp(Aspectrule{ii,1},nodeObj.name)
                            return
                        end
                    end
                    if sum(nrOfWays)>1
                        trues = find(nrOfWays==true);
                        error(['More than one possible alternative in a decision is not allowed \n',...
                        'Error in Node: ',nodeObj.name,'\n',...
                        'Treepath: ',nodeObj.treepath,'\n',...
                        'Wrong Rule Cases',trues])
                    end         
                end
                %evaluate Functions in coupling----------------------------
                Coupling = nodeObj.coupling;
                isCouplingFUN_used = false;
                if ischar(Coupling)
                    isCouplingFUN_used = true;
                    % eval SESFunctions in Coupling of an aspect
                    [nodeObj] = obj.evalFunInCoup(nodeObj);
                end
                %check: type of node is maspect?---------------------------
                if strcmp(nodeObj.type,'MAspect')
                    %evaluate coupling depending on numRep-----------------                    
                    try
                        if ~isCouplingFUN_used
                            nodeObj.coupling = Coupling{eval(nodeObj.numRep)};
                        end
                    catch
                        nodeObj.coupling = cell(1,4);
                    end
                    
                    %find children of masp, create entities depending on numRep and add to PES
                    chlst = {};
                    chlst = obj.recursiveChildrenCollect(nodeObj,chlst,SES);
                    chlst(1) = [];  %delete first cell -> child of MASP generated anyway
                    obj.createMultChildren(nodeObj,SES,chlst);  %generate children of MASP with subtree                
                    
                    %replace maspect by aspect and add to PES--------------
                    newNode = aspect(nodeObj.name,nodeObj.treepath,nodeObj.parent,nodeObj.children,'Aspect',[],nodeObj.coupling);
                    newNode.priority = nodeObj.priority;
                    obj.nodes(newNode.treepath) = newNode; 
                else %type of node is aspect
                    %add node to PES---------------------------------------
                    newNode = obj.copy(nodeObj);
                    newNode.coupling = nodeObj.coupling;
                    newNode.aspectrule = cell(1,2);
                    newNode.priority = nodeObj.priority;
                    obj.nodes(newNode.treepath) = newNode;
                    %if node has children-> get next child of node
                    [ChildrenPath] = nodeObj.getChildrenPath;
                    for i=1:length(nodeObj.children)
                        nextChildPath = ChildrenPath{i};
                        nextnodeObj = SES.nodes(nextChildPath);
                        % REKURSIVE FUNCTION CALL!!!!!
                        obj.recursivePrune(nextnodeObj,SES);   %transfer child and repeat algorithm
                    end
                end
            end
            %% Bottom-Up Recursion 
            %check: node is not the root?
            %if root ->ignore bottom up
            if ~isempty(nodeObj.parent)
                [ParentPath] = nodeObj.getParentPath;
                parentNode = SES.nodes(ParentPath);
                %check: node is entity?
                if strcmp(nodeObj.type,'Entity')
                    % effects caused by pruning specs
                    if strcmp(parentNode.type,'Spec')
                        %delete attributes of GrandParentNode (GPN) with
                        %equal names like nodeObj--------------------------
                        % get grandparent
                        grandparentPath = parentNode.getParentPath;
                        grandparentNode = obj.nodes(grandparentPath);
                        nodeObj.attributes(cellfun(@isempty,nodeObj.attributes(:,1)),:) = [];  %delete empty cell entries
                        grandparentNode.attributes(cellfun(@isempty,grandparentNode.attributes(:,1)),:) = [];  %delete empty cell entries
                        nodeAttFromObj = obj.nodes(nodeObj.treepath).attributes;
                        nodeAttFromObj(cellfun(@isempty,nodeAttFromObj(:,1)),:) = [];  %delete empty cell entries
                        equalAtts = ismember(grandparentNode.attributes(:,1),nodeAttFromObj(:,1));
                        grandparentNode.attributes(equalAtts,:) = []; %delete equal attributenames in grandparent
                        %add all attributes from node to GPN
                        grandparentNode.attributes = [grandparentNode.attributes;nodeAttFromObj];
                        if isempty(grandparentNode.attributes)
                            grandparentNode.attributes = cell(1,2);
                        end
                        %--------------------------------------------------
                        % change name of GPN (3)---------------------------
                        oldName = grandparentNode.name;
                        preName = obj.nodes(nodeObj.treepath).name;
                        grandparentNode.name = [preName,'_',grandparentNode.name];
                        nodeObj = obj.nodes(nodeObj.treepath);
                        %---------------------------------------------------
                        %change children of GPN (4)------------------------
                        %add the children from nodeObj to grandparentNode(GPN)
                        %and delete the parentNode from GPN�s children
                        child2delete = strcmp(grandparentNode.children,parentNode.name);
                        grandparentNode.children(child2delete) = [];
                        grandparentNode.children = [grandparentNode.children,nodeObj.children];
                        %--------------------------------------------------
                        if ~isempty(grandparentNode.parent)
                            grand2parentPath = grandparentNode.getParentPath;
                            %check: Type of PN's GPN is aspect?
                            if strcmp(SES.nodes(grand2parentPath).type,'Aspect')
                                %change coupling of PN's GPN, if existant (1)
                                %get real parent of GPN (not from SES)
                                PNsGPN = obj.nodes(grand2parentPath);                      
                                %rename Coupling
                                PNsGPN.coupling(cellfun(@isempty,PNsGPN.coupling(:,1)),:) = [];  %delete empty cell entries
                                Coupling = PNsGPN.coupling;
                                newName = grandparentNode.name;
                                %compare coupling with oldname and replace when existant
                                sourceComp = Coupling(:,1);
                                sinkComp = Coupling(:,3);
                                row1 = strcmp(sourceComp,oldName);
                                row3 = strcmp(sinkComp,oldName);
                                Coupling(row1,1) = {newName};
                                Coupling(row3,3) = {newName};
                                if isempty(Coupling)
                                    Coupling = cell(1,4);
                                end
                                PNsGPN.coupling = Coupling;
                                %------------------------------------------
                                %change children of PN's GPN (2)-----------                                
                                Children = PNsGPN.children;
                                rightChild = strcmp(oldName,Children);
                                PNsGPN.children{rightChild} = newName;
                                %------------------------------------------
                            end
                        end
                        %check: node has another child?
                        %if so->get next child
                        ChildrenPathes = nodeObj.getChildrenPath;
                        oldNodeName = SES.nodes(nodeObj.treepath).name;
                        newNodeName = grandparentNode.name;
                        for kk=1:length(ChildrenPathes)
                            nextChild = SES.nodes(ChildrenPath{kk});
                            %check: type of childnode is aspect?
                            if strcmp(nextChild.type,'Aspect') && isKey(obj.nodes,ChildrenPath{kk})
                                %get Real nextChild from pesNodes if it exist in PES
                                nextChild = obj.nodes(ChildrenPath{kk});
                                %change parent of childnode (5)------------
                                nextChild.parent = newNodeName;
                                %------------------------------------------
                                %change coupling of childnode (6)----------
                                Coupling = nextChild.coupling;
                                %compare coupling with oldname and replace when existant
                                sourceComp = Coupling(:,1);
                                sinkComp = Coupling(:,3);
                                row1 = strcmp(sourceComp,oldNodeName);
                                row3 = strcmp(sinkComp,oldNodeName);
                                Coupling(row1,1) = {newNodeName};
                                Coupling(row3,3) = {newNodeName};
                                nextChild.coupling = Coupling;
                                %------------------------------------------
                            end
                        end 
                        %change parent of GPN's Children-------------------
                        %change coupling of GPN's Children-----------------
                        GPNfromSES = SES.nodes(grandparentPath);
                        CHPathOfGPN = GPNfromSES.getChildrenPath;
                        for kk =1:length(CHPathOfGPN)
                            if strcmp(SES.nodes(CHPathOfGPN{kk}).type,'Aspect') 
                                %change parent of GPN's Children
                                if isKey(obj.nodes,CHPathOfGPN{kk})
                                    CHNodeOfGPN = obj.nodes(CHPathOfGPN{kk});
                                else
                                    CHNodeOfGPN = SES.nodes(CHPathOfGPN{kk});
                                end
                                CHNodeOfGPN.parent = newNodeName;
                                %compare coupling with oldname and replace when existant
                                Coupling = CHNodeOfGPN.coupling;
                                row1 = strcmp(Coupling(:,1),oldName);
                                row3 = strcmp(Coupling(:,3),oldName);
                                Coupling(row1,1) = {newNodeName};
                                Coupling(row3,3) = {newNodeName};
                                CHNodeOfGPN.coupling = Coupling;
                            elseif strcmp(SES.nodes(CHPathOfGPN{kk}).type,'MAspect') 
                                %change parent of GPN's Children
                                if isKey(obj.nodes,CHPathOfGPN{kk})
                                    CHNodeOfGPN = obj.nodes(CHPathOfGPN{kk});
                                    %compare coupling with oldname and replace when existant
                                    Coupling = CHNodeOfGPN.coupling;
                                    row1 = strcmp(Coupling(:,1),oldName);
                                    row3 = strcmp(Coupling(:,3),oldName);
                                    Coupling(row1,1) = {newNodeName};
                                    Coupling(row3,3) = {newNodeName};
                                    CHNodeOfGPN.coupling = Coupling;
                                else
                                    CHNodeOfGPN = SES.nodes(CHPathOfGPN{kk});
                                    %compare coupling with oldname and replace when existant
                                    Coupling = CHNodeOfGPN.coupling;
                                    for cpl=1:length(Coupling)
                                        nxtCoup = Coupling{cpl};
                                        row1 = strcmp(nxtCoup(:,1),oldName);
                                        row3 = strcmp(nxtCoup(:,3),oldName);
                                        nxtCoup(row1,1) = {newNodeName};
                                        nxtCoup(row3,3) = {newNodeName};
                                        Coupling{cpl} = nxtCoup;
                                    end
                                    CHNodeOfGPN.coupling = Coupling;
                                end
                                CHNodeOfGPN.parent = newNodeName;
                            end
                        end
                        %--------------------------------------------------
                        % remove nodeObj from PES--------------------------
                        remove(obj.nodes,nodeObj.treepath);
                        %effects caused by pruning aspect descission nodes
                    elseif strcmp(parentNode.type,'Aspect')
                        %get real parent of obj (not from SES)
                        realParent = obj.nodes(ParentPath);
                        %change children of GPN (8)------------------------
                        %delete children of grandparent that were part of a
                        %descission node and are not the current father of 
                        %nodeObj
                        oldGrandParentpath = parentNode.getParentPath;
                        oldGPN = SES.nodes(oldGrandParentpath);
                        childrenPathesofGPN = oldGPN.getChildrenPath;
                        AspNames = {};
                        for ch=1:length(childrenPathesofGPN)
                            nxtChildpath = childrenPathesofGPN{ch};
                            if ismember(SES.nodes(nxtChildpath).type,{'MAspect','Aspect'})
                                AspNames = [AspNames,SES.nodes(nxtChildpath).name];
                            end
                        end
                        grandParentpath = parentNode.getParentPath;
                        grandParent = obj.nodes(grandParentpath);
                        equalCHNames = ismember(grandParent.children,AspNames); 
                        grandParent.children(equalCHNames) = [];
                        grandParent.children = [grandParent.children,{realParent.name}];
                        %--------------------------------------------------     
                    end 
                end
            end
        end%function
         
        %%
        function [filename, path] = save(obj,filename)
            import xml_Interface.*
            
            
            if nargin == 1
                filename = [];            
            end
            
            if isempty(filename)
                [filename, path] = uiputfile(...
                    {'*.mat','MAT-files (*.mat)';
                    '*.xml','XML-files (*.xml)'},...
                    'Save Model');
            else
                % when filename is given, save to current path
                path = [cd,'/'];
            end 
            
            if path
                path = strrep(path,'\','/'); %use linux file system
                if strcmp(filename(end-3:end),'.xml')
                    xDoc = SES2XML(obj);
                    xmlwrite([path,filename], xDoc);
                else
                    %rename PES object
                    new = obj;
                    save([path,filename],'new')
                end
            else
                % if uinput figure (see above) will be closed without a
                % valid path do nothing
            end
        end%function
        
        
        %%
        function copyOfSES = copySES(~,oldSes)
            %copy SES object
            % this = obj.Ses;
            % copyOfSES = feval(class(oldSes),[]);
            copyOfSES = ses();
            p = properties(copyOfSES);
            % p = properties(oldSes);
            for i = 1:length(p)
                if strcmp(p{i},'nodes')
                    %copy all node handles in container Map
                    nodeVals = values(oldSes.nodes);
                    for ii=1:oldSes.nodes.Count
                        %copy node
                        copyNode = feval(class(nodeVals{ii}),[],[],[],[],[]);
                        pnode = properties(nodeVals{ii});
                        for jj = 1:length(pnode)
                            copyNode.(pnode{jj}) = nodeVals{ii}.(pnode{jj}); 
                        end
                        copyOfSES.nodes(nodeVals{ii}.treepath) = copyNode;
                    end
                elseif ~strcmp(p{i},'parent')
                    copyOfSES.(p{i}) = oldSes.(p{i});   
                end
            end
        end%function
        
        
        %%
        function newSES = getPesBeforeFinalState(obj)
            newSES = feval(class(obj.Ses),[]);
            p = properties(obj.Ses);
            for i = 1:length(p)
                if strcmp(p{i},'nodes')
                    %copy all node handles in container Map
                    nodeVals = values(obj.nodes);
                    for ii=1:obj.nodes.Count
                        %copy node
                        copyNode = feval(class(nodeVals{ii}),[],[],[],[],[]);
                        pnode = properties(nodeVals{ii});
                        for jj = 1:length(pnode)
                            copyNode.(pnode{jj}) = nodeVals{ii}.(pnode{jj}); 
                        end
                        newSES.nodes(nodeVals{ii}.treepath) = copyNode;
                    end
                elseif ~strcmp(p{i},'parent')
                    newSES.(p{i}) = obj.(p{i});   
                end
            end
        end%function
        function newSES = evalGlobalPriorities(obj,newSES)
            allNodeObj = values(newSES.nodes);
            for i=1:length(allNodeObj)
                nextNodeObj = allNodeObj{i};
                if ismember(nextNodeObj.type,{'Aspect','MAspect'})
                    [flag,Sibs] = obj.isAspectSibling(nextNodeObj,newSES);
                    if flag
                        Aspectrule = obj.getRuleFromPriority(Sibs);
                        for SibNr = 1:length(Sibs)
                            Sibs{SibNr}.aspectrule = Aspectrule;
                            %replace oldNode without Rule with new Node
                            remove(newSES.nodes,Sibs{SibNr}.treepath);
                            newSES.nodes(Sibs{SibNr}.treepath) = Sibs{SibNr};
                        end
                    end
                end
            end
        end%function
        
        %%
        function [flag,Sibs] = isAspectSibling(obj,aspNode,newSES)
            Sibs = {};
            parentPath = aspNode.getParentPath;
            parentNode = obj.nodes(parentPath);
            [ChildrenPath] = parentNode.getChildrenPath;
            for i=1:length(ChildrenPath)
                childNode = newSES.nodes(ChildrenPath{i});
                if ismember(childNode.type,{'Aspect','MAspect'})
                    Sibs(end+1) = {childNode};
                end
            end
            if length(Sibs)>1
                flag = true;
            else
                flag = false;
                Sibs = {};
            end
        end%function
        
        
        %%
        function Aspectrule = getRuleFromPriority(~,Sibs)
            Aspectrule = cell(length(Sibs),2);
            Aspectrule(:,2) = {'false'};
            Priorities = zeros(1,length(Sibs));
            for i=1:length(Sibs)
                Priorities(i) = eval(Sibs{i}.priority);
                Aspectrule{i,1} = Sibs{i}.name;
            end
            maxPri = Priorities == max(Priorities);
            if sum(maxPri)==1
                Aspectrule(maxPri,2) = {'true'};
            end
        end%function     
        
        function display(obj)
            
            st = struct('sesVars',{obj.sesVars},...
                        'validity',obj.validity,...
                        'nodes',obj.nodes,...
                        'comment',obj.comment);
             disp(' ');
             disp([inputname(1),' = '])
             disp(st)
            
        end
    end
end
