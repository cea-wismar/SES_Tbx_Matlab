classdef JEditHTML < DefSett
    properties
       jCodePane
       jCodePane_h
       jScrollPane
       parent
       hnd
       OK_Btn
    end
    
    methods
        function obj = JEditHTML(parent)
                        
            if nargin == 0
                parent = figure();
            end     
            obj.parent = uiextras.VBox(...
                'Parent',           parent,...
                'BackgroundColor',  obj.Color.BG_P,...
                'Padding',          5,...
                'Spacing',          0);                
                    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%             mytext = ['<html><body>'...
%                       '<svg width="100" height="100">'...
%                       '<circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />'...
%                       '</svg>'...
%                       '</body></html>'];

            mytext = ['<html><body><table border="1">' ...
              '<tr><th>Month</th><th>Savings</th></tr>' ...
              '<tr><td>January</td><td>$100</td></tr>' ...
              '</table></body></html>'];       
      
            % Create a figure with a scrollable JEditorPane
            
            obj.jCodePane = javax.swing.JEditorPane('text/html', mytext);
                    
                        
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
            uiextras.Empty(...
                'Parent',               obj.parent,...
                'BackgroundColor',      obj.Color.BG_P);

            
            set(obj.parent,'Sizes',[-0.5 23 -0.5])
            
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


