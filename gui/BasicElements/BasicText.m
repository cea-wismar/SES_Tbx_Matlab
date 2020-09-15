classdef BasicText < DefSett
    properties
        hnd
        parent
    end
    
    methods
        function obj = BasicText(parent,String,varargin)
            if nargin
                obj.parent = parent;
            else
                obj.parent = figure();
                String = 'Test String';
                disp(['TEST MODE: ',mfilename])
            end
            
            %UICONTROL TEXT
            obj.hnd = uicontrol(...
                'Parent',               obj.parent,...
                'style',                'text',...
                'String',               String,...  
                ...'FontWeight',           'bold',...
                'HorizontalAlignment',  'left',...                
                'FontSize',             obj.Font.SizeM,...                
                'FontName',             obj.Font.NameText,...
                'BackgroundColor',      obj.Color.BG_P,...                
                varargin{:});
        end
    end
end


