classdef HBttnBar < DefSett
    properties
        hnd
        parent
    end
    
    methods
        function obj = HBttnBar(parent,varargin)           
            if nargin
                obj.parent = parent;
            else
                obj.parent = figure();
                disp(['TEST MODE: ',mfilename])
            end
            
            %HBox
            obj.hnd = uiextras.HButtonBox(...
                'Parent',               obj.parent,...
                'ButtonSize',           [30 30],...
                'VerticalAlignment',    'middle',...
                'HorizontalAlignment',  'left',...
                'BackgroundColor',      obj.Color.BG_P,...
                varargin{:});           
        end
    end    
end