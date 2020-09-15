classdef JEditPlain < DefSett
    properties
       jCodePane
       jCodePane_h
       jScrollPane
       parent
       hnd
       OK_Btn
    end
    
    methods
        function obj = JEditPlain(parent)
                        
            if nargin == 0
                parent = figure();
            end     
            obj.parent = uiextras.VBox(...
                'Parent',           parent,...
                'BackgroundColor',  obj.Color.BG_P,...
                'Padding',          5,...
                'Spacing',          0);                
                    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Java Components
            obj.jCodePane = javaObjectEDT('com.mathworks.widgets.SyntaxTextPane');
                        
            %use SCROLLBAR if needed
            obj.jScrollPane = javaObjectEDT('com.mathworks.mwswing.MJScrollPane',obj.jCodePane);
           
            if verLessThan('MATLAB','8.4')                
                %Panel = uiextras.Panel('Parent',obj.parent);
                Panel = uipanel('Parent',obj.parent);                
                
                %Add JEdit to GUI                
                [~,obj.hnd] = javacomponent(obj.jScrollPane,[0 0 1 1],Panel);                 
            else
                %Add JEdit to GUI                
                [~,obj.hnd] = javacomponent(obj.jScrollPane,[0 0 1 1],obj.parent); 
            end
            set(obj.hnd, 'Units','norm','Position',[0 0 1 1]);
            
            obj.jCodePane_h = handle(obj.jCodePane, 'CallbackProperties');
            
%             
            obj.OK_Btn = JBttn(obj.parent,'ok','OK');
%             uiextras.Empty(...
%                 'Parent',               obj.parent,...
%                 'BackgroundColor',      obj.Color.BG_P);

            
            set(obj.parent,'Sizes',[-0.5 23])%-0.5
            
            set(obj.OK_Btn.hnd,'MouseClickedCallback','disp(''OK BTN CALLBACK'')');
            %obj.jCodePane.disable
            %set(obj.parent,'Visible','off')            
            %obj.jCodePane.getText         
        end
        function text = getText(obj)
            text = obj.jCodePane.getText;
        end
        function setText(obj,str)
            obj.jCodePane.setText(str);
        end
        function setCallback(obj,FcnHdl)
            set(obj.OK_Btn.hnd,'MouseClickedCallback', FcnHdl);
        end

    end    
end


