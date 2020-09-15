classdef BasicBox < DefSett
    properties
        hnd
        parent
    end
    
    methods
        function obj = BasicBox(parent,BoxType,Padding,Spacing,varargin)
            if nargin
                obj.parent = parent;
            else
                obj.parent = figure();
                BoxType = 'VBox';
                Padding = 5;
                Spacing = 5;
                disp(['TEST MODE: ',mfilename])
            end
                        
            %Panel
            obj.hnd = uiextras.(BoxType)(... 
                'Parent',            obj.parent,...  
                'Padding',           Padding,...
                'Spacing',           Spacing,...                
                'BackgroundColor',   obj.Color.BG_D,...                   
                varargin{:});   
        end
    end
end


