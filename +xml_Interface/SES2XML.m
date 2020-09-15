function XmlObj = SES2XML(ses)
%convert SES OBJ to XML OBJ (class: org.apache.xerces.dom.DocumentImpl)

%% GENERATE XML OBJ AND XML ROOT USING MATLAB API
% GET XML OBJ
XmlObj = com.mathworks.xml.XMLUtils.createDocument('SES');
% GET XML ROOT OBJ
X_Root = XmlObj.getDocumentElement; %First (ROOT) NODE


%% SES NODES
% ADD SES NODES SECTION TO X_ROOT
X_Nodes = XmlObj.createElement('nodes');
Nodes = ses.nodes.values(); % GET ALL NODES FROM SES (CONTAINERS MAP)
for Node_idx = 1:ses.nodes.Count    
    Node = Nodes{Node_idx};                         % GET CURRENT      
    X_Node = getNode(XmlObj,Node,Node_idx);         % GENERATE XML DATA   
    X_Nodes.appendChild(X_Node);                    % ADD NODE TO NODES
end
X_Root.appendChild(X_Nodes);

%% SES VARIABLES
% ADD SES VARIABLES SECTION TO X_ROOT
X_SesVars = XmlObj.createElement('ses_variables');
for SesVar_idx = 1:size(ses.var,1)
    if ~isempty(ses.var{SesVar_idx})
        SesVar = ses.var(SesVar_idx,:);                  % GET CURRENT      
        X_SesVar = getSesVars(XmlObj,SesVar,SesVar_idx); % GENERATE XML DATA 
        X_SesVars.appendChild(X_SesVar);                 % ADD SESVAR TO SESVARS
    end
end
X_Root.appendChild(X_SesVars);

%% SES FUNCTIONS 
% ADD SES FUNCTIONS SECTION TO X_ROOT
X_SesFuns = XmlObj.createElement('ses_functions');
for SesFun_idx = 1:numel(ses.fcn)
    if ~isempty(ses.fcn{SesFun_idx}.Filename)
        SesFun = ses.fcn(SesFun_idx);                    % GET CURRENT      
        X_SesFun = getSesFuns(XmlObj,SesFun,SesFun_idx); % GENERATE XML DATA 
        X_SesFuns.appendChild(X_SesFun);                 % ADD SESFUN TO SESFUNS
    end
end
X_Root.appendChild(X_SesFuns);

%% SES SEMANTIC CONDITIONS 
% ADD SES SEMANTIC CONDITIONS SECTION TO X_ROOT
X_SemConds = XmlObj.createElement('semantic_conditions');
for SemCond_idx = 1:numel(ses.Semantic_Conditions)
    if ~isempty(ses.Semantic_Conditions{SemCond_idx})
        SemCond = ses.Semantic_Conditions{SemCond_idx};      % GET CURRENT      
        X_SemCond = getSemConds(XmlObj,SemCond,SemCond_idx); % GENERATE XML DATA 
        X_SemConds.appendChild(X_SemCond);                   % ADD SESFUN TO SESFUNS
    end
end
X_Root.appendChild(X_SemConds);

%% SELECTION CONSTRAINTS
% ADD SELECTION CONSTRAINTS SECTION TO X_ROOT
X_SelCons = XmlObj.createElement('selection_constraints');
for SelCon_idx = 1:numel(ses.Selection_Constraints.Color)
    if ~isempty(ses.Selection_Constraints.Pathes{SelCon_idx,1})
        Pathes = ses.Selection_Constraints.Pathes(SelCon_idx,:);       
        Color  = ses.Selection_Constraints.Color(SelCon_idx);        
        SelCon = [Color,Pathes];                         % GET CURRENT
        SelCon = getSelCons(XmlObj,SelCon,SelCon_idx);   % GENERATE XML DATA 
        X_SelCons.appendChild(SelCon);                   % ADD SESFUN TO SESFUNS
    end
end
X_Root.appendChild(X_SelCons);

%% SES COMMENT
% ADD COMMENT SECTION TO X_ROOT
X_Comment = XmlObj.createElement('comment');
X_Comment.setTextContent(ses.comment)
X_Root.appendChild(X_Comment);

end

function X_Node = getNode(XmlObj,Node,Node_idx)
% GENERATE XML DATA FOR CURRENT SES_NODE
X_Node = XmlObj.createElement('node');
X_Node.setAttribute('idx',        num2str(Node_idx));
X_Node.setAttribute('type',       Node.type);
X_Node.setAttribute('treepath',   Node.treepath);
X_Node.setAttribute('parent',     Node.parent);
X_Node.setAttribute('name',       Node.name);
X_Node.setAttribute('comment',    Node.comment);

% GENERATE XML BLOCK CHILDREN FOR CURRENT SES_NODE
X_Children = XmlObj.createElement('children');
for ch_idx=1:numel(Node.children)
    X_Child = XmlObj.createElement('child');    
    X_Child.setAttribute('idx',   num2str(ch_idx));
    X_Child.setAttribute('name',  Node.children{ch_idx});
    % ADD CHILD TO CHILDREN BLOCK
    X_Children.appendChild(X_Child);
end
% ADD XML DATA TO NODE
X_Node.appendChild(X_Children); 

% NODE SPECIFIC XML DATA
switch get(Node,'type')
    case 'Entity'
        % GENERATE XML BLOCK ATTRIBUTES 
        X_Attributes = XmlObj.createElement('attributes');
        for attr_idx = 1:size(Node.attributes,1)
            if ~isempty(Node.attributes{attr_idx,1})
                X_Attribute = XmlObj.createElement('attribute');
                X_Attribute.setAttribute('idx',     num2str(attr_idx));
                X_Attribute.setAttribute('name',    Node.attributes{attr_idx,1});
                X_Attribute.setAttribute('value',   Node.attributes{attr_idx,2});
                % ADD ATTRIBUTE TO ATTRIBUTES BLOCK
                X_Attributes.appendChild(X_Attribute);
            end
        end
        X_Node.appendChild(X_Attributes); 
        
    case 'Spec'
        % GENERATE XML BLOCK SPECRULES 
        X_Specrules = XmlObj.createElement('specrules');
        for spec_idx = 1:size(Node.specrule,1)
            if ~isempty(Node.specrule{spec_idx,1})
                X_Specrule = XmlObj.createElement('specrule');
                X_Specrule.setAttribute('idx',         num2str(spec_idx));
                X_Specrule.setAttribute('selection',   Node.specrule{spec_idx,1});
                X_Specrule.setAttribute('condition',   Node.specrule{spec_idx,2});
                % ADD ATTRIBUTE TO ATTRIBUTES BLOCK
                X_Specrules.appendChild(X_Specrule);
            end
        end
        X_Node.appendChild(X_Specrules); 
        
    case 'Aspect'
        X_Node.setAttribute('priority',  get(Node,'priority'));
        
        % GENERATE XML BLOCK ASPECTRULES
        X_Aspectrules = XmlObj.createElement('aspectrules');
        for asp_idx = 1:size(Node.aspectrule,1)
            if ~isempty(Node.aspectrule{asp_idx,1})
                X_Aspectrule = XmlObj.createElement('aspectrule');
                X_Aspectrule.setAttribute('idx',         num2str(asp_idx));
                X_Aspectrule.setAttribute('selection',   Node.aspectrule{asp_idx,1});
                X_Aspectrule.setAttribute('condition',   Node.aspectrule{asp_idx,2});
                % ADD ASPECTRULE TO ASPECTRULES BLOCK
                X_Aspectrules.appendChild(X_Aspectrule);
            end
        end
        X_Node.appendChild(X_Aspectrules); 
        
        % GENERATE XML BLOCK COUPLINGS
        X_Couplings = XmlObj.createElement('couplings');
        if ischar(Node.coupling)
            X_Couplings.setAttribute('coupling_fun',Node.coupling);
        else 
            for coup_idx = 1:size(Node.coupling,1)
                if ~isempty(Node.coupling{coup_idx,1})
                    X_Coupling = XmlObj.createElement('coupling');
                    X_Coupling.setAttribute('idx',         num2str(coup_idx));
                    X_Coupling.setAttribute('source',      Node.coupling{coup_idx,1});
                    X_Coupling.setAttribute('source_port', Node.coupling{coup_idx,2});
                    X_Coupling.setAttribute('sink',        Node.coupling{coup_idx,3});
                    X_Coupling.setAttribute('sink_port',   Node.coupling{coup_idx,4});
                    % ADD ASPECTRULE TO ASPECTRULES BLOCK
                    X_Couplings.appendChild(X_Coupling);
                end
            end
        end
        X_Node.appendChild(X_Couplings);  
        
    case 'MAspect'
        X_Node.setAttribute('priority',  get(Node,'priority'));
        X_Node.setAttribute('num_rep',   Node.numRep);        
        X_Node.setAttribute('int_start', num2str(Node.interval(1)));
        X_Node.setAttribute('int_end',   num2str(Node.interval(2)));        
        
        
        % GENERATE XML BLOCK ASPECTRULES
        X_Aspectrules = XmlObj.createElement('aspectrules');
        for asp_idx = 1:size(Node.aspectrule,1)
            if ~isempty(Node.aspectrule{asp_idx,1})
                X_Aspectrule = XmlObj.createElement('aspectrule');
                X_Aspectrule.setAttribute('idx',         num2str(asp_idx));
                X_Aspectrule.setAttribute('selection',   Node.aspectrule{asp_idx,1});
                X_Aspectrule.setAttribute('condition',   Node.aspectrule{asp_idx,2});
                % ADD ASPECTRULE TO ASPECTRULES BLOCK
                X_Aspectrules.appendChild(X_Aspectrule);
            end
        end
        X_Node.appendChild(X_Aspectrules); 
        
        % GENERATE XML BLOCK COUPLINGS        
        if ischar(Node.coupling)
            X_Couplings = XmlObj.createElement('couplings');
            X_Couplings.setAttribute('coupling_fun',Node.coupling);            
            X_Node.appendChild(X_Couplings); 
        else 
            for case_idx = 1: numel(Node.coupling)
                X_Couplings = XmlObj.createElement('couplings');
                X_Couplings.setAttribute('idx',num2str(case_idx));
                
                CoupCase = Node.coupling{case_idx};
                for coup_idx = 1:size(CoupCase,1)
                    if ~isempty(CoupCase{coup_idx,1})
                        X_Coupling = XmlObj.createElement('coupling');
                        X_Coupling.setAttribute('idx',         num2str(coup_idx));
                        X_Coupling.setAttribute('source',      CoupCase{coup_idx,1});
                        X_Coupling.setAttribute('source_port', CoupCase{coup_idx,2});
                        X_Coupling.setAttribute('sink',        CoupCase{coup_idx,3});
                        X_Coupling.setAttribute('sink_port',   CoupCase{coup_idx,4});
                        % ADD ASPECTRULE TO ASPECTRULES BLOCK
                        X_Couplings.appendChild(X_Coupling);
                    end
                end
                X_Node.appendChild(X_Couplings);
            end
        end 
end
end

function X_SesVar = getSesVars(XmlObj,SesVar,SesVar_idx)
% GENERATE XML DATA FOR CURRENT SES VARIABLR
X_SesVar = XmlObj.createElement('ses_variable');
X_SesVar.setAttribute('idx',        num2str(SesVar_idx));
X_SesVar.setAttribute('name',       SesVar{1});
X_SesVar.setAttribute('value',      SesVar{2}); 
end

function X_SesFun = getSesFuns(XmlObj,SesFun,SesFun_idx)
% GENERATE XML DATA FOR CURRENT SES FUNCTION
X_SesFun = XmlObj.createElement('ses_function');
X_SesFun.setAttribute('idx',        num2str(SesFun_idx));
X_SesFun.setAttribute('name',       SesFun{:}.Filename);
X_SesFun.setAttribute('path',       SesFun{:}.Path);
X_Data = XmlObj.createElement('lines');
for data_idx = 1:numel(SesFun{:}.Data)
    X_Line = XmlObj.createElement('line');
    X_Line.setAttribute('idx',      num2str(data_idx));
    X_Line.setAttribute('value',    SesFun{:}.Data{data_idx});
    X_Data.appendChild(X_Line);
end
X_SesFun.appendChild(X_Data);
end

function X_SemCond = getSemConds(XmlObj,SemCond,SemCond_idx)
% GENERATE XML DATA FOR CURRENT SES VARIABLE
X_SemCond = XmlObj.createElement('semantic_condition');
X_SemCond.setAttribute('idx',       num2str(SemCond_idx));
X_SemCond.setAttribute('value',     SemCond); 
end

function X_SelCon = getSelCons(XmlObj,SelCon,SelCon_idx)
% GENERATE XML DATA FOR CURRENT SELECTION CONSTRAINT
X_SelCon = XmlObj.createElement('selection_contraint');
X_SelCon.setAttribute('idx',       num2str(SelCon_idx));
X_SelCon.setAttribute('source',    SelCon{2}); 
X_SelCon.setAttribute('color',     SelCon{1});
X_Sinks = XmlObj.createElement('sinks');
for sink_idx=1:numel(SelCon{3})
   X_Sink = XmlObj.createElement('sink'); 
   X_Sink.setAttribute('idx',       num2str(sink_idx));
   X_Sink.setAttribute('value',     SelCon{3}{sink_idx});
   X_Sinks.appendChild(X_Sink);
end
X_SelCon.appendChild(X_Sinks);
end