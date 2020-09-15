classdef JEdit < DefSett
    properties
       jCodePane
       jCodePane_h
       jScrollPane
       parent
       hnd
    end
    
    methods
        function obj = JEdit(parent,str)            
            if nargin == 0
                str = ['% create a file for output\n' ...
                       '!touch testFile.txt\n' ...
                       'fid = fopen(''testFile.txt'', ''w'');\n' ...
                       'for i=1:10\n' ...
                       '    % Unterminated string:\n' ...
                       '    fprintf(fid,''%6.2f \\n, i);\n' ...
                       'end'];
                str = sprintf(strrep(str,'%','%%'));  
                disp(['TEST MODE: ',mfilename])
                
                
                obj.parent = uiextras.VBox(...
                    'Parent',           figure(),...
                    'BackgroundColor',  obj.Color.BG_P);
                
            else
                obj.parent = uiextras.VBox(...
                    'Parent',           parent,...
                    'BackgroundColor',  obj.Color.BG_P);
                
            end      
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            %Java Components
            obj.jCodePane = javaObjectEDT('com.mathworks.widgets.SyntaxTextPane');
            codeType =  com.mathworks.widgets.text.mcode.MLanguage.M_MIME_TYPE;
            
            
            %set Default Settings  
            obj.jCodePane.setContentType(codeType)
            obj.jCodePane.setText(str);   
            
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
            %obj.jCodePane.disable
            %set(obj.parent,'Visible','off')            
            %obj.jCodePane.getText         
        end
        
        function fprintf(obj,varargin)
            Txt = obj.jCodePane.getText;
            newTxt = sprintf(varargin{:});
            obj.jCodePane.setText(Txt.concat([char(10),newTxt]) )             %#ok<CHARTEN>
        end 
    end    
end
