classdef BasicJTable < DefSett
    properties       
       jScroll
       parent
       hnd
       jtable       
    end
    
    methods
        function obj = BasicJTable(parent,ColumnName,varargin)            
            if nargin == 0                
                obj = BasicJTable(figure,...
                    {'Variable Name','Variable Value'});
                disp(['TEST MODE: ',mfilename]) 
                return 
            end
            
            obj.parent = parent;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.hnd = uitable(...
                'Parent',                   obj.parent,...
                'ColumnName',               ColumnName,...
                'Data',                     cell(1,numel(ColumnName)),...
                'BackgroundColor',          obj.Color.FG,...
                'ColumnEditable',           false,...                
                'FontName',                 obj.Font.Name,...
                'RowStriping',              'off',...
                varargin{:});
            
            import javax.swing.*
            
            %get java handles
            obj.jScroll = findjobj(obj.hnd);
            %javaMethodEDT('setHorizontalScrollBarPolicy',obj.jScroll,30)
            %set(obj.jScroll,'HorizontalScrollBarPolicy',30)
            obj.jScroll.setHorizontalScrollBarPolicy(30)
            %j_viewport = get(obj.jScroll,'Viewport');
            %obj.jtable = get(j_viewport,'View');
            %obj.jtable = get(obj.jScroll.getViewport,'View');
            obj.jtable = obj.jScroll.getViewport.getView;
                                    
            %set java properies
            obj.jtable.setSelectionMode(...
                ListSelectionModel.SINGLE_INTERVAL_SELECTION);
            obj.jtable.setNonContiguousCellSelection(false)
            obj.jtable.setColumnSelectionAllowed(false)
            obj.jtable.setRowSelectionAllowed(true)
            obj.jtable.setRowSelectionInterval(0,0)            
            obj.jtable.setAutoResizeMode(...
                obj.jtable.AUTO_RESIZE_SUBSEQUENT_COLUMNS) 
        end
    end    
end