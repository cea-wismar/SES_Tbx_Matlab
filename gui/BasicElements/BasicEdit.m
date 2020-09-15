classdef BasicEdit < DefSett
    properties
        hnd
        parent
    end
    
    methods
        function obj = BasicEdit(parent,KeyPressFcn,varargin)
            if nargin
                obj.parent = parent;
            else
                obj.parent = figure();
                KeyPressFcn = '';
                disp(['TEST MODE: ',mfilename])
            end
                        
            %UICONTROL Edit
            obj.hnd = uicontrol(...
                'Parent',               obj.parent,...  
                'KeyPressFcn',          KeyPressFcn,...
                'style',                'Edit',...
                'HorizontalAlignment',  'left',...
                'BackgroundColor',      obj.Color.FG,...                
                'FontSize',             obj.Font.SizeM,...
                'FontName',             obj.Font.Name,...
                varargin{:});  
        end
    end
end


