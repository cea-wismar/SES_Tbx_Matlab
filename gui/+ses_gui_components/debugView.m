
classdef debugView < DefSett
    properties
        hData
        parent
        Table
    end
    methods
        function obj = debugView(parent)
            if nargin
                obj.parent = parent;
            else
                obj.parent = [];
            end            
            
            obj.hData.fig = figure(...
                'Units',            'normalized',...
                'Position',         [.3 .1 .4 .6],...
                'Color',            [1 1 1],...
                'Name',             'SES DEBUG VIEW',...
                'MenuBar',          'none',...
                'ToolBar',          'none',...
                'NumberTitle',      'off',...
                'Visible',          'off',...
                'CloseRequestFcn',  @obj.HideFcn); 
            
            Data = cell(1,6);
            
            obj.Table = BasicJTable(obj.hData.fig,...
                {'Node','Type','Attr','AsptR','Coup','SpecR'},...
                'ColumnWidth',  {80 20 60 60 60 60},...
                'Data',         Data,...
                'Units',        'normalized',...
                'Position',     [0 0 1 1]);            
           
        end
        function HideFcn(obj,varargin)
            set(obj.hData.fig,'Visible','off');
            
            try
                obj.parent.Hierarchy.hData.DebugViewBtn.setSelected(false);                
            catch
            end
        end
        function delete(obj)
            set(obj.hData.fig,'CloseRequestFcn','closereq');
            try
                close(obj.hData.fig);
            catch
            end
            delete(obj.hData.fig)
        end
        function ShowFcn(obj) 
            set(obj.hData.fig,'Visible','on');
        end
        function TF = isVisible(obj)
            TF = get(obj.hData.fig,'Visible');
        end
     
        function updateWindow(obj)            
            keys = obj.parent.Ses.nodes.keys;
            num_keys = numel(keys);
            DATA = cell(num_keys,6);
            
            hasSpecR = false; 
            
            for k = 1:num_keys
                nodeobj = obj.parent.Ses.nodes(keys{k});
                DATA{k,1} = nodeobj.name;
                DATA{k,2} = nodeobj.type;
                switch nodeobj.type
                    case 'Entity'
                        if iscellstr(nodeobj.attributes)
                            
                            if ismember(nodeobj.attributes(:,1),'mb')
                                optTxt = 'MB Link';
                            else
                                optTxt = '';
                            end
                            
                        	DATA{k,3} = sprintf('%d ATTR(S) %s',...
                                size(nodeobj.attributes,1),optTxt);
                        end
                        if hasSpecR
                            for p = 1:size(SpecR,1)
                                if strcmp(SpecR(p,1),nodeobj.name)
                                    DATA{k,6} = SpecR{p,2};
                                    break
                                end
                            end  
                        end
                    case {'Aspect','MAspect'}  
                        if iscellstr(nodeobj.aspectrule)                            
                            AspR = nodeobj.aspectrule;
                            for u = 1:size(AspR,1)
                                if strcmp(AspR(u,1),nodeobj.name)
                                    DATA{k,4} = AspR{u,2};
                                end
                            end  
                        end                    
                        
                        if ischar(nodeobj.coupling)
                        	DATA{k,5} = nodeobj.coupling;
                        elseif iscellstr(nodeobj.coupling)
                            DATA{k,5} = 'STATIC';
                        end                    
                    case 'Spec'
                        if iscellstr(nodeobj.specrule)
                            DATA{k,6} = sprintf('%d RULE(S) %d CHILDREN',...
                                size(nodeobj.specrule,1),...
                                numel(nodeobj.children));
                            hasSpecR = true;                            
                            SpecR = nodeobj.specrule;
                        else
                            hasSpecR = false; 
                        end
                    otherwise
                end
            end 
            set(obj.Table.hnd,'Data',DATA);            
        end
    end
end