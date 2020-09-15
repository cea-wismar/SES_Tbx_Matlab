classdef JBttn < DefSett
    properties
        hnd
        parent        
        hnd_btC
    end
    
    methods
        function obj = JBttn(parent,Icon,ToolTip,varargin)                  
            if nargin 
                obj.parent = parent;                
            else
                obj.parent = uiextras.VButtonBox(...
                    'Parent',           figure(),...
                    'ButtonSize',       [30 30],...
                    'BackgroundColor',  obj.Color.BG_P);
                Icon    = 'add';
                ToolTip = 'Add Sub Node';
                disp(['TEST MODE: ',mfilename])
            end
            %get FilePath and BackGroundColor
            i_path = obj.IconPath(Icon);
            bgc = obj.Color.BG_P;            
            
            %Java Components
            JBgd    = javaObjectEDT('java.awt.Color',bgc(1),bgc(2),bgc(3));
            %JVgd    = javaObjectEDT('java.awt.Color',vgc(1),vgc(2),vgc(3));
            JIcon   = javaObjectEDT('javax.swing.ImageIcon',i_path);            
            obj.hnd = javaObjectEDT('com.mathworks.mwswing.MJButton','');
            
            %set Default Settings
            set(obj.hnd,...
                'Icon',                 JIcon,...               
                'Background',           JBgd,...
                ...'Foreground',           JVgd,...
                'RequestFocusEnabled',  false,...
                'TooltipText',          ToolTip); 
            obj.hnd.setFlyOverAppearance(true);  
            if ~isempty(varargin)%Fix for R2015 gernerating output
                set(obj.hnd,varargin{:});    
            end
            
            if verLessThan('matlab','8.4.0')
                %Pos = javaObjectEDT('java.awt.BorderLayout.SOUTH');
                UIP = uipanel(...
                    'Parent',                   obj.parent,...
                    'BorderType',               'none',...
                    'BackgroundColor',          obj.Color.BG_P);
                ppos = getpixelposition(UIP);
                pause(.2)
                
                [~,obj.hnd_btC] = javacomponent(obj.hnd,[0 0 ppos(3) ppos(4)],UIP);
                set(obj.hnd_btC,'Units','normalized');                
            else
                %Add JButton to GUI
                [~,obj.hnd_btC] = javacomponent(obj.hnd,[0 0 1 1],obj.parent);  
            end
        end
        function setToolTipPicture(obj,PicName)
            filePath = IconPath(obj,PicName);
            filePath = strrep(['file:' filePath],'\','/');
%             str = ['<html><center><img src="' filePath '"><br>' ...
%                    '<b><font color="blue">' filePath];
            htmlstr = ['<html><center><img src="' filePath '">'];
            set(obj.hnd,'TooltipText',htmlstr);            
        end
    end    
end