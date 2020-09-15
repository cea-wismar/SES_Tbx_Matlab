function XmlObj = SES2XML_viewer(ses)
    %convert SES OBJ to XML OBJ (class: org.apache.xerces.dom.DocumentImpl)

    %Get XML object
    XmlObj = com.mathworks.xml.XMLUtils.createDocument('SESwithSettings');
    
    %Get the XML root object
    X_Root = XmlObj.getDocumentElement;
    X_Root.setAttribute('xmlns:vc', 'http://www.w3.org/2007/XMLSchema-versioning');
    X_Root.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
    X_Root.setAttribute('name', 'SES');
    
    %Append globals section
    X_Globals = XmlObj.createElement('globals');
    X_Root.appendChild(X_Globals);
    
    %Append sespes
    X_Sespes = XmlObj.createElement('sespes');
    X_Sespes.setAttribute('value', 'ses');
    X_Sespes.setAttribute('comment', ses.comment);
    X_Globals.appendChild(X_Sespes);
    
    %Append SESvars
    X_SesVars = XmlObj.createElement('sesvars');
    for SesVar_idx = 1:size(ses.var,1)
        if ~isempty(ses.var{SesVar_idx})
            SesVar = ses.var(SesVar_idx,:);                     %get current
            X_SesVar = getSesVars(XmlObj,SesVar,SesVar_idx);    %generate XML data           
            X_SesVars.appendChild(X_SesVar);                    %add SESvar to SESvars
        end
    end
    X_Globals.appendChild(X_SesVars);    
    
    %Append Semantic Conditions
    X_SemConds = XmlObj.createElement('semcons');
    for SemCond_idx = 1:numel(ses.Semantic_Conditions)
        if ~isempty(ses.Semantic_Conditions{SemCond_idx})
            SemCond = ses.Semantic_Conditions{SemCond_idx};      %get current   
            X_SemCond = getSemConds(XmlObj,SemCond,SemCond_idx); %generate XML data 
            X_SemConds.appendChild(X_SemCond);                   %add semcon to semcons
        end
    end
    X_Globals.appendChild(X_SemConds);

    %Append Selection Constraints
    X_SelCons = XmlObj.createElement('selcons');
    for SelCon_idx = 1:numel(ses.Selection_Constraints.Color)
        if ~isempty(ses.Selection_Constraints.Pathes{SelCon_idx,1})
            Pathes = ses.Selection_Constraints.Pathes(SelCon_idx,:);       
            Color  = ses.Selection_Constraints.Color(SelCon_idx);        
            SelCon = [Color,Pathes];                         %get current 
            SelCon = getSelCons(XmlObj,SelCon,SelCon_idx);   %generate XML data 
            X_SelCons.appendChild(SelCon);                   %add selcon to selcons
        end
    end
    X_Globals.appendChild(X_SelCons);
    
    %Append SESfcns
    X_SesFuns = XmlObj.createElement('sesfcns');
    for SesFun_idx = 1:numel(ses.fcn)
        if ~isempty(ses.fcn{SesFun_idx}.Filename)
            SesFun = ses.fcn(SesFun_idx);                    %get current      
            X_SesFun = getSesFuns(XmlObj,SesFun,SesFun_idx); %generate XML data
            X_SesFuns.appendChild(X_SesFun);                 %add SESfcn to SESfcns
        end
    end
    X_Globals.appendChild(X_SesFuns);
    
    %Append the tree
    X_Tree = XmlObj.createElement('tree');
    Nodes = ses.nodes.values();         %get a containers map with all nodes from the SES
    X_Tree = getTree(XmlObj,X_Tree,Nodes,ses.nodes.Count);   
    X_Root.appendChild(X_Tree);
    
end

function X_SesVar = getSesVars(XmlObj,SesVar,SesVar_idx)
    % GENERATE XML DATA FOR CURRENT SES VARIABLE
    X_SesVar = XmlObj.createElement('sesvar');
    %X_SesVar.setAttribute('idx',        num2str(SesVar_idx));
    X_SesVar.setAttribute('name',       SesVar{1});
    X_SesVar.setAttribute('value',      SesVar{2}); 
    X_SesVar.setAttribute('comment',    ''); 
end

function X_SemCond = getSemConds(XmlObj,SemCond,SemCond_idx)
    % GENERATE XML DATA FOR CURRENT SES VARIABLE
    X_SemCond = XmlObj.createElement('semcon');
    %X_SemCond.setAttribute('idx',       num2str(SemCond_idx));
    X_SemCond.setAttribute('value',     SemCond);
    X_SemCond.setAttribute('result',    ''); 
end

function X_SelCon = getSelCons(XmlObj,SelCon,SelCon_idx)
    % GENERATE XML DATA FOR CURRENT SELECTION CONSTRAINT
    X_SelCon = XmlObj.createElement('selcon');
    %X_SelCon.setAttribute('idx',       num2str(SelCon_idx));
    X_SelCon.setAttribute('startnode',    SelCon{2}); 
    X_SelCon.setAttribute('color',     SelCon{1});
    X_Sinks = XmlObj.createElement('sinks');
    for sink_idx=1:numel(SelCon{3})
       X_Sink = XmlObj.createElement('stopnode'); 
       X_Sink.setAttribute('idx',       num2str(sink_idx));
       X_Sink.setAttribute('value',     SelCon{3}{sink_idx});
       X_Sinks.appendChild(X_Sink);
    end
    X_SelCon.appendChild(X_Sinks);
end

function X_SesFun = getSesFuns(XmlObj,SesFun,SesFun_idx)
    % GENERATE XML DATA FOR CURRENT SES FUNCTION
    X_SesFun = XmlObj.createElement('ses_function');
    %X_SesFun.setAttribute('idx',        num2str(SesFun_idx));
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

function X_Tree = getTree(XmlObj,X_Tree,Nodes,numnodes)
    % GENERATE XML DATA FOR TREE
    nodesXMLInTree = containers.Map({''},{X_Tree});
        
    for Node_idx = 1:numnodes
        X_Node = XmlObj.createElement('node');
        Node = Nodes{Node_idx};                                     %get current
        
        %X_Node.setAttribute('idx',        num2str(Node_idx));
        X_Node.setAttribute('name',       Node.name);
        X_Node.setAttribute('comment',    Node.comment);
        
        %add attached variables for each nodetype
        if Node.type == "Entity"
            %add attributes
            for attr_idx = 1:size(Node.attributes,1)
                if ~isempty(Node.attributes{attr_idx,1})
                    X_Attribute = XmlObj.createElement('attr');
                    %X_Attribute.setAttribute('idx',     num2str(attr_idx));
                    X_Attribute.setAttribute('name',    Node.attributes{attr_idx,1});
                    X_Attribute.setAttribute('value',   Node.attributes{attr_idx,2});
                    X_Attribute.setAttribute('varfun',  '');
                    X_Attribute.setAttribute('comment', '');
                    X_Node.appendChild(X_Attribute);
                end
            end
            %set the type
            type = 'entity';
        
        elseif Node.type == "Aspect" || Node.type == "MAspect"
            %add aspectrule
            for asp_idx = 1:size(Node.aspectrule,1)
                if ~isempty(Node.aspectrule{asp_idx,1}) && all(Node.aspectrule{asp_idx,1} == Node.name)
                    X_Aspectrule = XmlObj.createElement('aspr');
                    %X_Aspectrule.setAttribute('idx',         num2str(asp_idx));
                    %X_Aspectrule.setAttribute('selection',   Node.aspectrule{asp_idx,1});
                    X_Aspectrule.setAttribute('condition',   Node.aspectrule{asp_idx,2});
                    X_Aspectrule.setAttribute('result',      '');
                    X_Aspectrule.setAttribute('comment',     '');
                    X_Node.appendChild(X_Aspectrule);
                end
            end
            %add priority
            X_Priority = XmlObj.createElement('prio');
            X_Priority.setAttribute('value',  get(Node,'priority'));
            X_Node.appendChild(X_Priority);
            
            %set type and add type specific attached variables
            if Node.type == "Aspect"
                %set the type
                type = 'aspect';
                %add couplings
                if ischar(Node.coupling)    %couplingfunction
                    X_Coupling = XmlObj.createElement('cplg');
                    %X_Coupling.setAttribute('idx',             '');
                    X_Coupling.setAttribute('sourcenode',      '');
                    X_Coupling.setAttribute('sourceport',      '');
                    X_Coupling.setAttribute('sourcetype',      '');
                    X_Coupling.setAttribute('sinknode',        '');
                    X_Coupling.setAttribute('sinkport',        '');
                    X_Coupling.setAttribute('sinktype',        '');
                    X_Coupling.setAttribute('cplgfcn',         Node.coupling);
                    X_Coupling.setAttribute('comment',         '');
                    X_Node.appendChild(X_Coupling);
                else                       %couplinglist -> several couplings
                    for coup_idx = 1:size(Node.coupling,1)
                        if ~isempty(Node.coupling{coup_idx,1})
                            X_Coupling = XmlObj.createElement('cplg');
                            %X_Coupling.setAttribute('idx',         num2str(coup_idx));
                            X_Coupling.setAttribute('sourcenode',      Node.coupling{coup_idx,1});
                            X_Coupling.setAttribute('sourceport',      Node.coupling{coup_idx,2});
                            X_Coupling.setAttribute('sourcetype',      'no_porttype');
                            X_Coupling.setAttribute('sinknode',        Node.coupling{coup_idx,3});
                            X_Coupling.setAttribute('sinkport',        Node.coupling{coup_idx,4});
                            X_Coupling.setAttribute('sinktype',        'no_porttype');
                            X_Coupling.setAttribute('cplgfcn',         '');
                            X_Coupling.setAttribute('comment',         '');
                            X_Node.appendChild(X_Coupling);
                        end
                    end
                end
            else
                %set the type
                type = 'multiaspect';
                %add couplings                
                if ischar(Node.coupling)    %couplingfunction
                    X_Coupling = XmlObj.createElement('cplg');
                    %X_Coupling.setAttribute('idx',             '');
                    X_Coupling.setAttribute('sourcenode',      '');
                    X_Coupling.setAttribute('sourceport',      '');
                    X_Coupling.setAttribute('sourcetype',      '');
                    X_Coupling.setAttribute('sinknode',        '');
                    X_Coupling.setAttribute('sinkport',        '');
                    X_Coupling.setAttribute('sinktype',        '');
                    X_Coupling.setAttribute('cplgfcn',         Node.coupling);
                    X_Coupling.setAttribute('comment',         '');
                    X_Node.appendChild(X_Coupling);
                else                       %couplinglist -> several cases, several couplings
                    for case_idx = 1: numel(Node.coupling)  
                        CoupCase = Node.coupling{case_idx};
                        %X_Node.appendChild('int_start', num2str(Node.interval(1)));
                        %X_Node.appendChild('int_end',   num2str(Node.interval(2)));
                        for coup_idx = 1:size(CoupCase,1)
                            if ~isempty(CoupCase{coup_idx,1})
                                X_Coupling = XmlObj.createElement('cplg');
                                %X_Coupling.setAttribute('idx',         num2str(coup_idx));
                                X_Coupling.setAttribute('sourcenode',      CoupCase{coup_idx,1});
                                X_Coupling.setAttribute('sourceport',      CoupCase{coup_idx,2});
                                X_Coupling.setAttribute('sourcetype',      'no_porttype');
                                X_Coupling.setAttribute('sinknode',        CoupCase{coup_idx,3});
                                X_Coupling.setAttribute('sinkport',        CoupCase{coup_idx,4});
                                X_Coupling.setAttribute('sinktype',        'no_porttype');
                                X_Coupling.setAttribute('cplgfcn',         '');
                                X_Coupling.setAttribute('comment',         strcat('Case number ', num2str(case_idx)));
                                X_Node.appendChild(X_Coupling);
                            end
                        end
                    end
                end
                %add numRep
                X_NumRep = XmlObj.createElement('numr');
                X_NumRep.setAttribute('value',  get(Node,'numRep'));
                X_Node.appendChild(X_NumRep);
            end 
                    
        elseif Node.type == "Spec"
            %add specrule
            for spec_idx = 1:size(Node.specrule,1)
                if ~isempty(Node.specrule{spec_idx,1})
                    X_Specrule = XmlObj.createElement('specr');
                    %X_Specrule.setAttribute('idx',         num2str(spec_idx));
                    X_Specrule.setAttribute('fornode',     Node.specrule{spec_idx,1});
                    X_Specrule.setAttribute('condition',   Node.specrule{spec_idx,2});
                    X_Specrule.setAttribute('result',      '');
                    X_Specrule.setAttribute('comment',     '');
                    X_Node.appendChild(X_Specrule);
                end
            end 
            %set the type
            type = 'specialization';
        
        else
            %set the type
            type = 'descriptive';
        
        end
        X_Node.setAttribute('type',       type);
        
        %parent = Node.parent;
        
        %get the parent object
        treepath = split(Node.treepath, '/');
        treepath(end) = [];
        treepath = strjoin(treepath,{'/'});
        X_ParentObject = nodesXMLInTree(treepath);
        
        %append to the parent object
        X_ParentObject.appendChild(X_Node);
        nodesXMLInTree(Node.treepath) = X_Node;
    end
end