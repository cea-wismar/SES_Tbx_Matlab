function SES = XML2SES(XmlObj)
%convert XML OBJ (class: org.apache.xerces.dom.DocumentImpl) to SES OBJ 

%DEBUG
%SES = XML2SES(xmlread('testXML2.xml'));

%% GENERATE SES OBJ
% GET XML OBJ
SES = ses();
X_SES = XmlObj.getLastChild;
X_SesItems = X_SES.getChildNodes();

for SesItem_idx = 0:X_SesItems.getLength()-1
    X_SesItem = X_SesItems.item(SesItem_idx);
    switch char(X_SesItem.getNodeName)      
        case 'nodes'
            X_Nodes = X_SesItem.getChildNodes();
            for Node_idx = 0:X_Nodes.getLength()-1
                X_Node = X_Nodes.item(Node_idx);
                if strcmp(char(X_Node.getNodeName),'node')
                    getNode(X_Node,SES)
                else
                    %skip item because it's #text
                end
            end
        case 'ses_variables'
            X_SesVars = X_SesItem.getChildNodes();
            for SesVar_idx = 0:X_SesVars.getLength()-1
                X_SesVar = X_SesVars.item(SesVar_idx);
                if strcmp(char(X_SesVar.getNodeName),'ses_variable')
                    getSesVar(X_SesVar,SES)
                else
                    %skip item because it's #text
                end
            end
        case 'ses_functions'
            X_SesFuns = X_SesItem.getChildNodes();
            for SesFun_idx = 0:X_SesFuns.getLength()-1
                X_SesFun = X_SesFuns.item(SesFun_idx);
                if strcmp(char(X_SesFun.getNodeName),'ses_function')
                    getSesFun(X_SesFun,SES)
                else
                    %skip item because it's #text
                end
            end
        case 'semantic_conditions'
            X_SemConds = X_SesItem.getChildNodes();
            for SemCond_idx = 0:X_SemConds.getLength()-1
                X_SemCond = X_SemConds.item(SemCond_idx);
                if strcmp(char(X_SemCond.getNodeName),'semantic_condition')
                    getSemCond(X_SemCond,SES)
                else
                    %skip item because it's #text
                end
            end
        case 'selection_constraints'
            X_SelCons = X_SesItem.getChildNodes();
            for SelCon_idx = 0:X_SelCons.getLength()-1
                X_SelCon = X_SelCons.item(SelCon_idx);
                if strcmp(char(X_SelCon.getNodeName),'selection_contraint')
                    getSelCon(X_SelCon,SES)
                else
                    %skip item because it's #text
                end
            end
        case 'comment'    
            X_Comment = X_SesItem.getChildNodes();
            SES.comment = X_Comment.getTextContent();
            
        otherwise
            %skip item because it's #text
    end    
end
end


%% HELPER FUNCTIONS
function Node_Attrs = getAttrs(X_Item)
%get all Attrbutes of X_Item 
X_Attrs = X_Item.getAttributes;
Node_Attrs = struct();
for Attr_idx = 0:X_Attrs.getLength()-1 % for all Attributes
    X_Attr = X_Attrs.item(Attr_idx);   % get current Attribute
    Node_Attrs.(char(X_Attr.getName)) = char(X_Attr.getNodeValue);
end
end

function SubTree = getSubTree(X_Item)
X_SubNodes = X_Item.getChildNodes();
SubTree = struct();
for SubNode_idx = 0:X_SubNodes.getLength()-1
    X_SubNode = X_SubNodes.item(SubNode_idx);
    name = char(X_SubNode.getNodeName());
    if strcmp(name,'#text')
        %skip item because it's #text
    else
        X_SubSubNodes = X_SubNode.getChildNodes();
        SubTreeStruct = struct();
        for nodes_idx = 0:X_SubSubNodes.getLength()-1
            X_SubSubNode = X_SubSubNodes.item(nodes_idx);
            subname = char(X_SubSubNode.getNodeName());
            if strcmp(subname,'#text')
                %skip item because it's #text
            else
                SubSubNode_Attrs = getAttrs(X_SubSubNode);                
                SubTreeStruct.([subname,SubSubNode_Attrs.idx]) = SubSubNode_Attrs;                
            end            
        end
        
        SubNode_Attrs = getAttrs(X_SubNode);
        if isfield(SubNode_Attrs,'idx') %needed for Couplings by MAsp Node
            SubTree.([name,SubNode_Attrs.idx]) = SubTreeStruct;
        else
            if strcmp(name,'couplings')                
                if isfield(SubNode_Attrs,'coupling_fun')          
                    SubTree.(name) = SubNode_Attrs;
                else
                    SubTree.(name) = SubTreeStruct;                     
                end
            else
               SubTree.(name) = SubTreeStruct; 
            end
        end
    end
end
end

%% SES NODES
% ADD SES NODES SECTION 
function getNode(X_Node,SES)
Node_Attrs = getAttrs(X_Node);

%All SES_Nodes share folloing Attributes
name     = Node_Attrs.name;
parent   = Node_Attrs.parent;
treepath = Node_Attrs.treepath;
type     = Node_Attrs.type;

%get all SUBTREE-DATA from X_Node
SubTree = getSubTree(X_Node);

%List with NAMES of all CHILDREN 
fnames = fieldnames(SubTree.children);
num_names = numel(fnames);
children = cell(1,num_names);
for k = 1:num_names
    children{1,k} = SubTree.children.(fnames{k}).name;
end

switch type
    case 'Entity'        
        %list with NAME/VALUE of ATTRIBUTES 
        fnames = fieldnames(SubTree.attributes);
        num_attrs = numel(fnames);
        attributes = cell(num_attrs,2);
        for j = 1:num_attrs
            attributes{1,j} = SubTree.attributes.(fnames{j}).name;
            attributes{1,j} = SubTree.attributes.(fnames{j}).value;
        end  
        
        SES_Node = entity(name,treepath,parent,children,type,attributes);
        
    case 'Spec' 
        %list with CONDITION/SELECTION of SPECRULES
        fnames = fieldnames(SubTree.specrules);
        num_specrs = numel(fnames);
        specrules = cell(num_specrs,2);
        for k = 1:num_specrs
            specrules{k,1} = SubTree.specrules.(fnames{k}).selection;
            specrules{k,2} = SubTree.specrules.(fnames{k}).condition;            
        end 
        
        SES_Node = spec(name,treepath,parent,children,type,specrules);
        
    case 'Aspect'        
        %list with CONDITION/SELECTION od all ASPECTRULES
        fnames = fieldnames(SubTree.aspectrules);
        num_aspecrs = numel(fnames);
        aspectrules = cell(num_aspecrs,2);
        for l = 1:num_aspecrs
            aspectrules{l,1} = SubTree.aspectrules.(fnames{l}).condition;
            aspectrules{l,2} = SubTree.aspectrules.(fnames{l}).selection;
        end         
        
        %list with SOURCE/PORT/SINK/PORT of COUPLINGS
        fnames = fieldnames(SubTree.couplings);
        if strcmp(fnames,'coupling_fun')
            couplings = SubTree.couplings.coupling_fun;
        else
            num_coups = numel(fnames);
            couplings = cell(num_coups,4);
            for m = 1:num_coups
                couplings{m,1} = SubTree.couplings.(fnames{m}).source;
                couplings{m,2} = SubTree.couplings.(fnames{m}).source_port;
                couplings{m,3} = SubTree.couplings.(fnames{m}).sink;
                couplings{m,4} = SubTree.couplings.(fnames{m}).sink_port;
            end 
        end
        
        SES_Node = aspect(name,treepath,parent,children,type,aspectrules,...
            couplings);
        SES_Node.priority = Node_Attrs.priority;  %priority
        
    case 'MAspect'
        interval(1,1) = str2double(Node_Attrs.int_start);
        interval(1,2) = str2double(Node_Attrs.int_end);        
        numRep        = Node_Attrs.num_rep;
                
        %list with CONDITION/SELECTION od all ASPECTRULES
        fnames = fieldnames(SubTree.aspectrules);
        num_aspecrs = numel(fnames);
        aspectrules = cell(num_aspecrs,2);
        for l = 1:num_aspecrs
            aspectrules{l,1} = SubTree.aspectrules.(fnames{l}).condition;
            aspectrules{l,2} = SubTree.aspectrules.(fnames{l}).selection;
        end
        
        %list with SOURCE/PORT/SINK/PORT of COUPLINGS
        fnames = fieldnames(SubTree);
        if isfield(SubTree,'couplings')
            couplings = SubTree.couplings.coupling_fun;
        else            
            num_cases = numel(fnames);
            %  first field is: children    > skip this fields 
            % second filed is: aspectrules > skip this fields 
            couplings = cell(1,num_cases-2);
            
            for o = 1:(num_cases-2)
                fnames2 = fieldnames(SubTree.(fnames{o+2}));
                num_coups = numel(fnames2);
                coupling_case = cell(num_coups,4);
                for p = 1:num_coups
                    coupling_case{p,1} = SubTree.(fnames{o+2}).(fnames2{p}).source;
                    coupling_case{p,2} = SubTree.(fnames{o+2}).(fnames2{p}).source_port;
                    coupling_case{p,3} = SubTree.(fnames{o+2}).(fnames2{p}).sink;
                    coupling_case{p,4} = SubTree.(fnames{o+2}).(fnames2{p}).sink_port;
                end
                couplings{o} = coupling_case;
            end
        end
        
        SES_Node = maspect(name,treepath,parent,children,type,aspectrules,...
            couplings,interval,numRep);
        SES_Node.priority = Node_Attrs.priority;  %priority
        
    otherwise %UNDEFINED NODE        
        SES_Node = node(name,treepath,parent,children,type);        
end
%ADD comment to node
if isfield(Node_Attrs,'comment') %COMPABILITY old xml-files
    SES_Node.comment = Node_Attrs.comment;
end

SES.nodes(treepath) = SES_Node;
end

%% SES VARIABLES
% ADD SES VARIABLES SECTION
function getSesVar(X_SesVar,SES)
SesVar_Attrs = getAttrs(X_SesVar);
if isempty(SES.var{1})
    SES.var = {SesVar_Attrs.name,SesVar_Attrs.value};
else
    SES.var(end+1,1:2)= {SesVar_Attrs.name,SesVar_Attrs.value};
end
end

%% SES FUNCTIONS 
% ADD SES FUNCTIONS SECTION
function getSesFun(X_SesFun,SES)
SesFun_Attrs = getAttrs(X_SesFun);
SubTree = getSubTree(X_SesFun);

Fun = struct(...
    'Filename',     SesFun_Attrs.name,...
    'Path',         SesFun_Attrs.path,...
    'Data',         []);

fname = fieldnames(SubTree.lines);
num   = numel(fname);
Data  = cell(num,1);
for i = 1: num
    %FunData = obj.parent.Ses.fcn{selRow+1}.Data     (24x1 cell)
    Data{i,1} = SubTree.lines.(fname{i}).value;
end
Fun.Data = Data;

if isempty(SES.fcn{1}.Filename)
    SES.fcn = {Fun};
else
    SES.fcn(end+1,1)= {Fun};
end
end

%% SES SEMANTIC CONDITIONS 
% ADD SES SEMANTIC CONDITIONS SECTION
function getSemCond(X_SemCond,SES)
SemCond_Attrs = getAttrs(X_SemCond);

if isempty(SES.Semantic_Conditions{1})
    SES.Semantic_Conditions = {SemCond_Attrs.value};
else
    SES.Semantic_Conditions(end+1,1)= {SemCond_Attrs.value};
end
end

%% SELECTION CONSTRAINTS
% ADD SELECTION CONSTRAINTS SECTION
function getSelCon(X_SelCon,SES)
SelCon_Attrs = getAttrs(X_SelCon);
SubTree = getSubTree(X_SelCon);

Color     = SelCon_Attrs.color;
Pathes    = cell(1,2);
Pathes{1} = SelCon_Attrs.source;

fnames = fieldnames(SubTree.sinks);
num = numel(fnames);
sinks = cell(1,num);
for i = 1:num
    sinks{i}=SubTree.sinks.(fnames{i}).value;   
end
Pathes{2} = sinks;

if isempty(SES.Selection_Constraints.Color)
    SES.Selection_Constraints.Pathes = Pathes;
    SES.Selection_Constraints.Color = {Color};
else
   SES.Selection_Constraints.Pathes(end+1,1:2) = Pathes;
   SES.Selection_Constraints.Color(end+1) = {Color};
end
end