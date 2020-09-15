classdef VBttnBar < DefSett
    properties
        hnd
        parent
    end
    
    methods
        function obj = VBttnBar(parent,varargin) 
            if nargin
                obj.parent = parent;
            else
                obj.parent = figure();
                disp(['TEST MODE: ',mfilename])
            end
            
            %VButtonBox
            obj.hnd = uiextras.VButtonBox(...
                'Parent',               obj.parent,...
                'ButtonSize',           [30 30],...
                'VerticalAlignment',    'top',...
                'HorizontalAlignment',  'center',...
                'BackgroundColor',      obj.Color.BG_P,...
                varargin{:});
        end
    end    
end