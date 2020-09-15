classdef JPicPane < DefSett
    properties
       jEditorPane       
       parent
       hnd
    end
    
    methods
        function obj = JPicPane(disable,varargin)            
            
            if ~nargin
                disable = false;
            end
            
            filepath = obj.IconPath('StartPic');               
            
            obj.parent = figure(...
                'MenuBar',      'None',...
                'Name',         'SES EDITOR is loading...',...
                'NumberTitle',  'off',...
                'WindowStyle',  'modal',...
                'Color',         obj.Color.BG_P,...
                'DockControls',  'off',...
                varargin{:});
            
            uimenu(obj.parent);
            set(obj.parent,'Position',get(obj.parent,'Position')+[0 -100 100 100]);
            
            VBOX = uiextras.VBox(...
                'Parent',           obj.parent,...
                'BackgroundColor',  obj.Color.BG_P);
            
            html_str = ['<html><center><img src="file:',filepath,'"/></center></html>'];
            bgc = obj.Color.BG_P;   
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %Java Components
            obj.jEditorPane = javaObjectEDT('javax.swing.JEditorPane','text/html',html_str);            
            JBgd            = javaObjectEDT('java.awt.Color',bgc(1),bgc(2),bgc(3));
            
            %Default Settings
            obj.jEditorPane.setBackground(JBgd) 
            obj.jEditorPane.setEditable(0)
           
            if verLessThan('MATLAB','8.4')
                Panel = uipanel('Parent',VBOX);                
                
                %Add JEdit to GUI                
                [~,obj.hnd] = javacomponent(obj.jEditorPane,[0 0 1 1],Panel);                 
            else
                %Add JEdit to GUI                
                [~,obj.hnd] = javacomponent(obj.jEditorPane,[0 0 1 1],VBOX); 
            end
            set(obj.hnd, 'Units','norm','Position',[0 0 1 1]);
            
            try
                if disable
                    enableDisableFig(obj.parent,'off');   
                end
            catch
            end
                    
        end
    end    
end




