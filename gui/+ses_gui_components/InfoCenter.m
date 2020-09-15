classdef InfoCenter < DefSett
    properties
        jScrollPanel
        hLogPanel
        parent
        jEditbox
        OK_Btn
    end
    
    methods
        function obj = InfoCenter(parent)
            
            if nargin == 0
                parent = figure();
            end
            obj.parent = uiextras.HBox(...
                'Parent',           parent,...
                'BackgroundColor',  obj.Color.BG_P,...
                'Padding',          5,...
                'Spacing',          0);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            tmp = VBttnBar(obj.parent);
            obj.OK_Btn = JBttn(tmp.hnd,'del2','clear information window');
            
            obj.hLogPanel = uicontrol(...
                'Parent',               obj.parent,...
                'style',                'edit',...
                'max',                  5,...
                'HorizontalAlignment',  'left',...
                'Background',           'w',...
                'FontSize',             obj.Font.SizeM,...
                'FontName',             obj.Font.Name);
            
            % Get the underlying Java editbox, which is contained within a scroll-panel
            obj.jScrollPanel = findjobj(obj.hLogPanel);
            try
                obj.jScrollPanel.setVerticalScrollBarPolicy(...
                    obj.jScrollPanel.java.VERTICAL_SCROLLBAR_AS_NEEDED);
                obj.jScrollPanel = obj.jScrollPanel.getViewport;
            catch
                % may possibly already be the viewport, depending on release/platform etc.
            end
            obj.jEditbox = handle(obj.jScrollPanel.getView,'CallbackProperties');
            
            % Ensure we have an HTML-ready editbox
            HTMLclassname = 'javax.swing.text.html.HTMLEditorKit';
            if ~isa(obj.jEditbox.getEditorKit,HTMLclassname)
                obj.jEditbox.setContentType('text/html');
            end
            
            %remove the first line which is allway empty
            currentHTML = char(obj.jEditbox.getText);
            currentHTML = strrep(currentHTML,'<p style="margin-top: 0">','');
            currentHTML = strrep(currentHTML,'</p>','');
            obj.jEditbox.setText(currentHTML);
            obj.clearInfoCenter
            
            obj.jEditbox.setEditable(false)
            
            set(obj.OK_Btn.hnd,'MouseClickedCallback', @obj.clearInfoCenter);
            set(obj.parent,'Sizes',[35 -1])
            
            if nargin == 0
                obj.exampleMSG()
            end
        end
        
        function exampleMSG(obj)
            obj.logMessage('Warning','w')
            obj.logMessage('Help','h')
            obj.logMessage('Error','e')
            obj.logMessage('Question','q')
        end
        
        function clearInfoCenter(obj,varargin)
            obj.jEditbox.setText('');
            obj.jEditbox.setCaretPosition(0);
        end
        
        function logMessage(obj,text,severity)
            % Parse the severity and prepare the HTML message segment
            if nargin < 3,  severity='help';  end
            switch lower(severity(1))
                case 'h' %HELP
                    %icon    = 'greenarrowicon.gif';
                    Icon    = 'help';
                    color   = 'black';
                case 'w' %WARNING
                    %icon    = 'demoicon.gif';
                    Icon    = 'warn';
                    color   = 'orange';
                    beep();
                case 'q' %QUESTION
                    %icon    = 'demoicon.gif';
                    Icon    = 'quest';
                    color   = 'blue';
                otherwise %error
                    %icon    = 'warning.gif';
                    Icon    = 'error';
                    color   = 'red';
                    beep();
            end
            %icon = fullfile(matlabroot,'toolbox/matlab/icons',icon);
            icon = obj.IconPath(Icon);
            
            iconTxt =['<img src="file:///',icon,'" />'];
            msgTxt = ['&nbsp;<font color=',color,' size=4 >',text,'</font>'];
            newText = [iconTxt,msgTxt];
            endPosition = obj.jEditbox.getDocument.getLength;
            if endPosition>0, newText=['<br />' newText];  end
            
            % Place the HTML message segment at the bottom of the editbox
            currentHTML = char(obj.jEditbox.getText);
            obj.jEditbox.setText(strrep(currentHTML,[60 '/body>'],newText));
            endPosition = obj.jEditbox.getDocument.getLength;
            obj.jEditbox.setCaretPosition(endPosition); % end of content
        end
        
        function ret_str = MSG(obj,type,id,add_infos)            
            
            switch lower(type(1))
            case 'e' % ERRORs
            errors = {...
                '%s';... any error message
                ...HIRACHY                
                'Only one Entity Node can exist under a Multiple Aspect Node!';...                                  2
                'Desired name is not a valid node name!';...                                                        3
                'It is not allowed to replace an Entity node under a Multiple Aspect!';...                          4
                'Desired name already exist. Only Leaf Nodes are allowed to get existing names!';...                5
                'Desired name belongs to a node with a different type!';...                                         6
                'Replacing node not possible! Conflict with axiom "Valid Brothers"!';...                            7
                'Replacing node not possible! Conflict with axiom "Strict Hierarchy"!';...                          8
                'You can not change the Type of the Node to MAspect, unless more than one Entity Node exist!';...   9
                'You can not change the Type of the Node to MAspect, unless the child is not a leaf!';...          10
                'Only one Entity Node can exist under a Multiple Aspect Node!';...                                 11
                ... MENUE
                'Nodes need to be specified before pruning!';...                                                   12
                'File not valid.';...                                                                              13
                'The type of %d node(s) is not defined!';...                                                       14
                'Merging is not possible, because at least one of the inserted Nodes already exist!';...           15
                '"%s" is already open! To overwrite, close the original first.';...                                16
                ...SETTING
                'Function with equal name has already been imported!';...                                          17
                'Specified Condition already exist.';...                                                           18
                '';...'Existing Function can only be replaced by equal named Function!';...  %removed              19
                'SESVAR used by MAspect as NumRep! Cannot delete! '};                                             %20                            
            text = sprintf(errors{id},add_infos);
            
            case 'h' %HELPs
            helps = {...
                'Do not use First-Level (PES) for further pruning.Use the original SES.';... 1
                'Pruning is allowed!';...                                                    2
                'No Open Decisions exist!';...                                               3
                'SES Function(s) export to folder: ExportedFunctions'};                     %4                                                
            text = helps{id};
            
            case 'q' %QUESTIONs
            %HIRACHY
            quests(1).str = {'More than one node with the same name exist.','Select the deletion method!',...
                        'All Equal Names','First Equal Ancestor','Cancel','Cancel'};  
            quests(2).str =  {'Do you really want to delete the Node including Subnodes?','Warning!',...
                        'Yes','Cancel','Yes'};
            quests(3).str =  {'Do you really want to replace the Node?','Warning!',...
                        'Yes','Cancel','Yes'};
            quests(4).str =  {'Pressing OK will delete the Type Properties of the selected Node!',...
                        '!! Warning !!','OK','Cancel','Cancel'};            
            
            %USING QUESTDLG AND OUTPUT RESULT TO INFOCENTER        
            ret_str = questdlg(quests(id).str{:});
            text = [quests(id).str{1},' ',ret_str];
            
            otherwise
                text = add_infos;
            end
            
            try
                time_str = char(datetime('now','Format','HH:mm:ss'));
            catch
                time_str = datestr(now,'HH:MM:SS');
            end
            obj.logMessage([time_str,' ',text],type)
        end        
    end
end







































