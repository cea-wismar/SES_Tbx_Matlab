classdef settings < ses_gui_components.supportFun
    properties 
        mainPanel
    end
    methods
        %% Constructor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = settings(parent) %constructor 
            import javax.swing.*
            
            obj.parent = parent; 
            obj.hData.curSelCon = cell(1,2);
            obj.hData.List1 = {};
            obj.hData.List2 = {};
            obj.hData.List3 = {};           
            
            
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
                   
           obj.mainPanel = uiextras.TabPanel(...                
                'Parent',               obj.parent.hData.f1,...
                'Padding',              0 ,...
                'FontName',             obj.Default.Font.NameText,...
                'FontSize',             obj.Default.Font.SizeS,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          
            obj.hData.hb1 = uiextras.VBox(...
                'Parent',               obj.mainPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            obj.hData.hb3 = uiextras.VBox(...
                'Parent',               obj.mainPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            obj.hData.hb3b = uiextras.VBox(...
                'Parent',               obj.mainPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Comment Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.hData.Comment = JEditPlain(obj.mainPanel);
            obj.hData.Comment.setText(obj.parent.Ses.comment);
            obj.hData.Comment.setCallback(@(hobj,evt)obj.updateComment(hobj,evt))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            % Initialize some button group properties.
            set(obj.mainPanel,...
                'TabNames',             {'SES Vars & SC',...
                                         'Sel Const',...
                                         'Functions',...
                                         'Description'},...                
                'TabSize',              90);      
            
            %% SES Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            set(obj.mainPanel,'SelectedChild',1)
            
            % Edit part
            % 20a.) Edit Panel Variables
            obj.hData.hp20a = uiextras.VBox(...
                'Parent',               obj.hData.hb1,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Padding',              0,...
                'Spacing',              0,...
                'Visible',              'on');
                
            %20b) Text Enter Variable Name  
            BasicText(obj.hData.hp20a,'Name');
                
            % 20c.) Edit Variable Name
            tmp = BasicEdit(obj.hData.hp20a,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Variables'));
            obj.hData.hb20c = tmp.hnd;
            
            
            %5.) % JEdit Edit Variable Name
            obj.hData.jhb20c = findjobj(obj.hData.hb20c);
            obj.hData.jhb20ccaret = obj.hData.jhb20c.getCaret;
            set(obj.hData.jhb20c,'CaretUpdateCallback',@(hobj,evt)obj.checkSetting(hobj,evt,'Variables')); 
            
            %20d) Text Enter Variable Value 
            BasicText(obj.hData.hp20a,'Value');

            % 20e.) Edit Variable Value
            tmp = BasicEdit(obj.hData.hp20a,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Variables'));
            obj.hData.hb20e = tmp.hnd;
            
            %6.)  JEdit Edit Variable Value
            obj.hData.jhb20e = findjobj(obj.hData.hb20e);
            obj.hData.jhb20ecaret = obj.hData.jhb20e.getCaret;
            set(obj.hData.jhb20e,'CaretUpdateCallback',@(hobj,evt)obj.checkSetting(hobj,evt,'Variables'));                      
            %this callback prooves whether Variable Input is valid

            %some space
            uiextras.Empty('Parent',obj.hData.hp20a);     
                                    
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp20a);     
                
            % 17.) Icon add Variable
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.addRow( hobj,evt,'Variables'));
            obj.hData.jhb17         = IconObj.hnd;
               
                           
            % 18.) Icon delete Variable
            IconObj = JBttn(BBar.hnd,'del','Delete Selected Rows');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.deleteRow(hobj,evt,'Variables'));
            obj.hData.jhb18         = IconObj.hnd;
            
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 20f.) Pushbuttons "OK"                        
            IconObj = JBttn(BBar.hnd,'ok','Insert Variable');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.ButtonCbckSaveVariable);
            obj.hData.jhb20f         = IconObj.hnd;
            set(obj.hData.jhb20f,'Enabled',false)
                                   
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(6);');
            
            % Parent     
            set(obj.hData.hp20a,'Sizes',[23 23 23 23 23 23])
             
            
            % Table part
            % 16.) Table Panel Variables
            % 19) generating table in Variables
            tmp = BasicJTable(obj.hData.hb1,...
                {'Variable Name','Variable Value'});
            obj.hData.Tables.mtable2 = tmp.hnd;
            obj.hData.Tables.jtable2 = tmp.jtable;

            
            % set(obj.hData.Tables.jtable2.getSelectionModel,'ValueChangedCallback',@(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable2))
            %Fix to MATLAB R2014 to use ValueChangedCallback-
            set(handle(obj.hData.Tables.jtable2.getSelectionModel,'CallbackProperties'),...
                    'ValueChangedCallback',@(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable2)) 
           
                      

            %% Semantic Conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Edit part
            % 32.) Panel Edit Semantic Conditions
            obj.hData.hp32 = uiextras.VBox(...
                    'Parent',               obj.hData.hb1,...
                    'BackgroundColor',      obj.Default.Color.BG_P,...
                    'Padding',              0,...
                    'Spacing',              5,...
                    'Visible',              'on'); 
            
            %13) Text Enter Semantic Condition
            BasicText(obj.hData.hp32,'Enter Semantic Condition');
            
            % 34.) Edit Set Semantic Conditions
            tmp = BasicEdit(obj.hData.hp32,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Semantic Conditions')); 
            obj.hData.hb34 = tmp.hnd;
                
             %10.) % JEdit Semantic Conditions-
            obj.hData.jhb34 = findjobj(obj.hData.hb34);
            obj.hData.jhb34caret = obj.hData.jhb34.getCaret;
            set(obj.hData.jhb34,'CaretUpdateCallback',@(hobj,evt)obj.checkSetting(hobj,evt,'Semantic Conditions'));                      
            
            %some space
            uiextras.Empty('Parent',obj.hData.hp32);            
            
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp32);
            
            % 29.) Icon add Semantic Conditions
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.addRow( hobj,evt,'Semantic Conditions'));
            obj.hData.jhb29         = IconObj.hnd;
               
                       
            % 30.) Icon delete Semantic Conditions
            IconObj = JBttn(BBar.hnd,'del','Delete Selected Rows');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.deleteRow(hobj,evt,'Semantic Conditions'));
            obj.hData.jhb30         = IconObj.hnd;
            
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
                
            % 35.) Pushbuttons "OK"  
            IconObj = JBttn(BBar.hnd,'ok','Insert Semantic Conditions');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.ButtonCbckSaveSemRel);
            obj.hData.jhb35         = IconObj.hnd;
            set(obj.hData.jhb35,'Enabled',false)
            
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(7);');
             
            % Parent     
            set(obj.hData.hp32,'Sizes',[23 23 23 23])
            
            % Table part
            % 28.) Panel Semantic Conditions           
            % 31) generating table in Semantic Conditions -
            tmp = BasicJTable(obj.hData.hb1,...
                {'Semantic Conditions'});
            obj.hData.Tables.mtable4 = tmp.hnd;
            obj.hData.Tables.jtable4 = tmp.jtable; 
            
            %Fix to MATLAB R2014 to use ValueChangedCallback-
            set(handle(obj.hData.Tables.jtable4.getSelectionModel,'CallbackProperties'),...
                    'ValueChangedCallback',@(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable4))      
            
           
            
            %% Sel. Constraints Design %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            set(obj.mainPanel,'SelectedChild',2)
            
            % 1.) Edit Panel Sel. Constraints
            obj.hData.hp1 = uiextras.VBox(...
                'Parent',               obj.hData.hb3,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Spacing',              5,...
                'Padding',              0,...
                'Visible',              'on'); 
            
            Grid = uiextras.Grid(...
                'Parent',               obj.hData.hp1,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Spacing',              0,...
                'Padding',              0);
            
            uiextras.Empty(...
                'Parent',               Grid,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            % 6a.) Icon Insert Source Node            
            IconObj = JBttn(Grid,'insert','Insert Source Node');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.InsertExtractNode(hobj,evt,'InsertSource'));
            obj.hData.jhb6a         = IconObj.hnd;
               
             
            uiextras.Empty(...
                'Parent',               Grid,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            % 9a.) Icon Insert Sink Nodes            
            IconObj = JBttn(Grid,'insert','Insert Sink Node');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.InsertExtractNode(hobj,evt,'InsertSink'));
            obj.hData.jhb9a         = IconObj.hnd;
                                
            
            % 5.) Text From
            BasicText(Grid,'From');
            
            % 4.) Edit Source Node
            tmp = BasicEdit(Grid,''); 
            obj.hData.hb4 = tmp.hnd;
            
            
            obj.hData.jhb4 = findjobj(obj.hData.hb4);
            set(obj.hData.jhb4,'Editable',false)
            obj.hData.jhb4caret = obj.hData.jhb4.getCaret;
            obj.hData.javacaretjhb4 = handle(obj.hData.jhb4caret,...
                    'CallbackProperties'); %because of memory leaks this is necessary and wont produce a warning
            
            % 8.) Text To
            BasicText(Grid,'To');
            
            % 7.) Edit Sink Nodes
            tmp = BasicEdit(Grid,''); 
            obj.hData.hb7 = tmp.hnd;
            
            %2.) % JEdit Edit Sink Nodes
            obj.hData.jhb7 = findjobj(obj.hData.hb7);
            set(obj.hData.jhb7,'Editable',false)
            obj.hData.jhb7caret = obj.hData.jhb7.getCaret;
            obj.hData.javacaretjhb7 = handle(obj.hData.jhb7caret,...
                    'CallbackProperties'); %because of memory leaks this is necessary and wont produce a warning
            
            
            uiextras.Empty(...
                'Parent',               Grid,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            uiextras.Empty(...
                'Parent',               Grid,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            uiextras.Empty(...
                'Parent',               Grid,...
                'BackgroundColor',      obj.Default.Color.BG_P);
                
            % 9b.) Icon Extract Sink Nodes
            IconObj = JBttn(Grid,'extract','Extract Sink Node');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.InsertExtractNode(hobj,evt,'ExtractSink'));
            obj.hData.jhb9b         = IconObj.hnd;
            
            
            %Parent
            set(Grid,'RowSizes', [23 23 23 23],'ColumnSizes',[30 -1 30])%[20 25 20 25]
            
            
            HB = uiextras.HBox(...
                'Parent',               obj.hData.hp1,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Spacing',              5,...
                'Padding',              5);            
            
            % 13.) Text Color
            BasicText(HB,'Color:');
                        
            % 15.) ColorPicker
            options = 6; 
            icon    = 0;
            obj.hData.jhb15 = javaObjectEDT('com.mathworks.mlwidgets.graphics.ColorPicker',options,icon,'');
            
            if verLessThan('matlab','8.4.0')
                UIP = uipanel(...
                    'Parent',                   HB,...
                    'BorderType',               'none',...
                    'BackgroundColor',          obj.Default.Color.BG_P);
                ppos = getpixelposition(UIP);
                pause(.2)
                
                [~,obj.hData.btContainer15] = javacomponent(obj.hData.jhb15,[0 0 ppos(3) ppos(4)],UIP);
                set(obj.hData.btContainer15,'Units','normalized');
                
            else
                [~,obj.hData.btContainer15] = javacomponent(obj.hData.jhb15,[0 0 1 1],HB);
            end
            set(obj.hData.btContainer15,...                    
                'BackgroundColor',      obj.Default.Color.BG_P);
                
            %Parent
            set(HB,'Sizes',[50 50])  
                        
            
            %some space
            uiextras.Empty('Parent',obj.hData.hp1);  
            
            
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp1);         
            
            % 10.) Icon add Selection Constraints 
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback',@(hobj,evt)obj.addRow( hobj,evt,'Selection Constraints'));
            obj.hData.jhb10 = IconObj.hnd;
            
                        
            % 11.) Icon delete Selection Constraint
            IconObj = JBttn(BBar.hnd,'del','Delete Selected Rows');
            set(IconObj.hnd,'MouseClickedCallback',@(hobj,evt)obj.deleteRow(hobj,evt,'Selection Constraints'));
            obj.hData.jhb11 = IconObj.hnd;
            
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 14.) Pushbuttons "OK"
            IconObj = JBttn(BBar.hnd,'ok','Insert Selection Constraint');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.ButtonCbckSaveSelCon);
            obj.hData.jhb14         = IconObj.hnd;            
            set(obj.hData.jhb14,'Enabled',false)    
            
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(8);');
                
            set(obj.hData.hp1,'Sizes',[120 40 23 25])
            
            
            % 12) generating table in Selection Constraints
            tmp = BasicJTable(obj.hData.hb3,...
                {'From','To'});
            obj.hData.Tables.mtable1 = tmp.hnd;
            obj.hData.Tables.jtable1 = tmp.jtable; 
            
            %Fix to MATLAB R2014 to use ValueChangedCallback-
            set(handle(obj.hData.Tables.jtable1.getSelectionModel,'CallbackProperties'),...
                    'ValueChangedCallback',@(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable1))
            
            
            % SES Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
            
            set(obj.mainPanel,'SelectedChild',3)
            
            % 21.) Panel Functions
            obj.hData.hp21 = uiextras.VBox(...
                'Parent',               obj.hData.hb3b,...                    
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Padding',              0,...
                'Spacing',              3,...
                'Visible',              'on');  
            
            % 26.) Panel Preview Functions
            % 27.) Edit Preview Window            
            obj.hData.hb27 = JEdit(obj.hData.hp21,'');
            set(obj.hData.hb27.parent,'Visible','off')
            obj.hData.hb27.jCodePane.disable();
            
            
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp21);     
            
             % Parent     
            set(obj.hData.hp21,'Sizes',[-1 23]) 
%             obj.Tabselcbk();
            
            % 22.) Icon add Function            
            IconObj = JBttn(BBar.hnd,'f_ad','Import Function');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.InsertFun);%@(hobj,evt)obj.addRow(hobj,evt,'Functions')
            obj.hData.jhb22 = IconObj.hnd;
            
             
            % 23.) Icon delete Function
            IconObj = JBttn(BBar.hnd,'f_de','Delete Function');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)obj.deleteRow(hobj,evt,'Functions'));
            obj.hData.jhb23 = IconObj.hnd;
                         
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 25.) Icon Insert Function 
            IconObj = JBttn(BBar.hnd,'f_up','Export Function(s)');
            set(IconObj.hnd,'MouseClickedCallback', @(hobj,evt)createSESFUN(obj));
            obj.hData.jhb25 = IconObj.hnd;
             
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(9);');
                
            % 24) generating table in Functions 
            tmp = BasicJTable(obj.hData.hb3b,...
                {'File Names'});
            obj.hData.Tables.mtable3 = tmp.hnd;
            obj.hData.Tables.jtable3 = tmp.jtable;  
            
            %Fix to MATLAB R2014 to use ValueChangedCallback
            set(handle(obj.hData.Tables.jtable3.getSelectionModel,'CallbackProperties'),...
                    'ValueChangedCallback',@(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable3))
            
           set(obj.mainPanel,'SelectedChild',1)

        end%constructor
        
        %% Icon Callback add Row %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function addRow( obj,~,~,Action)
            switch Action
                case 'Variables'
                    obj.addTableRow( obj.hData.Tables.mtable2 ,cell(1,2))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    Rows = obj.hData.Tables.jtable2.getRowCount;
                    obj.hData.Tables.jtable2.setRowSelectionInterval(Rows-1,Rows-1)
                    obj.parent.Ses.var = [obj.parent.Ses.var;cell(1,2)]; 
                case 'Functions'
                    obj.addTableRow( obj.hData.Tables.mtable3 ,cell(1))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    Rows = obj.hData.Tables.jtable3.getRowCount;
                    obj.hData.Tables.jtable3.setRowSelectionInterval(Rows-1,Rows-1)
                    newRow = struct('Filename','','Path','','Data',{''});
                    obj.parent.Ses.fcn = [obj.parent.Ses.fcn;newRow];  
                case 'Selection Constraints'
                    obj.addTableRow( obj.hData.Tables.mtable1 , cell(1,2))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    Rows = obj.hData.Tables.jtable1.getRowCount;
                    obj.hData.Tables.jtable1.setRowSelectionInterval(Rows-1,Rows-1)
                    obj.parent.Ses.Selection_Constraints.Pathes = [obj.parent.Ses.Selection_Constraints.Pathes;cell(1,2)]; 
                    obj.parent.Ses.Selection_Constraints.Color{end+1}= '#000000';
                case 'Semantic Conditions'
                    obj.addTableRow( obj.hData.Tables.mtable4 , cell(1,1))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    Rows = obj.hData.Tables.jtable4.getRowCount;
                    obj.hData.Tables.jtable4.setRowSelectionInterval(Rows-1,Rows-1)
                    obj.parent.Ses.Semantic_Conditions = [obj.parent.Ses.Semantic_Conditions;cell(1,1)]; 
            end%switch 
            
        end
        %% Icon Callback delete Row %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function deleteRow( obj,hobj,~,Action)
            switch Action
                case 'Variables'
                    RowCount = obj.hData.Tables.jtable2.getRowCount;
                    selRows = obj.hData.Tables.jtable2.getSelectedRows;
                    % avoid deleting variables that belong to multiaspect
                    allNodeObj = values(obj.parent.Ses.nodes);
                    maspVars = {};
                    for i=1:obj.parent.Ses.nodes.Count               
                        nextNode = allNodeObj{i};
                        if isa(nextNode,'maspect')
                            maspVars = [maspVars,nextNode.numRep];
                        end                
                    end
                    Data = get(obj.hData.Tables.mtable2,'Data');
                    newSelRows = selRows;
                    for i=length(selRows):-1:1
                        nextdelVar = Data(selRows(i)+1,1);
                        if ~isempty(nextdelVar{1})
                            if ismember(nextdelVar,maspVars)
                                newSelRows(i) = [];
                            end
                        end
                    end
                    selRows = newSelRows;
                    selRowCount = length(newSelRows);
                    if selRowCount == 0
                        obj.parent.InfoCenter.MSG('e',20,'');
                        return
                    end
                    %-
                    if RowCount-selRowCount == 0
                        obj.parent.Ses.var = cell(1,2);
                        set(obj.hData.Tables.mtable2,'Data',cell(1,2))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        obj.hData.Tables.jtable2.setRowSelectionInterval(0,0)
                    else
                        obj.parent.Ses.var(selRows+1,:) = [];
                        obj.deleteTableRow( obj.hData.Tables.mtable2,selRows + 1 )
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        if selRows(1)==0
                            obj.hData.Tables.jtable2.setRowSelectionInterval(selRows(1),selRows(1))
                        else
                            obj.hData.Tables.jtable2.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                        end
                    end
                    % update ObjNodes and Sem. Conditions after Variables or Functions have been deleted    
                    obj.parseStringContent            
                    % Update property window 
                    obj.parent.Props.UpdatePropertyWindow    
                    %--check if all descissions are made, if not color icon red-
                    allNodes = values(obj.parent.Ses.nodes);
                    obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                                   
                case 'Functions'
                    %wenn die funktionen zu gro� sind brauch das laden zu lange, wenn
                    %dann schnell gel�scht wird und die datei noch nicht vollst�ndig
                    %geladen ist gibt es eine fehlermeldung in zeile 1122 obj.parent.Ses.fcn(selRows+1,:) = [];
                    RowCount = obj.hData.Tables.jtable3.getRowCount;
                    selRows = obj.hData.Tables.jtable3.getSelectedRows;   
                    selRowCount = length(selRows);
                    
                    if RowCount-selRowCount == 0
                        obj.parent.Ses.fcn = cell(1);
                        obj.parent.Ses.fcn{1} = struct('Filename','','Path','','Data',{''});
                        set(obj.hData.Tables.mtable3,'Data',cell(1,1))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        obj.hData.Tables.jtable3.setRowSelectionInterval(0,0)
                    else
                        obj.parent.Ses.fcn(selRows+1,:) = [];
                        obj.deleteTableRow( obj.hData.Tables.mtable3,selRows + 1 )
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        if selRows(1)==0
                            obj.hData.Tables.jtable3.setRowSelectionInterval(selRows(1),selRows(1))
                        else
                            obj.hData.Tables.jtable3.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                        end
                    end                    
                    pause(.2)
                    
                    %% update ObjNodes and Sem. Conditions after Variables or Functions have been deleted    
                    obj.parseStringContent 
                    %% Update property window 
                    obj.parent.Props.UpdatePropertyWindow                
                case 'Selection Constraints'
                    selRowCount = obj.hData.Tables.jtable1.getSelectedRowCount;
                    if (get(hobj,'Enabled')==false) || (selRowCount==0)
                        return
                    end
                    RowCount = obj.hData.Tables.jtable1.getRowCount;
                    selRows = obj.hData.Tables.jtable1.getSelectedRows;
                    if RowCount-selRowCount == 0
                        obj.parent.Ses.Selection_Constraints.Pathes = cell(1,2);
                        set(obj.hData.Tables.mtable1,'Data',cell(1,2))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        obj.hData.Tables.jtable1.setRowSelectionInterval(0,0)
                        %these updates are important when only one row exist
                        % if curSelCon contains some nodes but you didnt save them, and finally
                        % delete the selected row, the insert/extract icons need a update
                        % Update Selection Constraints Window --
                        obj.UpdateSelConWindow('TableSelectionChanged')   
                        %-
                        % Update Selection Constraints Window --
                        obj.UpdateSelConWindow('TreeSelectionChanged')   
                        %-
                    else
                        obj.parent.Ses.Selection_Constraints.Pathes(selRows+1,:) = [];
                        obj.parent.Ses.Selection_Constraints.Color(selRows+1) = []; %Bug B.F. 08.09.2017
                        
                        obj.deleteTableRow( obj.hData.Tables.mtable1,selRows + 1 )
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        if selRows(1)==0
                            obj.hData.Tables.jtable1.setRowSelectionInterval(selRows(1),selRows(1))
                        else
                            obj.hData.Tables.jtable1.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                        end
                    end
                    obj.refreshTreeColors            
                    %--check if all descissions are made, if not color icon red-
                    allNodes = values(obj.parent.Ses.nodes);
                    obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                    %-            
                case 'Semantic Conditions'
                    selRowCount = obj.hData.Tables.jtable4.getSelectedRowCount;
                    if (get(hobj,'Enabled')==false) || (selRowCount==0)
                        return
                    end
                    RowCount = obj.hData.Tables.jtable4.getRowCount;
                    selRows = obj.hData.Tables.jtable4.getSelectedRows;
                    if RowCount-selRowCount == 0
                        obj.parent.Ses.Semantic_Conditions = cell(1,1);
                        set(obj.hData.Tables.mtable4,'Data',cell(1,1))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        obj.hData.Tables.jtable4.setRowSelectionInterval(0,0)               
                    else
                        obj.parent.Ses.Semantic_Conditions(selRows+1,:) = [];
                        obj.deleteTableRow( obj.hData.Tables.mtable4,selRows + 1 )
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        if selRows(1)==0
                            obj.hData.Tables.jtable4.setRowSelectionInterval(selRows(1),selRows(1))
                        else
                            obj.hData.Tables.jtable4.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                        end
                    end               
            end%switch  
            
        end
        %% Button Callback save Selection Constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ButtonCbckSaveSelCon( obj ) 
            if get(obj.hData.jhb14,'Enabled') == false
                return
            end
            selRow = obj.hData.Tables.jtable1.getSelectedRow; 
            if selRow ~=-1
                obj.parent.Ses.Selection_Constraints.Pathes(selRow+1,:) = obj.hData.curSelCon;
                Data = get(obj.hData.Tables.mtable1,'Data');
                Data{selRow+1,1} = get(obj.hData.hb4,'String');   % 4.) Edit Source Node
                Data{selRow+1,2} = get(obj.hData.hb7,'String');   % 7.) Edit Sink Nodes 
                %set Color
                colorVal = get(obj.hData.jhb15,'Value');    % 15.) ColorPicker
                
                if isempty(colorVal)||strcmp(colorVal,'none')
                    %reset color of TreeNodes
                    source = obj.parent.Ses.Selection_Constraints.Pathes{selRow+1,1};
                    sinks = obj.parent.Ses.Selection_Constraints.Pathes{selRow+1,2};
                    sourceNode = obj.parent.Ses.getTreeNode(source);
                    nodeName = obj.parent.Ses.getName(sourceNode);
                    sourceNode.setName(nodeName) 
                    for i=1:length(sinks)
                        sinkNode = obj.parent.Ses.getTreeNode(sinks{i});
                        nodeName = obj.parent.Ses.getName(sinkNode);
                        sinkNode.setName(nodeName)
                    end
                    obj.parent.Ses.Selection_Constraints.Color{selRow+1} = [];
                
                else %set Color
                    %get choosen color       
                    RGB = [get(colorVal,'Red'),get(colorVal,'Green'),get(colorVal,'Blue')];
                    colorfg = dec2hex(RGB,1);
                    if numel(colorfg)==3 %for color black
                        colorfg = [colorfg;colorfg]; 
                    end
                    colorfg = colorfg';
                    colorfg = ['#';colorfg(:)]';
                    obj.parent.Ses.Selection_Constraints.Color{selRow+1} = colorfg;
                    %set color of TreeNodes and table
                    source = obj.parent.Ses.Selection_Constraints.Pathes{selRow+1,1};
                    sinks = obj.parent.Ses.Selection_Constraints.Pathes{selRow+1,2};
                    sourceNode = obj.parent.Ses.getTreeNode(source);
                    nodeName = obj.parent.Ses.getName(sourceNode);
                    sourceNode.setName(strcat(['<html><span style="color: ' colorfg '; font-weight: bold;">'],nodeName))         
                    Data{selRow+1,1} = strcat(['<html><span style="color: ' colorfg '; font-weight: bold;">'],nodeName);
                    sinkNames = '';
                    for i=1:length(sinks)
                        sinkNode = obj.parent.Ses.getTreeNode(sinks{i});
                        nodeName = obj.parent.Ses.getName(sinkNode);
                        sinkNode.setName(strcat(['<html><span style="color: ' colorfg ';">'],nodeName)) 
                        sinkNames = [sinkNames,' , ',nodeName];
                    end
                    sinkNames = sinkNames(4:end);
                    Data{selRow+1,2} = strcat(['<html><span style="color: ' colorfg ';">'],sinkNames);
                end
                %update tree
                obj.parent.Hierarchy.hData.Trees.jtree1.treeDidChange();
                set(obj.hData.Tables.mtable1,'Data',Data) 
                pause(0.1)
                drawnow limitrate nocallbacks
                obj.hData.Tables.jtable1.setRowSelectionInterval(selRow,selRow)
                %--check if all descissions are made, if not color icon red-
                allNodes = values(obj.parent.Ses.nodes);
                obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                %-
            end
            
        end%function
        %% Button Callback save Semantic Conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ButtonCbckSaveSemRel( obj )
            if get(obj.hData.jhb35,'Enabled') == false  % 35.) Pushbuttons "OK" 
                return
            end        
            text = get(obj.hData.jhb34 ,'Text'); % 20.) Edit Set Varname   
            if isempty(text)
                %do nothing 
            else
                savedSemRels = get(obj.hData.Tables.mtable4,'Data');
                selRow = obj.hData.Tables.jtable4.getSelectedRow;
                savedSemRels(selRow+1,:) = [];
                savedSemRels(cellfun(@isempty,savedSemRels)) = [];
                SemRelExist = ismember(text,savedSemRels);
                if SemRelExist
%                     errordlg('Specified Condition already exist.','VarName Error'); 
                    obj.parent.InfoCenter.MSG('e',18,'');
                else
                    obj.parent.Ses.Semantic_Conditions{selRow+1} = text;
                    TableData = get(obj.hData.Tables.mtable4,'Data');
                    TableData{selRow+1} = text;
                    set(obj.hData.Tables.mtable4,'Data',TableData) 
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    obj.hData.Tables.jtable4.setRowSelectionInterval(selRow,selRow)
                end
            end
            
        end
        %% Button Callback save Variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ButtonCbckSaveVariable( obj,~,~) 
            if get(obj.hData.jhb20f,'Enabled') == false  % 20f.) Pushbuttons "OK" 
                return
            end        
            Varname = get(obj.hData.jhb20c,'Text');% 20c.) Edit Variable Name       
            VarValue = get(obj.hData.jhb20e,'Text');% 20c.) Edit Variable Value           
            selRow = obj.hData.Tables.jtable2.getSelectedRow;    
            oldVarName = obj.parent.Ses.var{selRow+1,1}; 
            % - change name of existing Variables --
            allNodeObj = values(obj.parent.Ses.nodes);
            for i=1:obj.parent.Ses.nodes.Count 
                nextNodeObj = allNodeObj{i};
                switch nextNodeObj.type
                    case 'Entity'
                    % Attributes - Entity -
                    Attributes = nextNodeObj.attributes;
                    for k=size(Attributes,1):-1:1
                        value = Attributes{k,2};
                        obj.parent.Parser.TranslationUnit(value,'AttributValue',obj.parent.Ses)
                        BezeichnerSy = tokens.VariableSy;
                        Attributes{k,2} = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,value);
                    end
                    nextNodeObj.attributes = Attributes;
                    case 'Spec'
                    % Specrule - Spec -- 
                    Specrule = nextNodeObj.specrule;
                    for k=size(Specrule,1):-1:1
                        condition = Specrule{k,2};
                        obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                        BezeichnerSy = tokens.VariableSy;
                        Specrule{k,2} = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,condition);
                    end
                    nextNodeObj.specrule = Specrule;
                    case 'Aspect'
                    % Aspectrule - Aspect -   
                    Aspectrule = nextNodeObj.aspectrule;
                    for k=size(Aspectrule,1):-1:1
                        condition = Aspectrule{k,2};
                        obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                        BezeichnerSy = tokens.VariableSy;
                        Aspectrule{k,2} = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,condition);
                    end
                    nextNodeObj.aspectrule = Aspectrule;
                    % Priority - Aspect 
                    priority = nextNodeObj.priority;
                    obj.parent.Parser.TranslationUnit(priority,'Priority',obj.parent.Ses)
                    BezeichnerSy = tokens.VariableSy;
                    nextNodeObj.priority = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,priority);
                    % Coupling - Aspect  
                    coupling = nextNodeObj.coupling;
                    if ischar(coupling)
                        obj.parent.Parser.TranslationUnit(coupling,'AnonymousFunction',obj.parent.Ses)
                        BezeichnerSy = tokens.VariableSy;
                        nextNodeObj.coupling = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,coupling);
                    end
                    case 'MAspect'
                    % Aspectrule - MAspect 
                    Aspectrule = nextNodeObj.aspectrule;
                    for k=size(Aspectrule,1):-1:1
                        condition = Aspectrule{k,2};
                        obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                        BezeichnerSy = tokens.VariableSy;
                        Aspectrule{k,2} = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,condition);
                    end
                    nextNodeObj.aspectrule = Aspectrule;
                    % Priority - MAspect 
                    priority = nextNodeObj.priority;
                    obj.parent.Parser.TranslationUnit(priority,'Priority',obj.parent.Ses)
                    BezeichnerSy = tokens.VariableSy;
                    nextNodeObj.priority = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,priority);
                    % Coupling - MAspect -- 
                    coupling = nextNodeObj.coupling;
                    if ischar(coupling)
                        obj.parent.Parser.TranslationUnit(coupling,'AnonymousFunction',obj.parent.Ses)
                        BezeichnerSy = tokens.VariableSy;
                        nextNodeObj.coupling = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,coupling);
                    end
                    % NumOfRep - MAspect -- 
                    numRep = nextNodeObj.numRep;
                    obj.parent.Parser.TranslationUnit(numRep,'Priority',obj.parent.Ses)
                    BezeichnerSy = tokens.VariableSy;
                    nextNodeObj.numRep = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,numRep);
                    % 
                end
                
            end
            % Update Semantic Conditions  
            SemConditions = obj.parent.Ses.Semantic_Conditions;
            for k=size(SemConditions,1):-1:1
                condition = SemConditions{k};
                obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                BezeichnerSy = tokens.VariableSy;
                SemConditions{k} = obj.parent.Parser.replaceSymValues(oldVarName,Varname,BezeichnerSy,condition);
            end
            obj.parent.Ses.Semantic_Conditions = SemConditions;
            % change Semantic Conditions Table --
            selRowSR = obj.hData.Tables.jtable4.getSelectedRows;
            set(obj.hData.Tables.mtable4,'Data',SemConditions)
            pause(0.1)
            drawnow limitrate nocallbacks
            obj.hData.Tables.jtable4.setRowSelectionInterval(selRowSR(1),selRowSR(end))
            % change SES Variables Table 
            Data = get(obj.hData.Tables.mtable2,'Data');
            newTableRow = {Varname,VarValue};
            obj.parent.Ses.var(selRow+1,:) = newTableRow;
            Data(selRow+1,:) = newTableRow;
            set(obj.hData.Tables.mtable2,'Data',Data) 
            pause(0.1)
            drawnow limitrate nocallbacks
            obj.hData.Tables.jtable2.setRowSelectionInterval(selRow,selRow)  
            obj.parent.Props.UpdatePropertyWindow
        end%function
        
        %% Button Callback save Function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function InsertFun( obj ) 
            [Filename,Path] = uigetfile({'*m','Code files(*.m)'});
            if Filename == 0 %click on cancel button
                return
            end
                              
            selRow = obj.hData.Tables.jtable3.getSelectedRow;
            Data = get(obj.hData.Tables.mtable3,'Data');
                    
          
            Datacmp = Data;            
            Datacmp(cellfun(@isempty,Datacmp)) = [];            
            if ismember(Filename,Datacmp)
                %Function already imported!
                obj.parent.InfoCenter.MSG('e',17,'');
                return
            end 

                        
            if ~isempty(Data{selRow+1})
                obj.addRow([],[],'Functions')
                selRow = obj.hData.Tables.jtable3.getSelectedRow;
            end
            
            
            %read file and transform it to cell array    
            str = fileread([Path,Filename]);
            funData = regexp(str,'\t|\n','split'); %
            funData = funData';
            obj.parent.Ses.fcn{selRow+1}.Filename = Filename;
            obj.parent.Ses.fcn{selRow+1}.Path = Path;
            obj.parent.Ses.fcn{selRow+1}.Data = funData;
            Data{selRow+1,1} = Filename;
            set(obj.hData.Tables.mtable3,'Data',Data)
            pause(0.1)
            drawnow limitrate nocallbacks
            obj.hData.Tables.jtable3.setRowSelectionInterval(selRow,selRow)      
            obj.Selectioncbck([],[],obj.hData.Tables.jtable3)
            
            
        end%function
        
        %% SelectionChangeFcn Tables in Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function Selectioncbck(obj,~,~,jtable)
            obj.hData.Comment.setText(obj.parent.Ses.comment);
            if jtable.equals(obj.hData.Tables.jtable1) %Selection Constraints
                selRowCount = size(jtable.getSelectedRows,1);
                if selRowCount > 1
                    set(obj.hData.hb4,	 'String',{''})   %  4.) Edit Source Node
                    set(obj.hData.hb7,   'String',{''})   %  7.) Edit Sink Nodes
                    set(obj.hData.jhb14, 'Enabled',false) % 14.) Pushbuttons "OK"
                    set(obj.hData.jhb15, 'Enabled',false) % 15.) ColorPicker
                    set(obj.hData.jhb6a, 'Enabled',false) % 6a.) Icon Insert Source Node
                    set(obj.hData.jhb9a, 'Enabled',false) % 9a.) Icon Insert Sink Node
                    set(obj.hData.jhb9b, 'Enabled',false) % 9b.) Icon Extract Sink Node
                else
                    obj.UpdateSelConWindow('TableSelectionChanged')
                    obj.UpdateSelConWindow('TreeSelectionChanged')
                end 
                
            elseif jtable.equals(obj.hData.Tables.jtable2) %Variables
                selRowCount = size(jtable.getSelectedRows,1);
                if selRowCount > 1                       
                    set(obj.hData.hb20e, 'Enable','off')  % 20e.) Edit Variable Value
                    set(obj.hData.hb20c, 'Enable','off')  % 20c.) Edit Variable Name
                    set(obj.hData.jhb20f,'Enabled',false) % 20f.) Pushbuttons "OK"  
                    set(obj.hData.hb20c, 'String','')     % 20c.) Edit Variable Name
                    set(obj.hData.hb20e, 'String','')     % 20c.) Edit Variable Value
                    pause(0.1)
                    drawnow limitrate nocallbacks
                elseif selRowCount == 1
                    Data = get(obj.hData.Tables.mtable2,'Data');
                    selRow = obj.hData.Tables.jtable2.getSelectedRow;
                    set(obj.hData.hb20e,'Enable','on')             % 20e.) Edit Variable Value
                    set(obj.hData.hb20c,'Enable','on')             % 20c.) Edit Variable Name
                    set(obj.hData.hb20e,'String',Data{selRow+1,2}) % 20e.) Edit Variable Value   
                    set(obj.hData.hb20c,'String',Data{selRow+1,1}) % 20c.) Edit Variable name   
                    %            obj.checkSetting([],[],'Variables')
                end
                
            elseif jtable.equals(obj.hData.Tables.jtable3) %Functions  
                selRowCount = size(jtable.getSelectedRows,1);
                if selRowCount > 1 
                    set(obj.hData.jhb25,...
                        'Enabled',  false) % 25.) Icon Insert Function 
                    set(obj.hData.hb27.parent,...
                        'Visible',  'off')  % 27.) Edit Preview Window
                    %              pause(0.1)    
                    drawnow limitrate nocallbacks
                elseif selRowCount == 1
                    selRow = jtable.getSelectedRow;
                    Data = get(obj.hData.Tables.mtable3,'Data');
                    if isempty(Data{selRow+1})
                        set(obj.hData.jhb25,...
                            'Enabled',  true) % 25.) Icon Insert Function 
                        set(obj.hData.hb27.parent,...
                            'Visible',  'off') % 27.) Edit Preview Window
                    else
                        set(obj.hData.jhb25,...
                            'Enabled',  true) % 25.) Icon Insert Function 
                        set(obj.hData.hb27.parent,...
                            'Visible',  'on')  % 27.) Edit Preview Window
                        FunData = obj.parent.Ses.fcn{selRow+1}.Data;                        
                        set(obj.hData.hb27.jCodePane,'Text',sprintf('%s\n',FunData{:}))
                    end
                end
                
            elseif jtable.equals(obj.hData.Tables.jtable4) %Semantic Conditions
                selRowCount = size(jtable.getSelectedRows,1);
                if selRowCount > 1 
                    set(obj.hData.hb34,...
                        'Enable',   'off')   % 34.) Edit Set Semantic Conditions
                    set(obj.hData.hb34,...
                        'String',   '')      % 34.) Edit Set Semantic Conditions
                    set(obj.hData.jhb35,...
                        'Enabled',  false) % 35.) Pushbuttons "OK"
                    pause(0.1) 
                    drawnow limitrate nocallbacks
                elseif selRowCount == 1
                    Data = get(obj.hData.Tables.mtable4,'Data');
                    selRow = obj.hData.Tables.jtable4.getSelectedRow;         
                    set(obj.hData.hb34,...
                        'Enable',   'on',...
                        'String',   Data{selRow+1}) % 34.) Edit Set Semantic Conditions                     
                                   
                    obj.checkSetting([],[],'Semantic Conditions')
                end
            end
            
        end%function
        
        %% ReturnKeyFcn for Semantic Conditions and for Variables %%%%%%%%%%%
        function ReturnKeyCallback(obj,~,evt,action)
            if strcmp(evt.Key,'return')   
                switch action
                    case 'Semantic Conditions'
                    obj.ButtonCbckSaveSemRel
                    case 'Variables'
                    obj.ButtonCbckSaveVariable     
                end
            end
        end%function   
        
        %% checkSetting Callback -> check if selected Setting is ok for Input %%%%%
        function checkSetting(obj,~,~,action)
            switch action
                case 'Semantic Conditions'
                text = get(obj.hData.jhb34,'Text');   % 34.) Edit Set Semantic Conditions        
                obj.parent.Parser.TranslationUnit(text,'Condition',obj.parent.Ses)
                SemRelOK = ~obj.parent.Parser.Error;        
                if SemRelOK
                    set(obj.hData.jhb35,'Enabled',true)
                else
                    set(obj.hData.jhb35,'Enabled',false)
                end
                case 'Variables'
                name = get(obj.hData.jhb20c,'Text');   % 20e.) Edit Variable Value 
                Data = get(obj.hData.Tables.mtable2,'Data');
                savedVarnames = Data(:,1);
                selRow = obj.hData.Tables.jtable2.getSelectedRow;
                savedVarnames(selRow+1,:) = [];
                savedVarnames(cellfun(@isempty,savedVarnames)) = [];  %delete empty cell entries
                VarExist = ismember(name,savedVarnames);
                nameOK = isvarname(name) && ~VarExist;        
                value = get(obj.hData.jhb20e,'Text'); % 20e.) Edit Variable Name      
                obj.parent.Parser.TranslationUnit(value,'AttributValue',obj.parent.Ses)
                ValueOK = ~obj.parent.Parser.Error;        
                %check if variable depends on itself
                varName = get(obj.hData.jhb20c,'Text');   % 20c.) Edit Variable Name
                SymList = obj.parent.Parser.SymList;
                for i = 1:length(SymList)
                    nextSym = SymList(i);
                    if nextSym.Token == tokens.VariableSy
                        if strcmp(nextSym.Wert,varName)
                            ValueOK = false;
                            break
                        end
                    end
                end
                if ValueOK && nameOK
                    set(obj.hData.jhb20f,'Enabled',true) % 20f.) Pushbuttons "OK"
                else
                    set(obj.hData.jhb20f,'Enabled',false)
                end
            end
            
        end%function
        %% parse nodes and Semantic Conditions -> if text not valid anymore 
        % -> delete specified Content %%%
        function parseStringContent(obj)
            %% update ObjNodes after Variables or Functions have been deleted 
            allObjNodes = values(obj.parent.Ses.nodes);
            for i=1:obj.parent.Ses.nodes.Count
                nextNodeObj = allObjNodes{i};
                switch nextNodeObj.type
                    case 'Entity'
                    % Attributes - Entity -
                    Attributes = nextNodeObj.attributes;
                    for k=size(Attributes,1):-1:1
                        value = Attributes{k,2};
                        obj.parent.Parser.TranslationUnit(value,'AttributValue',obj.parent.Ses)
                        SymList = obj.parent.Parser.SymList;
                        for kk=1:length(SymList)
                            nextSym = SymList(kk);
                            if nextSym.Token == tokens.UnknownSy
                                Attributes{k,2} = [];
                                break
                            end
                        end
                    end
                    nextNodeObj.attributes = Attributes;  
                    case 'Spec'
                    % Specrule - Spec --
                    Specrule = nextNodeObj.specrule;
                    for k=size(Specrule,1):-1:1
                        condition = Specrule{k,2};
                        obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                        SymList = obj.parent.Parser.SymList;
                        for kk=1:length(SymList)
                            nextSym = SymList(kk);
                            if nextSym.Token == tokens.UnknownSy
                                Specrule(k,:) = [];
                                break
                            end
                        end
                    end
                    if isempty(Specrule)
                        Specrule = cell(1,2);
                    end
                    nextNodeObj.specrule = Specrule; 
                    case {'Aspect','MAspect'}
                    % Aspectrule - Aspect -
                    Aspectrule = nextNodeObj.aspectrule;
                    for k=size(Aspectrule,1):-1:1
                        condition = Aspectrule{k,2};
                        obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                        SymList = obj.parent.Parser.SymList;
                        for kk=1:length(SymList)
                            nextSym = SymList(kk);
                            if nextSym.Token == tokens.UnknownSy
                                Aspectrule(k,:) = [];
                                break
                            end
                        end
                    end
                    if isempty(Aspectrule)
                        Aspectrule = cell(1,2);
                    end
                    nextNodeObj.aspectrule = Aspectrule; 
                    % Coupling - Aspect 
                    %parse only if function is choosen for coupling
                    Coupling = nextNodeObj.coupling;
                    if ischar(Coupling)
                        obj.parent.Parser.TranslationUnit(Coupling,'AnonymousFunction',obj.parent.Ses);
                        SymList = obj.parent.Parser.SymList;
                        for kk=1:length(SymList)
                            nextSym = SymList(kk);
                            if nextSym.Token == tokens.UnknownSy
                                switch nextNodeObj.type
                                    case 'Aspect'
                                    Coupling = cell(1,4);
                                    case 'MAspect'
                                    intEnd = nextNodeObj.interval(2);
                                    Coupling = cell(1,intEnd);
                                    Coupling = cellfun(@(x) cell(1,4),Coupling,'UniformOutput',false);
                                end
                                break
                            end
                        end
                        nextNodeObj.coupling = Coupling;    
                    end
                end
            end  
            %check Semantic Conditions --
            SemConditions = obj.parent.Ses.Semantic_Conditions;
            for k=size(SemConditions,1):-1:1
                condition = SemConditions{k};
                obj.parent.Parser.TranslationUnit(condition,'Condition',obj.parent.Ses)
                SymList = obj.parent.Parser.SymList;
                for kk=1:length(SymList)
                    nextSym = SymList(kk);
                    if nextSym.Token == tokens.UnknownSy
                        Aspectrule(k) = [];
                        break
                    end
                end
            end
            if isempty(SemConditions)
                SemConditions = cell(1,2);
            end
            obj.parent.Ses.Semantic_Conditions = SemConditions; 
            
        end%function
        %% Icon Callback Insert/Extract Node to Source/Sink %%%%%%%%%%%%%%%%%%%%%%%
        function InsertExtractNode(obj,hobj,~,Action)       
            if get(hobj,'Enabled')==false
                return
            end
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            switch Action
                case 'InsertSource'
                set(obj.hData.hb4,'String',char(obj.getName(selNode)))   % 4.) Edit Source Node
                obj.hData.curSelCon{1} = obj.parent.Ses.getTreepath(selNode);
                set(obj.hData.hb7,'String',{''})   % 7.) Edit Sink Nodes 
                obj.hData.curSelCon{2} = cell(0);
                set(obj.hData.jhb14,'Enabled',false)  % 14.) Pushbuttons "OK"   
                case 'InsertSink'
                str = get(obj.hData.hb7,'String');                     
                if ~ischar(str)
                    EditSink = char(obj.getName(selNode));
                    obj.hData.curSelCon{2} = {obj.parent.Ses.getTreepath(selNode)}; 
                else
                    EditSink = [get(obj.hData.hb7,'String'),' , ',char(obj.getName(selNode))];
                    obj.hData.curSelCon{2} = [obj.hData.curSelCon{2},obj.parent.Ses.getTreepath(selNode)]; 
                end
                set(obj.hData.hb7,'String',EditSink)   % 7.) Edit Sink Nodes  
                set(obj.hData.jhb14,'Enabled',true)  % 14.) Pushbuttons "OK"                     
                case 'ExtractSink'
                selTP = obj.parent.Ses.getTreepath(selNode);
                L = strcmp(selTP,obj.hData.curSelCon{2});
                obj.hData.curSelCon{2}(L) = [];
                names = cellfun(@(x)obj.parent.Ses.getNameFromPath(x),obj.hData.curSelCon{2},'UniformOutput',false);
                EditSink = [];
                for i=1:length(names)
                    EditSink = [EditSink,' , ',names{i}];
                end
                EditSink = EditSink(4:end);
                if isempty(EditSink)
                    EditSink = {''};
                    set(obj.hData.jhb14,'Enabled',false)  % 14.) Pushbuttons "OK" 
                else
                    set(obj.hData.jhb14,'Enabled',true)  % 14.) Pushbuttons "OK" 
                end
                set(obj.hData.hb7,'String',EditSink)   % 7.) Edit Sink Nodes              
            end
            % Update the List of selectable Node for Selection Constraints 
            obj.parent.Settings.getListOfSelectableNodes  
            %-            
            obj.UpdateSelConWindow('TreeSelectionChanged')
            
        end%function
        %% Update Sel. Constr. Window when selected Row in table has changed %%%%%%
        function UpdateSelConWindow(obj,Action)
            switch Action
                case 'TableSelectionChanged'
                selRow = obj.hData.Tables.jtable1.getSelectedRow;
                %update Edits 
                Data = get(obj.hData.Tables.mtable1,'Data');
                if selRow ~= -1
                    try
                        htmlpart = strfind(Data(selRow+1,:),'>'); 
                        htmlpart = cellfun(@(x)x(end),htmlpart,'UniformOutput',false);
                        htmlpart = cell2mat(htmlpart);
                        sourceData = Data{selRow+1,1};
                        sinkData = Data{selRow+1,2};
                        DataRow = {sourceData(htmlpart(1)+1:end),sinkData(htmlpart(2)+1:end)};
                        set(obj.hData.hb4,'String',DataRow{1})   % 4.) Edit Source Node
                        set(obj.hData.hb7,'String',DataRow{2})   % 7.) Edit Sink Nodes
                        %set ColorPicker Value
                        colorpart = strfind(Data{selRow+1,1},'#');
                        colorpart = Data{selRow+1,1}(colorpart+1:colorpart+6);
                        colHex = [colorpart(1:2);colorpart(3:4);colorpart(5:6)];
                        colDec = hex2dec(colHex);
                        col = colDec/255;
                        obj.hData.jhb15.setValue(java.awt.Color(col(1),col(2),col(3))) % 15.) ColorPicker
                    catch
                        set(obj.hData.hb4,'String',Data{selRow+1,1})   % 4.) Edit Source Node
                        set(obj.hData.hb7,'String',Data{selRow+1,2})   % 7.) Edit Sink Nodes
                        obj.hData.jhb15.setValue([])
                    end
                    set(obj.hData.jhb15,'Enabled',true);  % 15.) ColorPicker
                    %  load curent Selected Constraint (curSelCon)
                    if isempty(Data{selRow+1,2})
                        obj.hData.curSelCon = cell(1,2);
                        set(obj.hData.jhb14,'Enabled',false)  % 14.) Pushbuttons "OK"
                    else
                        selCons = obj.parent.Ses.Selection_Constraints.Pathes;
                        obj.hData.curSelCon = selCons(selRow+1,:); 
                        set(obj.hData.jhb14,'Enabled',true)  % 14.) Pushbuttons "OK"
                    end
                    obj.getListOfSelectableNodes
                end 
                case 'TreeSelectionChanged'
                    selRow = obj.hData.Tables.jtable1.getSelectedRow;
                    if selRow == -1
                        return
                    end
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                if ~selNode.isRoot
                    [Treepath] = obj.parent.Ses.getTreepath(selNode);
                    InsertSource = ismember(Treepath,obj.hData.List1);
                    InsertSink = ismember(Treepath,obj.hData.List2);
                    ExtractSink = ismember(Treepath,obj.hData.List3);
                    if InsertSource
                        set(obj.hData.jhb6a,'Enabled',true)  % 6a.) Icon Insert Source Node
                    else
                        set(obj.hData.jhb6a,'Enabled',false)  % 6a.) Icon Insert Source Node
                    end
                    if InsertSink
                        set(obj.hData.jhb9a,'Enabled',true)  % 9a.) Icon Insert Sink Node
                    else
                        set(obj.hData.jhb9a,'Enabled',false)  % 9a.) Icon Insert Sink Node
                    end
                    if ExtractSink
                        set(obj.hData.jhb9b,'Enabled',true)  % 9b.) Icon Extract Sink Node
                    else
                        set(obj.hData.jhb9b,'Enabled',false)  % 9b.) Icon Extract Sink Node
                    end
                else %selNode is Root -> disable all insert/extract icons
                    set(obj.hData.jhb6a,'Enabled',false)  % 6a.) Icon Insert Source Node
                    set(obj.hData.jhb9a,'Enabled',false)  % 9a.) Icon Insert Sink Node
                    set(obj.hData.jhb9b,'Enabled',false)  % 9b.) Icon Extract Sink Node
                end  
            end%switch
            
        end%function
        %% generate List of selectable Nodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function getListOfSelectableNodes( obj )
            %Documentation:
            %List1: 'Insertable Source Nodes' -> newSelectionSource
            %List2: 'Insertable Sink Nodes' -> fourthSelection
            %List3: 'Extractable Sink Nodes' -> consist of all pathes that are saved in curSelCon{2}
            % allTreepathes - create cell array that contains all treepathes that exist
            NodeCount = obj.parent.Ses.nodes.Count;
            allTreepathes = cell(1,NodeCount);
            nodeobjects = values(obj.parent.Ses.nodes);
            for i=1:NodeCount
                allTreepathes{i} = nodeobjects{i}.treepath;    
            end
            % sourceSelection - eliminate nodes that exist in selection constraints or in curSelCon
            secondSelection = {};
            selRow = obj.hData.Tables.jtable1.getSelectedRow;
            savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
            if selRow ~= -1
                savedSelCons(selRow+1,:) = []; %Exeption:selected Row shouldnt be part of nonselectable pathes
            end
            currentSelCon = obj.hData.curSelCon;
            %add Source Treepathes
            allSelCons = [savedSelCons(:,1);currentSelCon(1)]';
            %add Sink Treepathes
            for i=1:size(savedSelCons,1)   
                allSelCons = [allSelCons,savedSelCons{i,2}];    
            end
            % allSelCons = [allSelCons,currentSelCon{2}];
            allSelCons(cellfun(@isempty,allSelCons)) = [];  %delete empty cell entries
            for i=1:length(allTreepathes)
                curPath = allTreepathes{i};
                pathExist = ismember(curPath,allSelCons);
                if ~pathExist
                    secondSelection = [secondSelection,curPath];
                end
            end            
            % from here only for Sink node List
            % 
            %insert sink node only if a source node is inserted
            if ~isempty(obj.hData.curSelCon{1})
                %% secondSelectionSink -  eliminate nodes that exist in selection constraints Sources or in CurSelCon{1}
                secondSelectionSink = {};
                selRow = obj.hData.Tables.jtable1.getSelectedRow;
                savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
                if selRow ~=-1
                    savedSelCons(selRow+1,:) = []; %Exception:selected Row shouldnt be part of nonselectable pathes
                end
                currentSelCon = obj.hData.curSelCon;
                %add Source Treepathes
                allSelCons = [savedSelCons(:,1);currentSelCon(1)]';
                allSelCons(cellfun(@isempty,allSelCons)) = [];  %delete empty cell entries
                for i=1:length(allTreepathes)
                    curPath = allTreepathes{i};
                    pathExist = ismember(curPath,allSelCons);
                    if ~pathExist
                        secondSelectionSink = [secondSelectionSink,curPath];
                    end
                end
                % secondSelection2 - like secondSelection but also contains curSelCon{2} important for sink nodes
                allSelCons = [cell(0),currentSelCon{2}];
                allSelCons(cellfun(@isempty,allSelCons)) = [];  %delete empty cell entries
                secondSelection2 = {};
                for i=1:length(secondSelectionSink)
                    curPath = secondSelectionSink{i};
                    pathExist = ismember(curPath,allSelCons);
                    if ~pathExist
                        secondSelection2 = [secondSelection2,curPath];
                    end
                end
                % firstSelection - pick nodes that are eighter entities under specs or an Aspect-Sibling
                % later normal Aspects are also allowed to pick
                firstSelection = {};
                for i=1:length(secondSelection2)
                    curPath = secondSelection2{i};
                    [treenode] = obj.parent.Ses.getTreeNode(curPath);
                    %     nodeobj = obj.parent.Ses.nodes(curPath);
                    nodeType = obj.parent.Ses.getType(treenode);
                    parentType = obj.parent.Ses.getType(treenode.getParent);
                    if strcmp(parentType,'Spec')
                        firstSelection = [firstSelection,curPath];
                    elseif strcmp(nodeType,'Aspect') || strcmp(nodeType,'MAspect')
                        %find AspectNodes in Siblings
                        Siblings = treenode.getParent.children;
                        AspCount = 0;
                        while Siblings.hasMoreElements
                            curNode = Siblings.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                            node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                AspCount = AspCount + 1;
                            end
                        end
                        if AspCount > 1
                            firstSelection = [firstSelection,curPath];
                        end
                    end
                end
                % thirdSelection - eliminate nodes that share the same Spec node ancestor as the source or the other sinks
                thirdSelection = {};
                sourcePath = obj.hData.curSelCon{1};
                %-
                otherSinkPathes = obj.hData.curSelCon{2};
                allPathes = [sourcePath,otherSinkPathes];
                allSpecPathesSource = {};
                for i=1:length(allPathes)
                    %-
                    sourceNode = obj.parent.Ses.getTreeNode(allPathes{i});
                    RootPathSourceNode = sourceNode.pathFromAncestorEnumeration(sourceNode.getRoot.getFirstChild);
                    %find all Spec Node Ancestors and save their treepathes
                    while RootPathSourceNode.hasMoreElements
                        nextNode = RootPathSourceNode.nextElement;
                        nextNodeType = obj.parent.Ses.getType(nextNode);
                        if strcmp(nextNodeType,'Spec')
                            allSpecPathesSource = [allSpecPathesSource,obj.parent.Ses.getTreepath(nextNode)];
                        end       
                    end
                end
                for i=1:length(firstSelection)
                    curPath = firstSelection{i};
                    [treenode] = obj.parent.Ses.getTreeNode(curPath);
                    RootPathSelNode = treenode.pathFromAncestorEnumeration(treenode.getRoot.getFirstChild);
                    allSpecPathesSel = {};  %all treepathes from selectable spec node ancestors
                    while RootPathSelNode.hasMoreElements
                        nextNode = RootPathSelNode.nextElement;
                        nodeType = obj.parent.Ses.getType(nextNode);
                        if strcmp(nodeType,'Spec')
                            allSpecPathesSel = [allSpecPathesSel,obj.parent.Ses.getTreepath(nextNode)];
                        end       
                    end
                    %if no true exist -> source and curPath don�t share the same ancestor
                    if sum(ismember(allSpecPathesSource,allSpecPathesSel)) == 0
                        thirdSelection = [thirdSelection,curPath];
                    end
                end
                % fourthSelection - eliminate nodes that share the same M(Aspect)Sibling ancestor as the source
                fourthSelection = {};
                allEntPathesSource = {};
                for i=1:length(allPathes)
                    sourceNode = obj.parent.Ses.getTreeNode(allPathes{i});
                    RootPathSourceNode = sourceNode.pathFromAncestorEnumeration(sourceNode.getRoot.getFirstChild);        
                    %find all Ent Node Ancestors and save their treepathes if AspCount>1
                    while RootPathSourceNode.hasMoreElements
                        nextNode = RootPathSourceNode.nextElement;
                        nextNodeType = obj.parent.Ses.getType(nextNode);
                        if strcmp(nextNodeType,'Aspect') || strcmp(nextNodeType,'MAspect')
                            %find AspectNodes in children
                            Siblings = nextNode.getParent.children;
                            AspCount = 0;
                            while Siblings.hasMoreElements
                                curNode = Siblings.nextElement;
                                [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                                node = obj.parent.Ses.nodes(Treepath);
                                if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                    AspCount = AspCount + 1;
                                end
                            end
                            if AspCount > 1
                                allEntPathesSource = [allEntPathesSource,obj.parent.Ses.getTreepath(nextNode.getParent)];
                            end
                        end       
                    end
                end   
                for i=1:length(thirdSelection)
                    curPath = thirdSelection{i};
                    [treenode] = obj.parent.Ses.getTreeNode(curPath);
                    RootPathSelNode = treenode.pathFromAncestorEnumeration(treenode.getRoot.getFirstChild);
                    allEntPathesSel = {};  %all treepathes from selectable Ent node ancestors
                    while RootPathSelNode.hasMoreElements
                        nextNode = RootPathSelNode.nextElement;
                        nextNodeType = obj.parent.Ses.getType(nextNode);
                        if strcmp(nextNodeType,'Aspect') || strcmp(nextNodeType,'MAspect')
                            %find AspectNodes in children
                            Siblings = nextNode.getParent.children;
                            AspCount = 0;
                            while Siblings.hasMoreElements
                                curNode = Siblings.nextElement;
                                [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                                node = obj.parent.Ses.nodes(Treepath);
                                if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                    AspCount = AspCount + 1;
                                end
                            end
                            if AspCount > 1
                                allEntPathesSel = [allEntPathesSel,obj.parent.Ses.getTreepath(nextNode.getParent)];
                            end
                        end       
                    end
                    %if no true exist -> source and curPath don�t share the same Entity ancestor
                    if sum(ismember(allEntPathesSource,allEntPathesSel)) == 0
                        fourthSelection = [fourthSelection,curPath];
                    end
                end
                % sinkSelection - Eliminate Nodes that are already specified in previous Rule
                selection = fourthSelection;
                sinkSelection = {};
                for i=1:length(selection)
                    nextNode = obj.parent.Ses.nodes(selection{i});
                    switch nextNode.type
                        case 'Entity'
                        [ParentPath] = nextNode.getParentPath;
                        SpecParent = obj.parent.Ses.nodes(ParentPath);
                        SelectableChildren = SpecParent.specrule(:,1);
                        SelectableChildren(cellfun(@isempty,SelectableChildren)) = [];  %delete empty cell entries
                        if ~ismember(nextNode.name,SelectableChildren)
                            sinkSelection = [sinkSelection,selection{i}];
                        end
                        case {'Aspect','MAspect'}
                        SelectableSibs = nextNode.aspectrule(:,1);
                        SelectableSibs(cellfun(@isempty,SelectableSibs)) = [];  %delete empty cell entries
                        if ~ismember(nextNode.name,SelectableSibs)
                            sinkSelection = [sinkSelection,selection{i}];
                        end
                    end
                end                
            else %no source node was inserted -> List2 is empty
                sinkSelection = {};  
            end
            % generate Output Lists
            % obj.hData.List1 = newSelectionSource;
            obj.hData.List1 = secondSelection;
            % obj.hData.List2 = fifthSelection;
            obj.hData.List2 = sinkSelection;
            obj.hData.List3 = obj.hData.curSelCon{2};
            % obj.hData.List3(cellfun(@isempty,obj.hData.List3)) = [];
            
        end%function List of selectable Node
        %% Update of saved Sel. Constr. after Tree structure changed %%%%%%%%%%%%%%
        function UpdateSelConAfterTreeChange( obj,Action,newNode,oldName )
            savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
            NodeCount = obj.parent.Ses.nodes.Count;
            NodeObjs = values(obj.parent.Ses.nodes);
            switch Action
                case 'Rename'
                % rename case
                Level = newNode.getLevel;
                IsLeaf = newNode.isLeaf;
                newName = obj.parent.Ses.getName(newNode);
                sources = obj.parent.Ses.Selection_Constraints.Pathes(:,1);
                sinks = obj.parent.Ses.Selection_Constraints.Pathes(:,2);
                rows = length(sources);
                for i=1:rows
                    if Level==1 %rename the root
                        %check sources whether old name exist
                        curSource = sources{i};
                        oldNameExist = strncmp(curSource,[oldName,'/'],length(oldName)+1);
                        if oldNameExist
                            newPath = curSource(length(oldName)+1:end);
                            newPath = [newName,newPath];
                            obj.parent.Ses.Selection_Constraints.Pathes{i,1} = newPath;
                        end
                        %check sinks whether old name exist
                        curSinks = sinks{i};
                        for k=1:length(curSinks)            
                            nextSink = curSinks{k};
                            oldNameExist = strncmp(nextSink,[oldName,'/'],length(oldName)+1);
                            if oldNameExist
                                newPath = nextSink(length(oldName)+1:end);
                                newPath = [newName,newPath];
                                obj.parent.Ses.Selection_Constraints.Pathes{i,2}{k} = newPath;
                            end             
                        end
                    elseif IsLeaf
                        %check sources whether old name exist
                        curSource = sources{i};
                        if ~isempty(curSource)
                            oldNameExist = strcmp(curSource(end-(length(oldName)):end) , ['/',oldName]);
                            if oldNameExist
                                newPath = curSource(1:end-(length(oldName)));
                                newPath = [newPath,newName];
                                obj.parent.Ses.Selection_Constraints.Pathes{i,1} = newPath;
                            end
                            %check sinks whether old name exist
                            curSinks = sinks{i};
                            for k=1:length(curSinks)            
                                nextSink = curSinks{k};
                                oldNameExist = strcmp(nextSink(end-(length(oldName)):end) , ['/',oldName]);
                                if oldNameExist
                                    newPath = nextSink(1:end-(length(oldName)));
                                    newPath = [newPath,newName];
                                    obj.parent.Ses.Selection_Constraints.Pathes{i,2}{k} = newPath;
                                end             
                            end
                        end%if ~empty
                    else %inner node
                        %check sources whether old name exist
                        curSource = sources{i};
                        if ~isempty(curSource)
                            newPath = regexprep(curSource,['/',oldName,'/'],['/',newName,'/']);
                            obj.parent.Ses.Selection_Constraints.Pathes{i,1} = newPath;
                        end
                        %check sinks whether old name exist
                        curSinks = sinks{i};
                        for k=1:length(curSinks)            
                            nextSink = curSinks{k};
                            if ~isempty(nextSink)
                                newPath = regexprep(nextSink,['/',oldName,'/'],['/',newName,'/']);
                                obj.parent.Ses.Selection_Constraints.Pathes{i,2}{k} = newPath; 
                            end
                        end
                    end                   
                end
                case 'Others'
                %  Check existance of saved pathes according to node objects -
                %--check source nodes--
                SourcePathes = savedSelCons(:,1)';
                emptyRows = cellfun(@(x)isempty(x),SourcePathes,'UniformOutput',false);
                ObjPathes = cell(1,NodeCount);
                for i=1:NodeCount   
                    ObjPathes{i} = NodeObjs{i}.treepath;
                end
                %fill empty rows with string to use cellfun ismember
                SourcePathes(cellfun(@isempty,SourcePathes)) = {' '}; 
                % SelConOK = ismember(SourcePathes,ObjPathes);
                SelConOK = cellfun(@(x)ismember(x,ObjPathes),SourcePathes,'UniformOutput',false);
                %the opposite of: Selection Contraints still exist or it is an empty Row -> keep the rows
                deleteRow = cellfun(@(x,y)~(x || y),SelConOK,emptyRows,'UniformOutput',false);
                deleteRow = cell2mat(deleteRow);
                %delete Rows that dont exist anymore
                obj.parent.Ses.Selection_Constraints.Pathes(deleteRow,:) = [];
                %--check sink nodes-
                savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
                SinkPathes = savedSelCons(:,2);
                for i=length(SinkPathes):-1:1
                    nextRowPathes = SinkPathes{i};
                    if isempty(nextRowPathes)
                        %empty row -> do not delete the row!
                    else
                        SinksOK = cellfun(@(x)ismember(x,ObjPathes),nextRowPathes,'UniformOutput',false);
                        SinksOK = cell2mat(SinksOK);
                        obj.parent.Ses.Selection_Constraints.Pathes{i,2} = nextRowPathes(SinksOK);
                        %check if it is empty now; if so delete the whole row
                        if isempty(obj.parent.Ses.Selection_Constraints.Pathes{i,2})
                            obj.parent.Ses.Selection_Constraints.Pathes(i,:) = [];
                        end
                    end
                end
                %  Check plausibility of saved pathes according to node structure --
                % allSavedSelCons after prooving existence --
                savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
                % firstSelection - pick nodes that are eighter entities under specs or an Aspect-Sibling
                % sources = savedSelCons(:,1)';
                sinks = {};
                savedSelConsNotEmpty = savedSelCons(:,2);
                savedSelConsNotEmpty(cellfun(@isempty,savedSelConsNotEmpty)) = [];
                for i=1:length(savedSelConsNotEmpty)
                    nextSinks = savedSelConsNotEmpty{i};
                    sinks = [sinks,nextSinks];    
                end
                allTreepathes = sinks;
                allTreepathes(cellfun(@isempty,allTreepathes)) = [];
                firstSelection = {};
                for i=1:length(allTreepathes)
                    curPath = allTreepathes{i};
                    [treenode] = obj.parent.Ses.getTreeNode(curPath);
                    nodeType = obj.parent.Ses.getType(treenode);
                    parentType = obj.parent.Ses.getType(treenode.getParent);
                    if strcmp(parentType,'Spec')
                        firstSelection = [firstSelection,curPath];
                    elseif strcmp(nodeType,'Aspect') || strcmp(nodeType,'MAspect')
                        %find AspectNodes in Siblings
                        Siblings = treenode.getParent.children;
                        AspCount = 0;
                        while Siblings.hasMoreElements
                            curNode = Siblings.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                            node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                AspCount = AspCount + 1;
                            end
                        end
                        if AspCount > 1
                            firstSelection = [firstSelection,curPath];
                        end
                    end
                end
                % sources = savedSelCons(:,1);
                sinks = savedSelCons(:,2);                
                SinksOK = cell(length(sinks),1);
                for i=1:length(sinks)
                    if isempty(sinks{i})
                        SinksOK{i} = true;
                    else
                        SinksOK(i) = cellfun(@(x)ismember(x,firstSelection),sinks(i),'UniformOutput',false);
                    end
                end
                % SourcesNotOK = cellfun(@(x)~x,SourceOK,'UniformOutput',false);
                SinksNotOK = cellfun(@(x)~x,SinksOK,'UniformOutput',false);
                %delete Pathes that are not plausible considering the firstSelection
                for i=length(SinksNotOK):-1:1                    
                    if ~ismember(false,SinksNotOK{i})
                        %delete whole row
                        obj.parent.Ses.Selection_Constraints.Pathes(i,:) = [];
                    elseif ~isempty(sinks{i}) %not an empty row
                        %delete unplausible entries
                        curSinks=sinks{i};
                        obj.parent.Ses.Selection_Constraints.Pathes{i,2} = curSinks(SinksOK{i}); 
                    end
                end
                % secondSelection - eliminate nodes that share the same Spec node ancestor as the source or the other sinks
                savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
                sources = savedSelCons(:,1);
                sinks = savedSelCons(:,2);
                %combine sources and sinks in one cellarray
                SourceAndSink = cellfun(@(x)[sources(x),sinks{x}],num2cell(1:length(sources)),'UniformOutput',false);
                SpecNodeAncestor = cell(length(sources),1);
                for i=1:length(sources)
                    curRow = SourceAndSink{i};
                    if ~isempty(curRow{1})
                        for k=1:length(curRow)
                            curNode = obj.parent.Ses.getTreeNode(curRow{k});
                            RootPathcurNode = curNode.pathFromAncestorEnumeration(curNode.getRoot.getFirstChild);
                            %find all Spec Node Ancestors and save their treepathes
                            while RootPathcurNode.hasMoreElements
                                nextNode = RootPathcurNode.nextElement;
                                nextNodeType = obj.parent.Ses.getType(nextNode);
                                if strcmp(nextNodeType,'Spec')
                                    SpecNodeAncestor{i} = [SpecNodeAncestor{i},{obj.parent.Ses.getTreepath(nextNode)}];
                                end       
                            end
                        end
                    end 
                end
                %delete Pathes that are not plausible considering the secondSelection
                for i=length(SpecNodeAncestor):-1:1
                    %treepathes exist a couple of time?
                    if length(SpecNodeAncestor{i})~=length(unique(SpecNodeAncestor{i}))
                        obj.parent.Ses.Selection_Constraints.Pathes(i,:) = [];   
                    end
                end
                % thirdSelection - eliminate nodes that share the same Entity ancestor with at least 2 Aspect Children as the source
                savedSelCons = obj.parent.Ses.Selection_Constraints.Pathes;
                sources = savedSelCons(:,1);
                sinks = savedSelCons(:,2);
                %combine sources and sinks in one cellarray
                SourceAndSink = cellfun(@(x)[sources(x),sinks{x}],num2cell(1:length(sources)),'UniformOutput',false);
                EntNodeAncestor = cell(length(sources),1);
                for i=1:length(sources)
                    curRow = SourceAndSink{i};
                    if ~isempty(curRow{1})
                        for k=1:length(curRow)
                            curNode = obj.parent.Ses.getTreeNode(curRow{k});
                            RootPathcurNode = curNode.pathFromAncestorEnumeration(curNode.getRoot.getFirstChild);
                            %find all Ent Node Ancestors and save their treepathes if AspCount>1
                            while RootPathcurNode.hasMoreElements
                                nextNode = RootPathcurNode.nextElement;
                                nextNodeType = obj.parent.Ses.getType(nextNode);
                                if strcmp(nextNodeType,'Aspect') || strcmp(nextNodeType,'MAspect')
                                    %find AspectNodes in children
                                    Siblings = nextNode.getParent.children;
                                    AspCount = 0;
                                    while Siblings.hasMoreElements
                                        curNode2 = Siblings.nextElement;
                                        [Treepath] = obj.parent.Ses.getTreepath(curNode2);  %treepath from hierarchyNode    
                                        node = obj.parent.Ses.nodes(Treepath);
                                        if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                            AspCount = AspCount + 1;
                                        end
                                    end
                                    if AspCount > 1
                                        EntNodeAncestor{i} = [EntNodeAncestor{i},{obj.parent.Ses.getTreepath(nextNode.getParent)}];
                                    end
                                end       
                            end
                        end
                    end
                end
                %delete Pathes that are not plausible considering the thirdSelection
                for i=length(EntNodeAncestor):-1:1
                    %treepathes exist multiple time?
                    if length(EntNodeAncestor{i})~=length(unique(EntNodeAncestor{i}))
                        obj.parent.Ses.Selection_Constraints.Pathes(i,:) = [];   
                    end
                end                     
            end%switch
            % refresh the tabledata for Selection Constraints change --
            %organize selection behavior
            selRow = obj.hData.Tables.jtable1.getSelectedRows;
            rows = size(obj.parent.Ses.Selection_Constraints.Pathes,1);
            SelCons = obj.parent.Ses.Selection_Constraints.Pathes;
            sources = cell(rows,1);
            sinks = cell(rows,1);
            for i=1:rows
                sources{i} = obj.parent.Ses.getNameFromPath(SelCons{i,1});
                sinkpathes = SelCons{i,2};
                names = '';
                for j=1:length(sinkpathes)
                    nextPath = sinkpathes{j};
                    nextName = obj.parent.Ses.getNameFromPath(nextPath);
                    names = [names,' , ',nextName];
                end
                sinks{i} = names(4:end);      
            end
            %refresh Tree Colors
            obj.refreshTreeColors
            %refresh Table Colors
            Data = cell(rows,2);
            for i=1:rows
                if ~isempty(SelCons{i,1})
                    sourcePath = SelCons{i,1};
                    sourceNode = obj.parent.Ses.getTreeNode(sourcePath);
                    [~,htmlname] = obj.parent.Ses.getName(sourceNode);
                    Data{i,1} = htmlname;
                    sinkNames = '';
                    for k=1:length(SelCons{i,2})
                        sinkPath = SelCons{i,2}{k};
                        sinkNode = obj.parent.Ses.getTreeNode(sinkPath);
                        [name2,htmlname2] = obj.parent.Ses.getName(sinkNode);
                        sinkNames = [sinkNames,' , ',name2];
                    end
                    sinkNames = sinkNames(4:end);
                    if strcmp(name2,htmlname2)
                        Data{i,2} = sinkNames;
                    else
                        htmlpartend = strfind(htmlname2,'>');
                        htmlpartend = htmlpartend(end);
                        htmlpart = htmlname2(1:htmlpartend);
                        Data{i,2} = [htmlpart,sinkNames];
                    end
                else
                    Data(i,:) = cell(1,2);
                end
            end%for     
            if isempty(Data)
                Data = cell(1,2);
                obj.parent.Ses.Selection_Constraints.Pathes = cell(1,2);
            end
            set(obj.hData.Tables.mtable1,'Data',Data);
            pause(0.1)
            drawnow limitrate nocallbacks
            % set row selection
            if ~isempty(selRow)%if a row is selected
                rightRow = false;
                while rightRow ==false
                    try
                        obj.hData.Tables.jtable1.setRowSelectionInterval(selRow(1),selRow(end))
                        rightRow = true;
                    catch
                        selRow = selRow(end)-1;
                    end
                end
            end
            
        end%function
        
        %% refresh the treeColors after Selection Constraints changed %%%%%%%%%%%%%
        function refreshTreeColors(obj)
            SelCons = obj.parent.Ses.Selection_Constraints.Pathes;
            allNodes = obj.parent.Hierarchy.hData.Trees.root1.depthFirstEnumeration;
            while allNodes.hasMoreElements
                nextNode = allNodes.nextElement;
                nextNode_TP = obj.parent.Ses.getTreepath(nextNode);
                [name] = obj.parent.Ses.getName(nextNode);
                %check if node is part of Selection Constraints and if so, check if source
                sourcePathes = SelCons(:,1)';
                sinkPathes = {};
                for i=1:length(SelCons(:,1))
                    sinkPathes = [sinkPathes,SelCons{i,2}];
                end
                allPathes = [sourcePathes,sinkPathes];
                allPathes(cellfun(@isempty,allPathes)) = [];  %delete empty cell entries
                if ~ismember(nextNode_TP,allPathes)
                    nextNode.setName(name)
                end
            end
            obj.parent.Hierarchy.hData.Trees.jtree1.treeDidChange();
            
        end%function
        %% update ses variables Table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function UpdateSesVariables(obj)
            Data = obj.parent.Ses.var;
            if isempty(Data)
                Data = cell(1);
                obj.parent.Ses.var = cell(1);
            end
            selRow = obj.hData.Tables.jtable2.getSelectedRows;
            set(obj.hData.Tables.mtable2,'Data',Data)
            pause(0.1)
            drawnow limitrate nocallbacks
            % set row selection
            if ~isempty(selRow)%if a row is selected
                rightRow = false;
                while rightRow ==false
                    try
                        obj.hData.Tables.jtable2.setRowSelectionInterval(selRow(1),selRow(end))
                        rightRow = true;
                    catch
                        selRow = selRow(end)-1;
                    end
                end
            end            
        end%
        
        %%
        function createSESFUN(obj,varargin) 
            
            fun = obj.parent.Ses.fcn;                  
                
            while exist('ExportedFunctions','dir')==7 %explicite using while here!!
                rmdir('ExportedFunctions','s')%delete Folder 
            end
           
            mkdir('ExportedFunctions')
            
            oldFolder = cd('ExportedFunctions');
            
            for i=1:length(fun)
                if ~isempty(fun{i}.Filename)
                    %if exist(fun{i}.Filename,'file') == 0 %no m-function exist with the specified name
                        %so create function    
                        
                    fileID = fopen(fun{i}.Filename,'w');
                    fprintf(fileID,'%s',fun{i}.Data{:});
                    fclose(fileID);                      
                    %end
                end
            end            
            cd(oldFolder) 
            obj.parent.InfoCenter.MSG('h',4,'');
        end%function
        
        %%
        function updateComment(obj,~,~)
            comment_str = obj.hData.Comment.getText();
            obj.parent.Ses.comment = comment_str; 
        end%function

    end%methods
end%classdef
