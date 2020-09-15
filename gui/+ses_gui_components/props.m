classdef props < ses_gui_components.supportFun    
    properties
        mainPanel
        EntityTabPanel
        SpecTabPanel
        AspectTabPanel
        CP_M_ASP  
    end
    methods
        function obj = props(parent) %constructor
            import javax.swing.*
            import javax.swing.tree.*
            
            obj.parent = parent;
                      
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%% Design - Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.mainPanel = uiextras.CardPanel(...
                'Parent',               obj.parent.hData.f1,...                
                'Padding',              0,...
                'BackgroundColor',      obj.Default.Color.BG_D);

            obj.EntityTabPanel = uiextras.TabPanel(...                
                'Parent',               obj.mainPanel,...
                'Padding',              0 ,...
                'FontName',             obj.Default.Font.NameText,...
                'FontSize',             obj.Default.Font.SizeS,...
                'BackgroundColor',      obj.Default.Color.BG_P); 
                
            obj.SpecTabPanel = uiextras.TabPanel(...                
                'Parent',               obj.mainPanel,...
                'Padding',              0 ,...
                'FontName',             obj.Default.Font.NameText,...
                'FontSize',             obj.Default.Font.SizeS,...
                'BackgroundColor',      obj.Default.Color.BG_P);
 
            obj.AspectTabPanel = uiextras.TabPanel(...                
                'Parent',               obj.mainPanel,...
                'Padding',              0 ,...
                'FontName',             obj.Default.Font.NameText,...
                'FontSize',             obj.Default.Font.SizeS,...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
            VBox = uiextras.VBox(...
                'Parent',               obj.mainPanel,...
                'Spacing',              0,...
                'Padding',              0,...
                'BackgroundColor',      obj.Default.Color.BG_P);
           
            uiextras.Panel(...
                'Parent',               VBox,...  
                'BorderType',           'none',...
                'BackgroundColor',      obj.Default.Color.BG_D); 
            set(VBox,'Sizes',19)
                        
            %% Entity Design !!!
            
            set(obj.mainPanel,'SelectedChild',1);
            
            % Buttongroup part
            %4) Entity Buttongroup              
                       
            obj.hData.hbg4x = uiextras.VBox(...
                'Parent',               obj.EntityTabPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P);  
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Comment Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.hData.ComEntity = JEditPlain(obj.EntityTabPanel);
            obj.hData.ComEntity.setCallback(@(hobj,evt)obj.updateComment(hobj,evt))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                           
            set(obj.EntityTabPanel,...
                'TabNames',             {'Attributes','Description'},...                
                'TabSize',              90);  
            
            set(obj.EntityTabPanel,'SelectedChild',1);
            
            % Edit part
            % 9.) Panel Edit for Attributes
            obj.hData.hp9x = uiextras.VBox(...
                'Parent',               obj.hData.hbg4x,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Padding',              0,...
                'Visible',              'on');
                
            %10) Text Attribute Name 
            BasicText(obj.hData.hp9x,'Name');
            
                
            %11.) Edit Attribute Name  
            tmp = BasicEdit(obj.hData.hp9x,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Attributes'));
            obj.hData.hb11x = tmp.hnd;
            
            %2.) %11.) Edit Attribute Name
            % JEdit Attribute Name
            obj.hData.jhb11x = findjobj(obj.hData.hb11x);
            set(obj.hData.jhb11x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Attributes'));
            
            
            %15) Text Attribute Value 
            BasicText(obj.hData.hp9x,'Value');
            
            %16.) Edit Value
            tmp = BasicEdit(obj.hData.hp9x,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Attributes'));
            obj.hData.hb16x = tmp.hnd;
            
            %3.) %16.) Edit Value non-functional
            % JEdit Attribute Value
            obj.hData.jhb16x = findjobj(obj.hData.hb16x); 
            set(obj.hData.jhb16x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Attributes')); 
            
            %some space            
            uiextras.Empty('Parent', obj.hData.hp9x);
            
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp9x);
                
            % 6.) Icon add Attribute
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.addRow(hobj,evt,'Attributes'));
            obj.hData.jhb6x         = IconObj.hnd;
                        
            % 7.) Icon delete Attribute 
            IconObj = JBttn(BBar.hnd,'del','Delete selected Rows');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.deleteRow(hobj,evt,'Attributes'));
            obj.hData.jhb7x         = IconObj.hnd;
            
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 22.) Pushbuttons "OK" 
            IconObj = JBttn(BBar.hnd,'ok','OK');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.OKButtonCallback(hobj,evt,'Attributes'));
            obj.hData.jhb22x         = IconObj.hnd;           
               
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(1);');
            
            %Set Heights of Parent
            set(obj.hData.hp9x,'Sizes',[23 23 23 23 23 23]);
            
            % Table part
            % 5.) Panel Attributes table inspector
            
            
            % 8) generating table in Attributes 
            tmp = BasicJTable(obj.hData.hbg4x,...
                {'Name','Value'});
            obj.hData.Tables.mtable1 = tmp.hnd;
            obj.hData.Tables.jtable1 = tmp.jtable; 
            
            %Fix to MATLAB R2014 to use ValueChangedCallback-------------------
            set(handle(obj.hData.Tables.jtable1.getSelectionModel,...
                'CallbackProperties'),'ValueChangedCallback',...
                @(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable1))    
            
                  
            
            %% Spec Design !!!            
            set(obj.mainPanel,'SelectedChild',2);
            
            % Buttongroup part
            % 23) Spec Buttongroup        
            obj.hData.hbg23x = uiextras.VBox(...
                'Parent',               obj.SpecTabPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P); 
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Comment Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.hData.ComSpec = JEditPlain(obj.SpecTabPanel);
            obj.hData.ComSpec.setCallback(@(hobj,evt)obj.updateComment(hobj,evt))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            set(obj.SpecTabPanel,'SelectedChild',1);
            
            set(obj.SpecTabPanel,...
                'TabNames',             {'Specrule','Description'},...                
                'TabSize',              90);     
            
            % Edit part
            % 28.) Panel Edit for Specrule
            obj.hData.hp28x = uiextras.VBox(...
                'Parent',               obj.hData.hbg23x,...                
                'BackgroundColor',      obj.Default.Color.BG_P,...  
                'Padding',              0,...
                'Visible',              'on');
                
            %31) Text Selection
            BasicText(obj.hData.hp28x,'SelectedChild');
                
            % 32.) PopupMenu Selection
            obj.hData.hb32x = uicontrol(...
                'style',                'Popupmenu',...
                'BackgroundColor',      obj.Default.Color.FG,...   %'<html><div style=":hover {background: yellow}"></div>Hello</html>'
                'String',               {''},...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.Name,...
                'Parent',               obj.hData.hp28x,...                
                'Callback',             @(hobj,evt)obj.checkProperty(hobj,evt,'Specrule'));
            
            %33) Text Condition 
            BasicText(obj.hData.hp28x,'Condition');
                      
            %34.) Edit Condition
            tmp = BasicEdit(obj.hData.hp28x,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Specrule'));
            obj.hData.hb34x = tmp.hnd;
            
            
            obj.hData.jhb34x = findjobj(obj.hData.hb34x);
            obj.hData.jhb34xcaret = obj.hData.jhb34x.getCaret;
            set(obj.hData.jhb34x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Specrule'));  
            
            
            %some space            
            uiextras.Empty('Parent', obj.hData.hp28x);
                       
            
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp28x);            
            
            % 25.) Icon add Specrule 
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.addRow(hobj,evt,'Specrule'));
            obj.hData.jhb25x         = IconObj.hnd;
                        
            
            % 26.) Icon delete Specrule 
            IconObj = JBttn(BBar.hnd,'del','Delete selected Rows');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.deleteRow(hobj,evt,'Specrule'));
            obj.hData.jhb26x         = IconObj.hnd;
            
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 40.) Pushbuttons "OK"               
            IconObj = JBttn(BBar.hnd,'ok','Insert Specrule');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.OKButtonCallback(hobj,evt,'Specrule'));
            obj.hData.jhb40x         = IconObj.hnd;
            
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(2);');
            
            %Set Heights of Parent
            set(obj.hData.hp28x,'Sizes',[23 23 23 23 23 23]);
            
                         
            % Table part                
            % 27) generating table in Specrule
            tmp = BasicJTable(obj.hData.hbg23x,...
                {'Selection','Condition'});
            obj.hData.Tables.mtable2 = tmp.hnd;
            obj.hData.Tables.jtable2 = tmp.jtable; 
            
            %Fix to MATLAB R2014 to use ValueChangedCallback---------------------------
            set(handle(obj.hData.Tables.jtable2.getSelectionModel,...
                'CallbackProperties'),'ValueChangedCallback',...
                @(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable2))    
            %--------------------------------------------------------------------------
            %Table has same Position as mtable1, so give table right pos after using findjobj
                           
            
            
            %% Aspect Design - Aspectrule !!!            
            set(obj.mainPanel,'SelectedChild',3);
                        
            % Buttongroup part
            %41b) Aspectrule - Aspect BG
            obj.hData.bg41ax = uiextras.VBox(...
                'Parent',               obj.AspectTabPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P);  
            
            
            %41b) Coupling - Aspect BG
            obj.hData.bg41bx = uiextras.VBox(...
                'Parent',               obj.AspectTabPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P); 
            
            
            %41c) Number of Replikation - Aspect BG
            obj.hData.bg41cx = uiextras.VBox(...
                'Parent',               obj.AspectTabPanel,...
                'Spacing',              10,...
                'Padding',              5,...
                'BackgroundColor',      obj.Default.Color.BG_P); 
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Comment Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.hData.ComAsp = JEditPlain(obj.AspectTabPanel);
            obj.hData.ComAsp.setCallback(@(hobj,evt)obj.updateComment(hobj,evt))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                            
            set(obj.AspectTabPanel,...
                'TabNames',            {'Aspectrule',...
                                        'Coupling',...
                                        'NumOfRepl',...                                      
                                        'Description'},...                
                'TabSize',              90);         
            
            
            % Edit part
            % 46.) Panel Edit for Aspectrule
            
            set(obj.AspectTabPanel,'SelectedChild',1);
            
            obj.hData.hp46x = uiextras.VBox(...
                'Parent',                obj.hData.bg41ax,...            
                'BackgroundColor',       obj.Default.Color.BG_P,... 
                'Padding',               0,...
                'Visible',               'on');
            
            %49) Text Selection
            BasicText(obj.hData.hp46x,'Selection');
               
            % 50.) PopupMenu Selection
            obj.hData.hb50x = uicontrol(...
                'style',                'Popupmenu',...
                'BackgroundColor',      obj.Default.Color.FG,...
                'String',               {''},...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.Name,...
                'Parent',               obj.hData.hp46x,...
                'Callback',@(hobj,evt)obj.checkProperty(hobj,evt,'Aspectrule')); 
            
            %51) Text Condition 
            BasicText(obj.hData.hp46x,'Condition');
                                    
            %52.) Edit Condition
            tmp = BasicEdit(obj.hData.hp46x,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Aspectrule'));
            obj.hData.hb52x = tmp.hnd;
            
            %7.) % JEdit Condition-----------------------------------------------------
            obj.hData.jhb52x = findjobj(obj.hData.hb52x);
            obj.hData.jhb52xcaret = obj.hData.jhb52x.getCaret;
            set(obj.hData.jhb52x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Aspectrule')); 
            
            %some space            
            uiextras.Empty('Parent', obj.hData.hp46x);
                        
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp46x);
                            
            % 43.) Icon add Aspectrule 
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.addRow(hobj,evt,'Aspectrule'));
            obj.hData.jhb43x         = IconObj.hnd;
            
                        
            % 44.) Icon delete Aspectrule 
            IconObj = JBttn(BBar.hnd,'del','Delete selected Rows');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.deleteRow(hobj,evt,'Aspectrule') );
            obj.hData.jhb44x         = IconObj.hnd;
            
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 58.) Pushbuttons "OK" Aspectrule
            IconObj = JBttn(BBar.hnd,'ok','Insert Aspectrule');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.OKButtonCallback(hobj,evt,'Aspectrule'));
            obj.hData.jhb58x         = IconObj.hnd;
            
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(3);');
            
            %some space            
            uiextras.Empty('Parent', obj.hData.hp46x);           
              
            
            % 52a.) Panel Aspect Inheritance
            tmp = BasicPanel(obj.hData.hp46x,'Aspect Inheritance');
            obj.hData.hp52ax = tmp.hnd;
            
            %Parent
            set(obj.hData.hp46x,'Sizes',[23 23 23 23 23 23 23 50])            
                   
                    
            HB = uiextras.HBox(...
                'Parent',               obj.hData.hp52ax,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Padding',              5,...
                'Spacing',              5,...
                'Visible',              'on'); 
            
            %52b) Text Priority (Global)
            BasicText(HB,'Priority (global):');
            
            
            %52c.) Edit Priority (Global)
            tmp = BasicEdit(HB,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'AspectInheritance'));
            obj.hData.hb52cx = tmp.hnd;
            % 7.5)% JEdit Priority (Global)--------------------------------------------
            obj.hData.jhb52cx = findjobj(obj.hData.hb52cx);
            obj.hData.jhb52cxcaret = obj.hData.jhb52cx.getCaret;
            set(obj.hData.jhb52cx,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'AspectInheritance'));
                        
            
            % 52d.) Pushbuttons "OK"  Aspect Inheritance                         
            IconObj = JBttn(HB,'ok','Insert Aspectrule');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.OKButtonCallback(hobj,evt,'AspectInheritance'));
            obj.hData.jhb52dx           = IconObj.hnd;
            
            %Help Button
            IconObj = JBttn(HB,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(4);');
            
                                    
            set(HB,'Sizes',[100 -1, 30 30])
            
                                    
            % Table part 
            % 45) generating table in Aspectrule 
            tmp = BasicJTable(obj.hData.bg41ax,...
                {'Selection','Condition'});
            obj.hData.Tables.mtable3 = tmp.hnd;
            obj.hData.Tables.jtable3 = tmp.jtable; 
            
            %Fix to MATLAB R2014 to use ValueChangedCallback---------------------------
            set(handle(obj.hData.Tables.jtable3.getSelectionModel,...
                'CallbackProperties'),'ValueChangedCallback',...
                @(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable3))    
           
                  
                      
            % Aspect Design - Coupling !!!            
            set(obj.AspectTabPanel,'SelectedChild',2);            
                           
            % Edit part
            % 63.) Panel Edit for Coupling
            obj.hData.hp63x = uiextras.VBox(...
                'Parent',               obj.hData.bg41bx,...                
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Padding',              0,...
                'Spacing',              5,...
                'Visible',              'on');
            
            
            %SES FUNCTION FOR COUPLING START            
            % 75.) Panel Function
            tmp = BasicPanel(obj.hData.hp63x,'Function');
            obj.hData.hp75x = tmp.hnd;
                       
            VB = uiextras.VBox(...
                'Parent',               obj.hData.hp75x,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Spacing',              5,...
                'Padding',              5);            
            
            % 76.) Checkbox functional
            obj.hData.hb76x = uicontrol(...
                'style',                'Checkbox',...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'String',               'Choose Function to set Coupling',...
                'HorizontalAlignment',  'left',...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.NameText,...
                'Parent',               VB,...                
                'callback',@(hobj,evt)obj.CheckboxCallback(hobj,evt)); 
            
            % 77.) Edit Function input 
            tmp = BasicEdit(VB,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Coupling'));
            obj.hData.hb77x = tmp.hnd;
            
            %11.) % JEdit Output Port -------------------------------------------------
            obj.hData.jhb77x = findjobj(obj.hData.hb77x);
            obj.hData.jhb77xcaret = obj.hData.jhb77x.getCaret;
            set(obj.hData.jhb77x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Coupling'));
            
            %Set Heights of Parent                  
            set(VB,'Sizes',[23 23]); 
            
                      
            %CLASSIC COUPLING START 
            % 65.) Panel Source
            tmp = BasicPanel(obj.hData.hp63x,'Static');
            obj.hData.hp65x = tmp.hnd;
            
            Grid = uiextras.Grid(...
                'Parent',               obj.hData.hp65x,...
                'BackgroundColor',      obj.Default.Color.BG_P,...
                'Padding',              5,...
                'Spacing',              5);
            
            % 67) Text Source Component 
            BasicText(Grid,'Source');
            
            % 67.) PopupMenu Source Component
            obj.hData.hb67x = uicontrol(...
                'style',                'Popupmenu',...
                'BackgroundColor',      obj.Default.Color.FG,...
                'String',               {''},...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.Name,...
                'Parent',               Grid,...                '
                'Callback',@(hobj,evt)obj.checkProperty(hobj,evt,'Coupling')); 
            
            % 68) Text From Port 
            BasicText(Grid,'From Port');
            
            % 69.) Edit Output Port 
            tmp = BasicEdit(Grid,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Coupling'));
            obj.hData.hb69x = tmp.hnd;
            
            
            %9.) %69) JEdit Output Port --------------------------------------------------
            obj.hData.jhb69x = findjobj(obj.hData.hb69x);
            obj.hData.jhb69xcaret = obj.hData.jhb69x.getCaret;
            set(obj.hData.jhb69x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Coupling'));  
          
            
            % 71) Text Sink Component 
            BasicText(Grid,'Target');
            
            % 72.) PopupMenu Sink Component
            obj.hData.hb72x = uicontrol(...
                'style',                'Popupmenu',...
                'BackgroundColor',      obj.Default.Color.FG,...
                'String',               {''},...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.Name,...
                'Parent',               Grid,...
                'Callback',@(hobj,evt)obj.checkProperty(hobj,evt,'Coupling')); 
            
            % 73) Text To Port 
            BasicText(Grid,'To Port');
            
            % 74.) Edit Input Port 
            tmp = BasicEdit(Grid,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'Coupling')); 
            obj.hData.hb74x = tmp.hnd;
            
            
            %10.) % JEdit Output Port -------------------------------------------------
            obj.hData.jhb74x = findjobj(obj.hData.hb74x);
            obj.hData.jhb74xcaret = obj.hData.jhb74x.getCaret;
            set(obj.hData.jhb74x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'Coupling'));    
            
            %Parent
            set(Grid,'RowSizes', [23 23],'ColumnSizes',[-1 -1 -1 -1])
            
            
            
            %some space            
            uiextras.Empty('Parent', obj.hData.hp63x);  
            
            
            % Horizontal Button Bar    
            BBar = HBttnBar(obj.hData.hp63x);
            
            % 60.) Icon add Coupling Case
            IconObj = JBttn(BBar.hnd,'add','Add Row');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.addRow(hobj,evt,'Coupling'));
            obj.hData.jhb60x         = IconObj.hnd;
            obj.hData.jhb92x         = IconObj.hnd;             
                        
            % 61.) Icon delete Coupling Case 
            IconObj = JBttn(BBar.hnd,'del','Delete selected Rows');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.deleteRow(hobj,evt,'Coupling'));
            obj.hData.jhb61x         = IconObj.hnd;  
            obj.hData.jhb93x         = IconObj.hnd;
                        
            %some space            
            uiextras.Empty('Parent', BBar.hnd);
            
            % 80.) Pushbuttons "OK" 
            IconObj = JBttn(BBar.hnd,'ok','insert');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.OKButtonCallback(hobj,evt,'Coupling'));
            obj.hData.jhb80x         = IconObj.hnd;              
            
            %Help Button
            IconObj = JBttn(BBar.hnd,'help2','Open Help');            
            set(IconObj.hnd,'MouseClickedCallback','contextHelp(5);');
            
            %some space            
            uiextras.Empty('Parent', obj.hData.hp63x); 
            
                    
            obj.hData.MAspIntHBox = uiextras.HBox(...
                'Parent',               obj.hData.hp63x,...
                'BackgroundColor',      obj.Default.Color.BG_P,... 
                'Spacing',              5,...
                'Padding',              0,...
                'Visible',              'on');           
            
            % 89.) Text Start
            BasicText(obj.hData.MAspIntHBox,'Start:','HorizontalAlignment','right');
            
            % 87.) Edit Interval Start
            tmp = BasicEdit(obj.hData.MAspIntHBox,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'CouplingInterval'));
            obj.hData.hb87x = tmp.hnd;
                        
            %13.) % JEdit Edit Interval Start -----------------------------------------
            obj.hData.jhb87x = findjobj(obj.hData.hb87x);
            obj.hData.jhb87xcaret = obj.hData.jhb87x.getCaret;
            set(obj.hData.jhb87x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'CouplingInterval')); 
            
            
            % 86.) Text End
            BasicText(obj.hData.MAspIntHBox,'End:','HorizontalAlignment','right');
            
            % 88.) Edit Interval End
            tmp = BasicEdit(obj.hData.MAspIntHBox,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'CouplingInterval'));
            obj.hData.hb88x = tmp.hnd;
            
            %14.) JEdit Variable Name of Nr of Rep-------------------------------------
            obj.hData.jhb88x = findjobj(obj.hData.hb88x);
            obj.hData.jhb88xcaret = obj.hData.jhb88x.getCaret;
            set(obj.hData.jhb88x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'CouplingInterval'));  
            
            
            BasicText(obj.hData.MAspIntHBox,'Cur:','HorizontalAlignment','right');
            
            % 95.) popUpMenu select Nr of Replication
            obj.hData.hb95x = uicontrol(...
                'Parent',               obj.hData.MAspIntHBox,...
                'style',                'PopupMenu',...
                'BackgroundColor',      obj.Default.Color.FG,...
                'String',               {''},...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.Name,...                
                'Callback',@(hobj,evt)obj.selectNumOfRep);
            
            %some space            
            uiextras.Empty('Parent', obj.hData.MAspIntHBox);             
            
            %Set Heights of Parent                  
            set(obj.hData.hp63x,'Sizes',[80 80 23 23 23 23]); 
             

            % Table part                  
            obj.CP_M_ASP = uiextras.CardPanel(...
                'Parent',               obj.hData.bg41bx,...
                'BackgroundColor',      obj.Default.Color.BG_P);

                   
            %%%%%% Aspect Table %%%%%%%  
            
            % 62) generating table in Coupling 
            tmp = BasicJTable(obj.CP_M_ASP,...
                {'Source','From Port','Target','To Port'},...
                'ColumnWidth',          {120 65 120 65});
            obj.hData.Tables.mtable4 = tmp.hnd;
            obj.hData.Tables.jtable4 = tmp.jtable;
            
            set(obj.CP_M_ASP,'SelectedChild',1)          
            
           
            %Fix to MATLAB R2014 to use ValueChangedCallback---------------------------
            set(handle(obj.hData.Tables.jtable4.getSelectionModel,...
                'CallbackProperties'),'ValueChangedCallback',...
                @(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable4))    
            
                        
            
            %%%%%% Multiple Aspect Table %%%%%%% 
            
             % 94) generating table in Coupling 
            tmp = BasicJTable(obj.CP_M_ASP,...
                {'Source','From Port','Target','To Port'},...
                'ColumnWidth',          {120 65 120 65});
            obj.hData.Tables.mtable5 = tmp.hnd;
            obj.hData.Tables.jtable5 = tmp.jtable;  
            
            %Fix to MATLAB R2014 to use ValueChangedCallback---------------------------
            set(handle(obj.hData.Tables.jtable5.getSelectionModel,...
                'CallbackProperties'),'ValueChangedCallback',...
                @(hobj,evt)obj.Selectioncbck(hobj,evt,obj.hData.Tables.jtable5))  
            
            set(obj.CP_M_ASP,'SelectedChild',2)
            
                    
            
            
            % Edit part 
            % 82.) Panel NrOfRep
            
            set(obj.AspectTabPanel,'SelectedChild',3);
            
            
            obj.hData.hp82x = uiextras.VBox(...
                'Parent',               obj.hData.bg41cx,...
                'BackgroundColor',      obj.Default.Color.BG_P,...                
                'Visible',              'on',...
                'Spacing',              5,...
                'Padding',              5);
                
            % 83.) Text NumRep Value
            BasicText(obj.hData.hp82x,'NumRep Value');
                      
            % 84.) Edit Variable Name of NrOfRep  
            tmp = BasicEdit(obj.hData.hp82x,...
                @(hobj,evt)obj.ReturnKeyCallback(hobj,evt,'NumOfRep'));   
            obj.hData.hb84x = tmp.hnd;
            
            %12.) % JEdit Variable Name of NrOfRep-------------------------------------
            obj.hData.jhb84x = findjobj(obj.hData.hb84x);
            obj.hData.jhb84xcaret = obj.hData.jhb84x.getCaret;
            set(obj.hData.jhb84x,'CaretUpdateCallback',...
                @(hobj,evt)obj.checkProperty(hobj,evt,'NumOfRep'));  
            
            % 90.) Pushbuttons "OK"
            IconObj = JBttn(obj.hData.hp82x,'ok','OK');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.OKButtonCallback(hobj,evt,'NumOfRep'));
            obj.hData.jhb90x         = IconObj.hnd;
            
                       
            %Parent
            set(obj.hData.hp82x,'Sizes',[23 23 23]) 
            
            set(obj.mainPanel,'SelectedChild',4);            
        end %Constructor
        
        %% Icon Callback addRow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        function addRow( obj,~,~,Property )
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            TP = obj.parent.Ses.getTreepath(selNode);
            nodeObj = obj.parent.Ses.nodes(TP);
            switch Property
                case 'Attributes'
                allObjNodes = values(obj.parent.Ses.nodes);
                for i=1:obj.parent.Ses.nodes.Count
                    nextObj = allObjNodes{i};
                    if strcmp(nextObj.name,nodeObj.name)          
                        nextObj.attributes = [nextObj.attributes;cell(1,2)];
                    end
                end
                obj.addTableRow( obj.hData.Tables.mtable1 , cell(1,2))
                pause(0.1)
                drawnow limitrate nocallbacks
                Rows = obj.hData.Tables.jtable1.getRowCount;
                obj.hData.Tables.jtable1.setRowSelectionInterval(Rows-1,Rows-1)
                case 'Specrule'
                %                 if ~isstruct(nodeObj.specrule)
                obj.addTableRow( obj.hData.Tables.mtable2 , cell(1,2))
                pause(0.1)
                drawnow limitrate nocallbacks
                Rows = obj.hData.Tables.jtable2.getRowCount;
                nodeObj.specrule = [nodeObj.specrule;cell(1,2)];
                obj.hData.Tables.jtable2.setRowSelectionInterval(Rows-1,Rows-1)
                %                 end
                case 'Aspectrule'
                if ~isstruct(nodeObj.aspectrule)
                    obj.addTableRow( obj.hData.Tables.mtable3 , cell(1,2))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    %Save Aspectrule to all (M)Aspect Siblings-------------------------
                    Siblings = selNode.getParent.children;
                    %find AspectNodes in Siblings
                    while Siblings.hasMoreElements
                        curNode = Siblings.nextElement;
                        [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                        AspNode = obj.parent.Ses.nodes(Treepath);
                        if strcmp(AspNode.type,'Aspect') || strcmp(AspNode.type,'MAspect')
                            AspNode.aspectrule = [AspNode.aspectrule;cell(1,2)];
                        end
                    end
                    %------------------------------------------------------------------
                    Rows = obj.hData.Tables.jtable3.getRowCount;
                    obj.hData.Tables.jtable3.setRowSelectionInterval(Rows-1,Rows-1)
                end
                case 'Coupling'
                switch nodeObj.type
                    case 'Aspect'
                    if ~ischar(nodeObj.coupling) && ~get(obj.hData.hb76x,'Value')
                        obj.addTableRow( obj.hData.Tables.mtable4 , cell(1,4))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        Rows = obj.hData.Tables.jtable4.getRowCount;
                        nodeObj.coupling = [nodeObj.coupling;cell(1,4)];
                        obj.hData.Tables.jtable4.setRowSelectionInterval(Rows-1,Rows-1)
                    end
                    case 'MAspect'
                    if ~ischar(nodeObj.coupling) && ~get(obj.hData.hb76x,'Value')
                        str = get(obj.hData.hb95x,'String'); % 95.) popUpMenu select Nr of Replication                       
                        val = get(obj.hData.hb95x,'Value');
                        NumOfRep = str2double(str{val});
                        obj.addTableRow( obj.hData.Tables.mtable5 , cell(1,4))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        Rows = obj.hData.Tables.jtable5.getRowCount;
                        nodeObj.coupling{NumOfRep} = [nodeObj.coupling{NumOfRep};cell(1,4)];
                        obj.hData.Tables.jtable5.setRowSelectionInterval(Rows-1,Rows-1)
                    end       
                end
            end
            
        end%function
        
        %% Icon Callback deleteRow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        function deleteRow( obj,~,~,Property )
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            TP = obj.parent.Ses.getTreepath(selNode);
            nodeObj = obj.parent.Ses.nodes(TP);        
            switch Property
                case 'Attributes'
                selRowCount = obj.hData.Tables.jtable1.getSelectedRowCount;
                %sometimes no selection
                if selRowCount==0 
                    return
                end
                RowCount = obj.hData.Tables.jtable1.getRowCount;            
                selRows = obj.hData.Tables.jtable1.getSelectedRows;
                if RowCount-selRowCount == 0
                    allObjNodes = values(obj.parent.Ses.nodes);
                    for i=1:obj.parent.Ses.nodes.Count
                        nextObj = allObjNodes{i};
                        if strcmp(nextObj.name,nodeObj.name)          
                            nextObj.attributes = cell(1,2);
                        end
                    end
                    set(obj.hData.Tables.mtable1,'Data',cell(1,2))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    obj.hData.Tables.jtable1.setRowSelectionInterval(0,0)
                else       
                    allObjNodes = values(obj.parent.Ses.nodes);
                    for i=1:obj.parent.Ses.nodes.Count
                        nextObj = allObjNodes{i};
                        if strcmp(nextObj.name,nodeObj.name)          
                            nextObj.attributes(selRows+1,:) = [];
                        end
                    end
                    obj.deleteTableRow( obj.hData.Tables.mtable1,selRows + 1 )
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    if selRows(1)==0
                        obj.hData.Tables.jtable1.setRowSelectionInterval(selRows(1),selRows(1))
                    else
                        obj.hData.Tables.jtable1.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                    end
                end
                case 'Specrule'
                selRowCount = obj.hData.Tables.jtable2.getSelectedRowCount;
                %sometimes no selection
                if selRowCount==0 %|| isstruct(nodeObj.specrule)
                    return
                end
                RowCount = obj.hData.Tables.jtable2.getRowCount;            
                selRows = obj.hData.Tables.jtable2.getSelectedRows;
                if RowCount-selRowCount == 0
                    set(obj.hData.Tables.mtable2,'Data',cell(1,2))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    nodeObj.specrule = cell(1,2);
                    obj.hData.Tables.jtable2.setRowSelectionInterval(0,0)
                else
                    nodeObj.specrule(selRows+1,:) = [];
                    obj.deleteTableRow( obj.hData.Tables.mtable2,selRows + 1 )
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    if selRows(1)==0
                        obj.hData.Tables.jtable2.setRowSelectionInterval(selRows(1),selRows(1))
                    else
                        obj.hData.Tables.jtable2.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                    end
                end    
                %------ Update the List of selectable Node for Selection Constraints ------
                obj.parent.Settings.getListOfSelectableNodes  
                %--------------------------------------------------------------------------            
                %-----check if all descissions are made, if not color icon red-------------
                allNodes = values(obj.parent.Ses.nodes);
                obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                %--------------------------------------------------------------------------
                case 'Aspectrule'
                selRowCount = obj.hData.Tables.jtable3.getSelectedRowCount;
                %sometimes no selection
                if selRowCount==0 || isstruct(nodeObj.aspectrule)
                    return
                end
                RowCount = obj.hData.Tables.jtable3.getRowCount;            
                selRows = obj.hData.Tables.jtable3.getSelectedRows;
                if RowCount-selRowCount == 0
                    set(obj.hData.Tables.mtable3,'Data',cell(1,2))
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    %Save Aspectrule to all (M)Aspect Siblings-------------------------
                    Siblings = selNode.getParent.children;
                    %find AspectNodes in Siblings
                    while Siblings.hasMoreElements
                        curNode = Siblings.nextElement;
                        [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                        AspNode = obj.parent.Ses.nodes(Treepath);
                        if strcmp(AspNode.type,'Aspect') || strcmp(AspNode.type,'MAspect')
                            AspNode.aspectrule = cell(1,2);
                        end
                    end
                    %------------------------------------------------------------------
                    obj.hData.Tables.jtable3.setRowSelectionInterval(0,0)
                else
                    %Save Aspectrule to all (M)Aspect Siblings-------------------------
                    Siblings = selNode.getParent.children;
                    %find AspectNodes in Siblings
                    while Siblings.hasMoreElements
                        curNode = Siblings.nextElement;
                        [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                        AspNode = obj.parent.Ses.nodes(Treepath);
                        if strcmp(AspNode.type,'Aspect') || strcmp(AspNode.type,'MAspect')
                            AspNode.aspectrule(selRows+1,:) = [];
                        end
                    end
                    %------------------------------------------------------------------
                    obj.deleteTableRow( obj.hData.Tables.mtable3,selRows + 1 )
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    if selRows(1)==0
                        obj.hData.Tables.jtable3.setRowSelectionInterval(selRows(1),selRows(1))
                    else
                        obj.hData.Tables.jtable3.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                    end
                end     
                %------ Update the List of selectable Node for Selection Constraints ------
                obj.parent.Settings.getListOfSelectableNodes  
                %--------------------------------------------------------------------------
                %-----check if all descissions are made, if not color icon red-------------
                allNodes = values(obj.parent.Ses.nodes);
                obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                %--------------------------------------------------------------------------            
                case 'Coupling'
                switch nodeObj.type
                    case 'Aspect'
                    selRowCount = obj.hData.Tables.jtable4.getSelectedRowCount;
                    %sometimes no selection
                    if selRowCount==0 || (ischar(nodeObj.coupling) || get(obj.hData.hb76x,'Value'))
                        return
                    end
                    RowCount = obj.hData.Tables.jtable4.getRowCount;            
                    selRows = obj.hData.Tables.jtable4.getSelectedRows;
                    if RowCount-selRowCount == 0
                        set(obj.hData.Tables.mtable4,'Data',cell(1,4))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        nodeObj.coupling = cell(1,4);
                        obj.hData.Tables.jtable4.setRowSelectionInterval(0,0)
                    else
                        nodeObj.coupling(selRows+1,:) = [];
                        obj.deleteTableRow( obj.hData.Tables.mtable4,selRows + 1 )
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        if selRows(1)==0
                            obj.hData.Tables.jtable4.setRowSelectionInterval(selRows(1),selRows(1))
                        else
                            obj.hData.Tables.jtable4.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                        end
                    end        
                    case 'MAspect'
                    selRowCount = obj.hData.Tables.jtable5.getSelectedRowCount;
                    %sometimes no selection
                    if selRowCount==0 || (ischar(nodeObj.coupling) || get(obj.hData.hb76x,'Value'))
                        return
                    end
                    str = get(obj.hData.hb95x,'String'); % 95.) popUpMenu select Nr of Replication                       
                    val = get(obj.hData.hb95x,'Value');
                    NumOfRep = str2double(str{val});
                    RowCount = obj.hData.Tables.jtable5.getRowCount;            
                    selRows = obj.hData.Tables.jtable5.getSelectedRows;
                    if RowCount-selRowCount == 0
                        set(obj.hData.Tables.mtable5,'Data',cell(1,4))
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        nodeObj.coupling{NumOfRep} = cell(1,4);
                        obj.hData.Tables.jtable5.setRowSelectionInterval(0,0)
                    else
                        nodeObj.coupling{NumOfRep}(selRows+1,:) = [];
                        obj.deleteTableRow( obj.hData.Tables.mtable5,selRows + 1 )
                        pause(0.1)
                        drawnow limitrate nocallbacks
                        if selRows(1)==0
                            obj.hData.Tables.jtable5.setRowSelectionInterval(selRows(1),selRows(1))
                        else
                            obj.hData.Tables.jtable5.setRowSelectionInterval(selRows(1)-1,selRows(1)-1)
                        end
                    end        
                end
            end
            
        end%function
        
        %% ButtonCallback OK - Save Property %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function OKButtonCallback( obj,~,~,Property )
            switch Property
                case 'Attributes'
                    if get(obj.hData.jhb22x,'Enabled') == false % 22.) Pushbuttons "OK"        
                        return
                    end
                    selRow = obj.hData.Tables.jtable1.getSelectedRow;
                    attName = get(obj.hData.jhb11x,'Text');     %11.) Edit Attribute Name  
                    attValue = get(obj.hData.jhb16x,'Text');     %16.) Edit Attribute Value   
                    tableRow = {attName,attValue};
                    %get identic Entities
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    Name = obj.getName(selNode);
                    allNodes = selNode.getRoot.depthFirstEnumeration;
                    [Count, equalNodes] = obj.nameExist(Name, allNodes);
                    for i=1:Count
                        nextEnt = equalNodes{i};
                        [Treepath] = obj.parent.Ses.getTreepath(nextEnt);  %treepath from hierarchyNode    
                        EntNode = obj.parent.Ses.nodes(Treepath);
                        olddata = EntNode.attributes;
                        if selNode.equals(nextEnt)
                            olddata(selRow+1,:) = tableRow;
                        else
                            olddata(selRow+1,1) = tableRow(1);
                        end
                        NewData = olddata;
                        EntNode.attributes = NewData;
                    end
                    %Update tabledata
                    Data = get(obj.hData.Tables.mtable1,'Data');
                    Data(selRow+1,:) = tableRow;
                    set(obj.hData.Tables.mtable1,'Data',Data)
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    obj.hData.Tables.jtable1.setRowSelectionInterval(selRow,selRow)
                    
                case 'Specrule'
                    if get(obj.hData.jhb40x,'Enabled') == false % 40.) Pushbuttons "OK"        
                        return
                    end        
                    % val = get(obj.hData.hb29x,'Value');  % 29.) Checkbox functional
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    [Treepath] = obj.parent.Ses.getTreepath(selNode);  %treepath from hierarchyNode    
                    SpecNode = obj.parent.Ses.nodes(Treepath);
                    condition = get(obj.hData.jhb34x,'Text');   %34.) Edit Condition 
                    PopupStr = get(obj.hData.hb32x,'String');   % 32.) PopupMenu Selection
                    PopupVal = get(obj.hData.hb32x,'Value');
                    selection = PopupStr{PopupVal};
                    selRow = obj.hData.Tables.jtable2.getSelectedRow;
                    tableRow = {selection,condition};
                    SpecNode.specrule(selRow+1,:) = tableRow;
                    %Update tabledata
                    Data = get(obj.hData.Tables.mtable2,'Data');
                    Data(selRow+1,:) = tableRow;
                    set(obj.hData.Tables.mtable2,'Data',Data)
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    obj.hData.Tables.jtable2.setRowSelectionInterval(selRow,selRow)
                    %------ Update the List of selectable Node for Selection Constraints ------
                    obj.parent.Settings.getListOfSelectableNodes  
                    %--------------------------------------------------------------------------               
                    %-----check if all descissions are made, if not color icon red-------------
                    allNodes = values(obj.parent.Ses.nodes);
                    obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                    %--------------------------------------------------------------------------
                
                case 'Aspectrule'
                    if get(obj.hData.jhb58x,'Enabled') == false % 58.) Pushbuttons "OK"        
                        return
                    end        
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    condition = get(obj.hData.jhb52x,'Text');   %52.) Edit Condition 
                    PopupStr = get(obj.hData.hb50x,'String');   % 50.) PopupMenu Selection
                    PopupVal = get(obj.hData.hb50x,'Value');
                    selection = PopupStr{PopupVal};
                    selRow = obj.hData.Tables.jtable3.getSelectedRow;
                    tableRow = {selection,condition};
                    %Save Aspectrule to all (M)Aspect Siblings-------------------------
                    Siblings = selNode.getParent.children;
                    %find AspectNodes in Siblings
                    while Siblings.hasMoreElements
                        curNode = Siblings.nextElement;
                        [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                        AspNode = obj.parent.Ses.nodes(Treepath);
                        if strcmp(AspNode.type,'Aspect') || strcmp(AspNode.type,'MAspect')
                            AspNode.aspectrule(selRow+1,:) = tableRow;
                        end
                    end
                    %------------------------------------------------------------------
                    %Update tabledata
                    Data = get(obj.hData.Tables.mtable3,'Data');
                    Data(selRow+1,:) = tableRow;
                    set(obj.hData.Tables.mtable3,'Data',Data)
                    pause(0.1)
                    drawnow limitrate nocallbacks
                    obj.hData.Tables.jtable3.setRowSelectionInterval(selRow,selRow)
                    %------ Update the List of selectable Node for Selection Constraints ------
                    obj.parent.Settings.getListOfSelectableNodes  
                    %--------------------------------------------------------------------------        
                    %-----check if all descissions are made, if not color icon red-------------
                    allNodes = values(obj.parent.Ses.nodes);
                    obj.parent.Hierarchy.validateDescissionNodes(allNodes);
                    %--------------------------------------------------------------------------
                
                case 'AspectInheritance'   
                    if get(obj.hData.jhb52dx,'Enabled') == false % 52d.) Pushbuttons "OK"        
                        return
                    end 
                    Priority = get(obj.hData.jhb52cx,'Text');  % JEdit Priority (Global)
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    [Treepath] = obj.parent.Ses.getTreepath(selNode);  %treepath from hierarchyNode    
                    AspNode = obj.parent.Ses.nodes(Treepath);
                    AspNode.priority = Priority;
                    
                    
                case 'Coupling'
                    val = get(obj.hData.hb76x,'Value');  % 64.) Checkbox functional    
                        
                    if get(obj.hData.jhb80x,'Enabled') == false % 80.) Pushbuttons "OK"        
                        return
                    end  
                    
                    %set(obj.hData.hb77x,'String',[]); %delete SES Function String
                    
                    
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    [Treepath] = obj.parent.Ses.getTreepath(selNode);  %treepath from hierarchyNode    
                    AspNode = obj.parent.Ses.nodes(Treepath);
                    switch val
                        case 1 %function
                        %         PopupVal = get(obj.hData.hb77x,'Value');  % 77.) PopupMenu Selected Function
                        FunStr = get(obj.hData.jhb77x,'Text'); % 77.) Edit Function Input
                        %         selStr = PopupStr{PopupVal};
                        %         InputStr = get(obj.hData.jhb79x,'Text');  %79.) Edit Input Parameters         
                        %         Fun = struct('FunName',selStr,'InputParam',InputStr);
                        AspNode.coupling = FunStr;
                        %reset generell aspectrule + table
                        set(obj.hData.hb69x,'String', '')   % 69.) Edit Output Port
                        set(obj.hData.hb74x,'String', '')   % 74.) Edit Input Port
                        set(obj.hData.hb67x,'Value',  1)    % 67.) PopupMenu Source Component
                        set(obj.hData.hb72x,'Value',  1)    % 72.) PopupMenu Sink Component
                        switch AspNode.type     
                            case 'Aspect'
                                set(obj.hData.Tables.mtable4,'Data',cell(1,4)) % 27) generating table in Specrule
                                pause(0.1)
                                drawnow limitrate nocallbacks
                                obj.hData.Tables.jtable4.setRowSelectionInterval(0,0)
                            case 'MAspect'
                                set(obj.hData.Tables.mtable5,'Data',cell(1,4)) % 27) generating table in Specrule
                                pause(0.1)
                                drawnow limitrate nocallbacks
                                obj.hData.Tables.jtable5.setRowSelectionInterval(0,0)
                        end
                        
                        case 0 %generell coupling
                            SourceCompStr = get(obj.hData.hb67x,'String');  % 67.) PopupMenu Source Component
                            SourceCompVal = get(obj.hData.hb67x,'Value');  % 67.) PopupMenu Source Component
                            SourceComp = SourceCompStr{SourceCompVal};
                            SinkCompStr = get(obj.hData.hb72x,'String');  % 72.) PopupMenu Sink Component
                            SinkCompVal = get(obj.hData.hb72x,'Value');   % 72.) PopupMenu Sink Component
                            SinkComp = SinkCompStr{SinkCompVal};
                            Output = get(obj.hData.jhb69x,'Text');   % 69.) Edit Output Port  
                            Input = get(obj.hData.jhb74x,'Text');    % 74.) Edit Input Port 
                            tableRow = {SourceComp,Output,SinkComp,Input};
                            switch AspNode.type
                                case 'Aspect'
                                    if ischar(AspNode.coupling)
                                        AspNode.coupling = cell(1,4);
                                    end        
                                    selRow = obj.hData.Tables.jtable4.getSelectedRow;
                                    AspNode.coupling(selRow+1,:) = tableRow;   %ERRORMESSAGE OCCURRED!!!Subscript indices must either be real positive integers or logicals.
                                    %Update tabledata
                                    Data = get(obj.hData.Tables.mtable4,'Data');
                                    Data(selRow+1,:) = tableRow;
                                    set(obj.hData.Tables.mtable4,'Data',Data)
                                    pause(0.1)
                                    drawnow limitrate nocallbacks
                                    obj.hData.Tables.jtable4.setRowSelectionInterval(selRow,selRow)

                                case 'MAspect'       
                                    if ischar(AspNode.coupling)
                                        intEnd = AspNode.interval(2);
                                        newCoup = cell(1,intEnd);
                                        newCoup = cellfun(@(x) cell(1,4),newCoup,'UniformOutput',false);
                                        AspNode.coupling = newCoup;
                                    end        
                                    selRow = obj.hData.Tables.jtable5.getSelectedRow;
                                    str = get(obj.hData.hb95x,'String'); % 95.) popUpMenu select Nr of Replication                       
                                    val = get(obj.hData.hb95x,'Value');
                                    NumOfRep = str2double(str{val});
                                    AspNode.coupling{NumOfRep}(selRow+1,:) = tableRow;
                                    %Update tabledata
                                    Data = get(obj.hData.Tables.mtable5,'Data');
                                    Data(selRow+1,:) = tableRow;
                                    set(obj.hData.Tables.mtable5,'Data',Data)
                                    pause(0.1)
                                    drawnow limitrate nocallbacks
                                    obj.hData.Tables.jtable5.setRowSelectionInterval(selRow,selRow)
                            end
                            %reset function
                            %         set(obj.hData.hb77x,'Value',1)    % 77.) PopupMenu Selected Function
                            set(obj.hData.hb77x,'String',               [])  % 79.) Edit Function Input
                    end
                    
                case 'NumOfRep'
                    if get(obj.hData.jhb90x,'Enabled') == false % 90.) Pushbuttons "OK"        
                        return
                    end        
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    [Treepath] = obj.parent.Ses.getTreepath(selNode);  %treepath from hierarchyNode    
                    MAspNode = obj.parent.Ses.nodes(Treepath);
                    NumRep = get(obj.hData.jhb84x,'Text');   % 84.) JEdit Variable Name of NrOfRep 
                    %change NumRep/interval properties-----------------------------------------
                    MAspNode.numRep = NumRep;
                    
                case 'CouplingInterval'
                    TxtColor = obj.hData.jhb87x.getForeground;
                    if TxtColor.equals(java.awt.Color(0.5,0.5,0.5))
                        return
                    end
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    [Treepath] = obj.parent.Ses.getTreepath(selNode);  %treepath from hierarchyNode    
                    MAspNode = obj.parent.Ses.nodes(Treepath);
                    newintStart = str2double(get(obj.hData.jhb87x,'Text')); % 87) JEdit Start Interval
                    newintEnd = str2double(get(obj.hData.jhb88x,'Text')); % 88) JEdit End Interval
                    if ~ischar(MAspNode.coupling)
                        %change structure of coupling according to the interval end
                        oldintEnd = MAspNode.interval(2);
                        newCoup = cell(1,newintEnd);
                        newCoup = cellfun(@(x) cell(1,4),newCoup,'UniformOutput',false);
                        if oldintEnd >= newintStart
                            if newintEnd < oldintEnd
                                newCoup(newintStart:newintEnd) = cellfun(@(x,y) MAspNode.coupling{y},newCoup(newintStart:newintEnd),num2cell(newintStart:newintEnd),'UniformOutput',false);
                            else
                                newCoup(newintStart:oldintEnd) = cellfun(@(x,y) MAspNode.coupling{y},newCoup(newintStart:oldintEnd),num2cell(newintStart:oldintEnd),'UniformOutput',false);    
                            end
                        end
                        MAspNode.coupling = newCoup; 
                    end
                    %change interval properties -----------------------------------------------
                    MAspNode.interval = [newintStart,newintEnd];
                    %update coupling-----------------------------------------------------------
                    parentName = obj.getName(selNode.getParent);
                    Children = selNode.children;
                    while Children.hasMoreElements
                        childName = obj.getName(Children.nextElement);
                        for i=1:length(MAspNode.coupling)           
                            DataReal = MAspNode.coupling{i};
                            Data = DataReal;
                            Data(cellfun(@isempty,Data)) = {'0'};
                            Data(strcmp(Data,parentName)) = {'0'};
                            Datarow1 = cellfun(@(x)x(1:end-1),Data(:,1),'UniformOutput',false);
                            Datarow3 = cellfun(@(x)x(1:end-1),Data(:,3),'UniformOutput',false);
                            AspNames = [Datarow1,Datarow3];
                            lastCharrow1 = cellfun(@(x)x(end),Data(:,1),'UniformOutput',false);
                            lastCharrow3 = cellfun(@(x)x(end),Data(:,3),'UniformOutput',false);
                            lastCharrow1 = str2double(cell2mat(lastCharrow1));%instead of str2num 
                            lastCharrow3 = str2double(cell2mat(lastCharrow3));
                            %FEHLER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                            ind1 = strcmp(childName,AspNames(:,1)) & (lastCharrow1<MAspNode.interval(1) | lastCharrow1>MAspNode.interval(2));
                            ind2 = strcmp(childName,AspNames(:,2)) & (lastCharrow3<MAspNode.interval(1) | lastCharrow3>MAspNode.interval(2));
                            ind1u2 = ind1 | ind2;
                            DataReal(ind1u2,:) = [];
                            MAspNode.coupling{i} = DataReal; 
                        end 
                    end
                    obj.UpdatePropertyWindow
            end
            
        end%function
        %% Checkbox Callback switch to functional input for coupling %%%%%%%%%%%%%%
        function CheckboxCallback( obj,hobj,~)
            
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;            
            TP = obj.parent.Ses.getTreepath(selNode);            
            objNode = obj.parent.Ses.nodes(TP); 
                            
            val = get(hobj,'Value');
            
            switch val 
                case 1  
                    set(obj.hData.hb77x,...
                        'Enable',               'on')  % 77.) Edit Function input 
                    set(get(obj.hData.hp65x.Children,'Children'),...
                        'Enable',               'off')  % 65.) Panel Source 
%                     set(get(obj.hData.hp70x.Children,'Children'),...
%                         'Enable',               'off')  % 70.) Panel Sink
                    if strcmp(objNode.type,'Aspect')
                        obj.hData.Tables.jtable4.setEnabled(false)
                    elseif strcmp(objNode.type,'MAspect')
%                         if ~isempty(get(obj.hData.jhb77x,'Text'))
%                             objNode.coupling = get(obj.hData.jhb77x,'Text');
%                         end
                        obj.hData.Tables.jtable5.setEnabled(false)
                        set(obj.hData.hb95x,...
                            'Enable',               'off')  % 95.) popUpMenu select Nr of Replication
                        set(obj.hData.jhb88x,...
                            'Enabled',              false) % 88) JEdit End Interval
                        set(obj.hData.jhb87x,...
                        	'Enabled',              false) % 87) JEdit Start Interval
                    end
                case 0 
                    set(obj.hData.hb77x,...
                        'Enable',                   'off')  % 77.) Edit Function input
                    set(obj.hData.hb77x,'String',               [])
                    set(get(obj.hData.hp65x.Children,'Children'),...
                        'Enable',                   'on')   % 65.) Panel Source                     
%                     set(get(obj.hData.hp70x.Children,'Children'),...
%                         'Enable',                   'on')  % 65.) Panel Sink
                    if strcmp(objNode.type,'Aspect')
                        obj.hData.Tables.jtable4.setEnabled(true)
                        if ischar(objNode.coupling)
                            objNode.coupling = cell(1,4);
                        end
                    elseif strcmp(objNode.type,'MAspect')
                        if ischar(objNode.coupling)
                            intEnd = objNode.interval(2);
                            Coupling = cell(1,intEnd);
                            objNode.coupling = cellfun(@(x) cell(1,4),Coupling,'UniformOutput',false);
                        end
                        obj.hData.Tables.jtable5.setEnabled(true)
                        set(obj.hData.hb95x,...
                            'Enable',               'on')  % 95.) popUpMenu select Nr of Replication
                        set(obj.hData.jhb88x,...
                            'Enabled',              true) % 88) JEdit End Interval
                        set(obj.hData.jhb87x,...
                            'Enabled',              true) % 87) JEdit Start Interval
                    end
            end
            obj.checkProperty('','','Coupling')  
            
        end
        %% PopUpMenu select NrOfRep in MAspect-Couplings%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function selectNumOfRep(obj)
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            TP = obj.parent.Ses.getTreepath(selNode);
            objNode = obj.parent.Ses.nodes(TP);
            if ~isstruct(objNode.coupling)
                str = get(obj.hData.hb95x,'String'); % 95.) popUpMenu select Nr of Replication                       
                val = get(obj.hData.hb95x,'Value');
                NumOfRep = str2double(str{val});
                %set Tabledata Coupling of selected Node for specified NrOfRep
                set(obj.hData.Tables.mtable5,'Data',objNode.coupling{NumOfRep})
                pause(0.1)
                drawnow limitrate nocallbacks
                if obj.hData.Tables.jtable5.getSelectedRow==0
                    obj.Selectioncbck('','',obj.hData.Tables.jtable5)
                else
                    obj.hData.Tables.jtable5.setRowSelectionInterval(0,0) 
                end
            end 
            
        end%function
        %% Update the Properties Window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function UpdatePropertyWindow(obj)
            %get selected Node from Hierarchy
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            if ~selNode.isRoot
                TP = obj.parent.Ses.getTreepath(selNode);
                objNode = obj.parent.Ses.nodes(TP); 
            end
            level = selNode.getLevel;  
            if level == 0    %Root
                set(obj.mainPanel,'SelectedChild',4);

            elseif level/2 == round(level/2)    %Descriptive Node                               
                Type = obj.parent.Ses.getType(selNode);                                             
                switch Type
                    case 'Aspect'
                        obj.Selectioncbck('','',obj.hData.Tables.jtable3)  %FixME force update Aspectrule-Tab 
                        obj.hData.ComAsp.setText(objNode.comment);
                        
                        set(obj.mainPanel,'SelectedChild',3);
                        set(obj.CP_M_ASP,'SelectedChild',1);
                        set(obj.hData.MAspIntHBox,'Visible','off')
                        
                        if get(obj.AspectTabPanel,'SelectedChild') == 3 
                            set(obj.AspectTabPanel,'SelectedChild',2)
                        end
                        set(obj.AspectTabPanel,'TabEnable',{'on' 'on' 'off' 'on'});
                        %if get(obj.AspectTabPanel,'SelectedChild') == 1 %Activate Aspectrule Panels
                            %find AspectNodes in Siblings
                            Siblings = selNode.getParent.children;
                            AspCount = 0;
                            while Siblings.hasMoreElements
                                curNode = Siblings.nextElement;
                                Treepath = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                                node = obj.parent.Ses.nodes(Treepath);
                                if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                    AspCount = AspCount + 1;
                                end
                            end
                            %set Tabledata Specrule of selected Node 
                            set(obj.hData.Tables.mtable3,'Data',objNode.aspectrule)
                            pause(0.1)
                            drawnow limitrate nocallbacks
                            %this is necessary when data doesnt change from one node to another
                            %than SelectionChange Function will not fire -> so doing it programatically
                            if obj.hData.Tables.jtable3.getSelectedRow==0
                                obj.Selectioncbck('','',obj.hData.Tables.jtable3)
                            else
                                obj.hData.Tables.jtable3.setRowSelectionInterval(0,0) 
                            end
%                           %show Priority of AspNode
                            set(obj.hData.hb52cx,'String',objNode.priority)  %52c.) Edit Priority (Global)    
 
                            %Check Property Update
                            obj.checkProperty([],[],'Aspectrule')
                            obj.checkProperty([],[],'AspectInheritance')                       
                       
                            set(obj.CP_M_ASP,'SelectedChild',1);
                            set(obj.hData.MAspIntHBox,'Visible','off')
                            
                            if ischar(objNode.coupling) % function
                                set(obj.hData.hb76x,'Value',1); % 64.) Checkbox functional
                                obj.CheckboxCallback(obj.hData.hb76x,[])
                                set(obj.hData.Tables.mtable4,'Data',cell(1,4))
                                pause(0.1)
                                drawnow limitrate nocallbacks
                                %this is necessary when data doesnt change from one node to another
                                %than SelectionChange Function will not fire -> so doing it programatically
                                if obj.hData.Tables.jtable4.getSelectedRow==0
                                    obj.Selectioncbck('','',obj.hData.Tables.jtable4)
                                else
                                    obj.hData.Tables.jtable4.setRowSelectionInterval(0,0) 
                                end
                                %find the right value
                                %                 FunName = objNode.coupling.FunName;
                                %                 PopupStrings = get(obj.hData.hb77x,'String');  % 77.) PopupMenu Selected Function
                                %                 rightVal = find(strcmp(FunName,PopupStrings));   
                                set(obj.hData.hb77x,'String',objNode.coupling)   % 77.) Edit Function input 
                                %                 set(obj.hData.hb79x,'String',objNode.coupling.InputParam)   %79.) Edit Input Parameters Type-Function 
                                %                 set(obj.hData.hp59x,'Visible','off')   % 59.) Panel Coupling table inspector
                            else % generell Coupling
                                %set Tabledata Specrule of selected Node 
                                set(obj.hData.hb76x,'Value',0); % 64.) Checkbox functional
                                obj.CheckboxCallback(obj.hData.hb76x,[]) 
                                set(obj.hData.Tables.mtable4,'Data',objNode.coupling)
                                set(obj.hData.hb77x,'String',[])   % 77.) Edit Function input 
                                drawnow limitrate nocallbacks,pause(0.01)
                                %this is necessary when data doesnt change from one node to another
                                %than SelectionChange Function will not fire -> so doing it programatically
                                if obj.hData.Tables.jtable4.getSelectedRow==0
                                    obj.Selectioncbck('','',obj.hData.Tables.jtable4)
                                else 
                                    if obj.hData.Tables.jtable4.getRowCount == 0 % FixME Birger 19.04.2017 
                                        addRow( obj,[],[],'Coupling' ) 
                                    end
                                    
                                    obj.hData.Tables.jtable4.setRowSelectionInterval(0,0)
                                end                                
                            end
                            
                            obj.checkProperty([],[],'Coupling')
                        %end
                        
                    case 'Spec'
                        %set Tabledata Specrule of selected Node 
                        set(obj.hData.Tables.mtable2,'Data',objNode.specrule)
                        obj.hData.ComSpec.setText(objNode.comment);
                        drawnow limitrate nocallbacks,pause(0.01)
                        %this is necessary when data doesnt change from one node to another
                        %than SelectionChange Function will not fire -> so doing it programatically
                        if obj.hData.Tables.jtable2.getSelectedRow==0
                            obj.Selectioncbck('','',obj.hData.Tables.jtable2)
                        else
                            obj.hData.Tables.jtable2.setRowSelectionInterval(0,0) 
                        end
                        
                        set(obj.mainPanel,'SelectedChild',2);
                        obj.checkProperty([],[],'Specrule') 
                        
                    case 'MAspect'
                        set(obj.mainPanel,'SelectedChild',3);
                        set(obj.CP_M_ASP,'SelectedChild',2); 
                        set(obj.hData.MAspIntHBox,'Visible','on')
                        set(obj.AspectTabPanel,'TabEnable',{'on' 'on' 'on' 'on'}); 
                        
                        obj.hData.ComAsp.setText(objNode.comment);

                        obj.Selectioncbck('','',obj.hData.Tables.jtable3)  %FixME force update Aspectrule-Tab 
                        
                        %if get(obj.AspectTabPanel,'SelectedChild') == 1 %find AspectNodes in Siblings
                            Siblings = selNode.getParent.children;
                            AspCount = 0;
                            while Siblings.hasMoreElements
                                curNode = Siblings.nextElement;
                                [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                                node = obj.parent.Ses.nodes(Treepath);
                                if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                    AspCount = AspCount + 1;
                                end
                            end
                            %set Tabledata Specrule of selected Node 
                            set(obj.hData.Tables.mtable3,'Data',objNode.aspectrule)
                            drawnow limitrate nocallbacks,pause(0.01)
                            %this is necessary when data doesnt change from one node to another
                            %than SelectionChange Function will not fire -> so doing it programatically
                            if obj.hData.Tables.jtable3.getSelectedRow==0
                                obj.Selectioncbck('','',obj.hData.Tables.jtable3)
                            else
                                obj.hData.Tables.jtable3.setRowSelectionInterval(0,0) 
                            end
                            %show Priority of AspNode
                            set(obj.hData.hb52cx,'String',objNode.priority)  %52c.) Edit Priority (Global)  
                                                       
                            obj.checkProperty([],[],'Aspectrule')
                            
                        %elseif get(obj.AspectTabPanel,'SelectedChild') == 3
                            TP = obj.parent.Ses.getTreepath(selNode);
                            nodeObj = obj.parent.Ses.nodes(TP);  
                            VarName = nodeObj.numRep;
                            set(obj.hData.hb84x,'String',VarName)  % 84.) Edit Variable Name of NrOfRep   
                            
                            obj.checkProperty([],[],'NumOfRep')
                            
                       
                            %Update popupmenu "select Nr of Replication"
                            TP = obj.parent.Ses.getTreepath(selNode);
                            nodeObj = obj.parent.Ses.nodes(TP);
                            startInt = nodeObj.interval(1);
                            endInt = nodeObj.interval(2);    
                            set(obj.hData.hb87x,'String',startInt)% 87.) Edit Interval Start
                            set(obj.hData.hb88x,'String',endInt)% 88.) Edit Interval End
                            if ischar(objNode.coupling) % function
                                set(obj.hData.hb76x,'Value',1); % 64.) Checkbox functional
                                obj.CheckboxCallback( obj.hData.hb76x,[])
                                set(obj.hData.Tables.mtable5,'Data',cell(1,4))
                                drawnow limitrate nocallbacks,pause(0.01)
                                %this is necessary when data doesnt change from one node to another
                                %than SelectionChange Function will not fire -> so doing it programatically
                                if obj.hData.Tables.jtable5.getSelectedRow==0
                                    obj.Selectioncbck('','',obj.hData.Tables.jtable5)
                                else
                                    obj.hData.Tables.jtable5.setRowSelectionInterval(0,0) 
                                end
                                set(obj.hData.hb77x,'String',objNode.coupling)   % 77.) Edit Function input 
                                set(obj.hData.hb95x,'String',num2cell(objNode.interval(1):objNode.interval(2)));  % 95.) popUpMenu select Nr of Replication 
                            else % generell Coupling
                                val = get(obj.hData.hb95x,'Value');  % 95.) popUpMenu select Nr of Replication 
                                if val > length(objNode.interval(1):objNode.interval(2))
                                    set(obj.hData.hb95x,'Value',1)
                                    val = 1;
                                end
                                set(obj.hData.hb95x,'String',num2cell(objNode.interval(1):objNode.interval(2)));  % 95.) popUpMenu select Nr of Replication                       
                                str = get(obj.hData.hb95x,'String');
                                NumOfRep = str2double(str{val});
                                
                                %set Tabledata Specrule of selected Node 
                                set(obj.hData.Tables.mtable5,'Data',objNode.coupling{NumOfRep})
                                drawnow limitrate nocallbacks,pause(0.01)
                                %this is necessary when data doesnt change from one node to another
                                %than SelectionChange Function will not fire -> so doing it programatically
                                if obj.hData.Tables.jtable5.getSelectedRow==0
                                    obj.Selectioncbck('','',obj.hData.Tables.jtable5)
                                else
                                    obj.hData.Tables.jtable5.setRowSelectionInterval(0,0) 
                                end
                                set(obj.hData.hb76x,'Value',0); % 64.) Checkbox functional
                                obj.CheckboxCallback( obj.hData.hb76x,[]) 
                                set(obj.hData.hb77x,'String',[])   % 77.) Edit Function input 
                                
                                obj.checkProperty([],[],'Coupling')
                            end                             
                otherwise
                    set(obj.mainPanel,'SelectedChild',4);
                end
            else    %Entity Node
                obj.hData.ComEntity.setText(objNode.comment);
                
                %set Tabledata Attributes of selected Node 
                Attributes = objNode.attributes;
                Data = cell(size(Attributes,1),2);
                for i=1:size(Attributes,1)
                    if iscell(Attributes{i,2})
                        Data(i,1) = Attributes(i,1);
                        value = [Attributes{i,2}{1},'(',Attributes{i,2}{2},')'];
                        Data{i,2} = value;
                    else
                        Data(i,:) = Attributes(i,:);  
                    end
                end
                set(obj.hData.Tables.mtable1,'Data',Data)
                %this is necessary when data doesnt change from one node to another
                %than SelectionChange Function will not fire -> so doing it programatically
                
                drawnow limitrate nocallbacks,pause(0.1)
                
                set(obj.mainPanel,'SelectedChild',1);
                obj.hData.Tables.jtable1.setRowSelectionInterval(0,0)                
                                
                obj.checkProperty([],[],'Attributes')  
            end
            
        end %UpdatePropertyWindow
        
        %% Check Property -> Enable the OK Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function checkProperty( obj,~,~,Property )
            switch Property
                case 'Attributes'
                    % check Attribute name ---------------------------------------------------
                    attname = get(obj.hData.jhb11x,'Text');     %11.) Edit Attribute Name
                    Data = get(obj.hData.Tables.mtable1,'Data');
                    savedAttnames = Data(:,1);
                    selRow = obj.hData.Tables.jtable1.getSelectedRow;
                    if selRow < 0, selRow = 0;end %FixME
                    savedAttnames(selRow+1,:) = [];
                    savedAttnames(cellfun(@isempty,savedAttnames)) = [];  %delete empty cell entries
                    VarExist = ismember(attname,savedAttnames);
                    nameOK = isvarname(attname) && ~VarExist;
                    %look for inheritance variables parent Entities!!!!
                    % check Attribute value --------------------------------------------------
                    Valtext = get(obj.hData.jhb16x,'Text');     %16.) Edit Value non-functional
                    obj.parent.Parser.TranslationUnit(Valtext,'AttributValue',obj.parent.Ses)
                    valOK = ~obj.parent.Parser.Error;
                    %check if father is MAspect and parser ruleMultiOutputFunction isok
                    if ~valOK
                        ParentOfselNode = obj.parent.Hierarchy.hData.Trees.selectedNode1.getParent;
                        fatherType = obj.parent.Ses.getType(ParentOfselNode);
                        if strcmp(fatherType,'MAspect')
                            obj.parent.Parser.TranslationUnit(Valtext,'MultiOutputFunction',obj.parent.Ses)
                            valOK = ~obj.parent.Parser.Error;
                        end
                    end
                    % Enable OK Button
                    if nameOK && valOK
                        set(obj.hData.jhb22x,'Enabled',true)  % 22.) Pushbuttons "OK"
                    else
                        set(obj.hData.jhb22x,'Enabled',false)  % 22.) Pushbuttons "OK"
                    end
                    
                case 'Specrule'
                    % check generell Input
                    SelOK = get(obj.hData.hb32x,'Value') ~= 1; % 32.) PopupMenu Selection
                    %check Condition
                    text = get(obj.hData.jhb34x,'Text');  %34.) Edit Condition
                    obj.parent.Parser.TranslationUnit(text,'Condition',obj.parent.Ses)
                    CondOK = ~obj.parent.Parser.Error;
                    % Enable OK Button
                    if SelOK && CondOK
                        set(obj.hData.jhb40x,'Enabled',true)  % 40.) Pushbuttons "OK"
                    else
                        set(obj.hData.jhb40x,'Enabled',false)  % 40.) Pushbuttons "OK"
                    end
                    
                case 'Aspectrule'
                    % check generell Input
                    SelOK = get(obj.hData.hb50x,'Value') ~= 1; % 50.) PopupMenu Selection
                    %check Condition
                    text = get(obj.hData.jhb52x,'Text');  %52.) Edit Condition
                    obj.parent.Parser.TranslationUnit(text,'Condition',obj.parent.Ses)
                    CondOK = ~obj.parent.Parser.Error;
                    % Enable OK Button
                    if SelOK && CondOK
                        set(obj.hData.jhb58x,'Enabled',true)  % 58.) Pushbuttons "OK"
                    else
                        set(obj.hData.jhb58x,'Enabled',false)  % 58.) Pushbuttons "OK"
                    end
                    
                case 'AspectInheritance'
                    text = get(obj.hData.jhb52cx,'Text');  %52c.) Edit Priority (Global)
                    obj.parent.Parser.TranslationUnit(text,'Priority',obj.parent.Ses)
                    PrioOK = ~obj.parent.Parser.Error;
                    % Enable OK Button
                    if PrioOK
                        set(obj.hData.jhb52dx,'Enabled',true)  % 58.) Pushbuttons "OK"
                    else
                        set(obj.hData.jhb52dx,'Enabled',false)  % 58.) Pushbuttons "OK"
                    end
                    
                case 'Coupling'
                    val = get(obj.hData.hb76x,'Value');  % 64.) Checkbox functional
                    switch val
                        case 1 %Function
                            % check Functional Input
                            inputText = get(obj.hData.jhb77x,'Text');  % 77.) Edit Function input
                            obj.parent.Parser.TranslationUnit(inputText,'CouplingFunction',obj.parent.Ses,'Children','Parent')
                            funOK = ~obj.parent.Parser.Error;
                            % Enable OK Button
                            if funOK
                                set(obj.hData.jhb80x,'Enabled',true)   % 80.) Pushbutton "OK"
                            else
                                set(obj.hData.jhb80x,'Enabled',false)  % 80.) Pushbutton "OK"
                            end
                        case 0
                            % generell Coupling
                            sourceVal = get(obj.hData.hb67x,'Value');  % 67.) PopupMenu Source Component
                            sourceStr = get(obj.hData.hb67x,'String');
                            sourceComp = sourceStr{sourceVal};
                            sinkVal = get(obj.hData.hb72x,'Value');    % 72.) PopupMenu Sink Component
                            sinkStr = get(obj.hData.hb72x,'String');
                            sinkComp = sinkStr{sinkVal};
                            Output = get(obj.hData.jhb69x,'Text');      % 69.) Edit Output Port
                            Input = get(obj.hData.jhb74x,'Text');      % 74.) Edit Input Port
                            %Empty fields
                            isEmptyRow = sourceVal==1 || sinkVal==1 || isempty(Output) || isempty(Input);
                            %identic Row
                            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                            type = obj.parent.Ses.getType(selNode);
                            switch type
                                case 'Aspect'
                                    Data = get(obj.hData.Tables.mtable4,'Data'); % 62) generating table in Coupling
                                    selRow = obj.hData.Tables.jtable4.getSelectedRow;
                                case 'MAspect'
                                    Data = get(obj.hData.Tables.mtable5,'Data'); % 62) generating table in Coupling
                                    selRow = obj.hData.Tables.jtable5.getSelectedRow;
                            end
                            InputRow = {sourceComp,Output,sinkComp,Input};
                            isIdenticRow = false;
                            try
                                for i=1:size(Data,1)
                                    if ~isempty(Data{i,1}) && i~=selRow+1
                                        isIdenticRow = ~ismember(false,strcmp(InputRow,Data(i,:)));
                                    end
                                    if isIdenticRow
                                        break
                                    end
                                end
                            catch %FixMe Got Error when chancing selected node to fast with arrow-keys
                            end
                            %equal Port
                            if sourceVal==sinkVal
                                isEqualPort = strcmp(Output,Input);
                            else
                                isEqualPort = false;
                            end
                            % Enable OK Button
                            if isEmptyRow || isIdenticRow || isEqualPort
                                set(obj.hData.jhb80x,'Enabled',false)   % 80.) Pushbutton "OK"
                            else
                                set(obj.hData.jhb80x,'Enabled',true)  % 80.) Pushbutton "OK"
                            end
                    end
                    
                case 'NumOfRep'
                    VarName = get(obj.hData.jhb84x,'Text'); % 84) JEdit Variable Name of NrOfRep
                    %NumRep has almost the same rule like Priority (difference: NumRep
                    %can also be empty), so the same Parserrule can be used
                    obj.parent.Parser.TranslationUnit(VarName,'Priority',obj.parent.Ses)
                    NumRepOK = ~obj.parent.Parser.Error;
                    if ( NumRepOK || isempty(VarName) )
                        set(obj.hData.jhb90x,'Enabled',true)
                    else
                        set(obj.hData.jhb90x,'Enabled',false)
                    end
                case 'CouplingInterval'
                    startInt = get(obj.hData.jhb87x,'Text'); % 87) JEdit Start Interval
                    endInt = get(obj.hData.jhb88x,'Text'); % 88) JEdit End Interval
                    for i=1:length(startInt)
                        StartisIntNum = ~isnan(str2double(startInt(i))) && isnumeric(str2double(startInt));
                        if ~StartisIntNum
                            break
                        end
                    end
                    for i=1:length(endInt)
                        EndisIntNum = ~isnan(str2double(endInt(i))) && isnumeric(str2double(endInt));
                        if ~EndisIntNum
                            break
                        end
                    end
                    if str2double(startInt)>0 &&...                 %cannot start with zero
                            ~isempty(startInt) && StartisIntNum &&...   %not empty or an Integer number
                            ~isempty(endInt) && EndisIntNum             %not empty or an Integer number
                        if str2double(endInt) < str2double(startInt) %start must be smaller than end
                            %                set(obj.hData.jhb90x,'Enabled',false)
                            obj.hData.jhb87x.setForeground(java.awt.Color(0.5,0.5,0.5))
                            obj.hData.jhb88x.setForeground(java.awt.Color(0.5,0.5,0.5))
                        else
                            %                set(obj.hData.jhb90x,'Enabled',true)
                            obj.hData.jhb87x.setForeground(java.awt.Color(0,0,0))
                            obj.hData.jhb88x.setForeground(java.awt.Color(0,0,0))
                        end
                    else
                        %             set(obj.hData.jhb90x,'Enabled',false)
                        obj.hData.jhb87x.setForeground(java.awt.Color(0.5,0.5,0.5))
                        obj.hData.jhb88x.setForeground(java.awt.Color(0.5,0.5,0.5))
                    end
            end
            
            obj.parent.DebugView.updateWindow();            
        end%function  
        
        %% SelectionChangeFcn Tables in Properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        function Selectioncbck(obj,~,~,jtable)
            try         
                if jtable.equals(obj.hData.Tables.jtable1) %Attributes
                    selRowCount = obj.hData.Tables.jtable1.getSelectedRowCount; 
                    if selRowCount > 1
                        set(obj.hData.hb11x,...
                            'String',               '',...  % 11.) Edit Attribute Name
                            'Enable',               'off')  
                        set(obj.hData.hb16x,...
                            'String',               '',...  % 16.) Edit Value non-functional 
                            'Enable',               'off')
                    elseif selRowCount == 1
                        %update the EditWindow of Attributes --------------------------------------
                        selRow = obj.hData.Tables.jtable1.getSelectedRow;
                        selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                        TP = obj.parent.Ses.getTreepath(selNode);
                        objNode = obj.parent.Ses.nodes(TP);
                        AttName = objNode.attributes{selRow+1,1};
                        AttValue = objNode.attributes{selRow+1,2};
                        set(obj.hData.hb11x,...
                            'String',               AttName,...
                            'Enable',               'on')  %11.) Edit Attribute Name
                        set(obj.hData.hb16x,...
                            'String',               AttValue,...
                            'Enable',               'on')  % 16.) Edit Value non-functional
                    end 
                    
                elseif jtable.equals(obj.hData.Tables.jtable2) %Specrule
                    selRowCount = obj.hData.Tables.jtable2.getSelectedRowCount; 
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    %check if SpecNode has at least one child
                    ChildCount = selNode.getChildCount;
                    if selRowCount > 1 || ChildCount==0       
                        set(obj.hData.hb34x,...
                            'String',               '',...  %34.) Edit Condition
                            'Enable',               'off')  
                        set(obj.hData.hb32x,...
                            'Value',                1,...    % 32.) PopupMenu Selection
                            'Enable',               'off')   
                    elseif selRowCount == 1
                        %update the EditWindow of Specrule ----------------------------------------    
                        selRow = obj.hData.Tables.jtable2.getSelectedRow;
                        selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                        TP = obj.parent.Ses.getTreepath(selNode);
                        objNode = obj.parent.Ses.nodes(TP);
                        Data = get(obj.hData.Tables.mtable2,'Data');
                        Condition = Data(selRow+1,2);
                        Children = objNode.children;
                        DataCol1 = get(obj.hData.Tables.mtable2,'Data');
                        DataCol1 = DataCol1(:,1);
                        DataCol1(cellfun(@isempty,DataCol1)) = [];  %delete empty cell entries
                        ChildrenLeft = setdiff(Children,DataCol1,'stable');
                        ChildrenLeft = [{''},Data{selRow+1,1},ChildrenLeft];
                        %find the right value
                        %update popupstrings to find the right value
                        set(obj.hData.hb32x,...
                            'String',               ChildrenLeft,...  % 32.) PopupMenu Selection
                            'Value',                1) 
                        selSelection = objNode.specrule{selRow+1,1};
                        PopupStrings = get(obj.hData.hb32x,'String');  % 32.) PopupMenu Selection
                        rightVal = find(strcmp(selSelection,PopupStrings));  
                        if isempty(rightVal)
                            rightVal = 1;
                        end
                        %        end
                        set(obj.hData.hb32x,...
                            'String',ChildrenLeft,...  % 32.) PopupMenu Selection
                            'Value',rightVal,...
                            'Enable',               'on') 
                        set(obj.hData.hb34x,...
                            'String',Condition,... %34.) Edit Condition 
                            'Enable',               'on')
                    end
                    
                elseif jtable.equals(obj.hData.Tables.jtable3) %Aspectrule 
                    selRowCount = obj.hData.Tables.jtable3.getSelectedRowCount; 
                    selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                    %check if Number of Aspects <2 than aspectrule is not allowed
                    %find AspectNodes in Siblings
                    Siblings = selNode.getParent.children;
                    AspCount = 0;
                    while Siblings.hasMoreElements
                        curNode = Siblings.nextElement;
                        [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                        node = obj.parent.Ses.nodes(Treepath);
                        if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                            AspCount = AspCount + 1;
                        end
                    end
                    if selRowCount > 1 || AspCount<2       
                        set(obj.hData.hb52x,...
                            'String',               '',...  %52.) Edit Condition
                            'Enable',               'off')  
                        set(obj.hData.hb50x,...
                            'Value',                1,...    % 50.) PopupMenu Selection
                            'Enable',               'off')   
                    elseif selRowCount == 1
                        %update the EditWindow of Specrule ----------------------------------------    
                        %     case 0 %generell value is chosen
                        selRow = obj.hData.Tables.jtable3.getSelectedRow;
                        TP = obj.parent.Ses.getTreepath(selNode);
                        objNode = obj.parent.Ses.nodes(TP);
                        %        set(obj.hData.hb47x,'Enable',               'on')   % 29.) Checkbox functional 
                        %find AspectNodes and MAspectNodes in Siblings
                        Siblings = selNode.getParent.children;
                        AspSiblings = {};
                        while Siblings.hasMoreElements
                            curNode = Siblings.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                            node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(node.type,'Aspect') || strcmp(node.type,'MAspect')
                                AspSiblings = [AspSiblings,node.name];
                            end
                        end       
                        AspSiblings(cellfun(@isempty,AspSiblings)) = [];  %delete empty cell entries
                        Data = get(obj.hData.Tables.mtable3,'Data');
                        Condition = Data(selRow+1,2);
                        DataCol1 = Data(:,1);
                        DataCol1(cellfun(@isempty,DataCol1)) = [];  %delete empty cell entries
                        ChildrenLeft = setdiff(AspSiblings,DataCol1,'stable');
                        ChildrenLeft = [{''},Data{selRow+1,1},ChildrenLeft];
                        %find the right value
                        %update popupstrings to find the right value
                        set(obj.hData.hb50x,...
                            'String',ChildrenLeft,...  % 50.) PopupMenu Selection
                            'Value',1) 
                        selSelection = objNode.aspectrule{selRow+1,1};
                        PopupStrings = get(obj.hData.hb50x,'String');  % 50.) PopupMenu Selection
                        rightVal = find(strcmp(selSelection,PopupStrings));  
                        if isempty(rightVal)
                            rightVal = 1;
                        end
                        %        end
                        set(obj.hData.hb50x,...
                            'String',               ChildrenLeft,...  % 50.) PopupMenu Selection
                            'Value',                rightVal,...
                            'Enable',               'on') 
                        set(obj.hData.hb52x,...
                            'String',               Condition,... %52.) Edit Condition 
                            'Enable',               'on')
                    end
                    
                elseif jtable.equals(obj.hData.Tables.jtable4) %Coupling (Aspect)
                    selRowCount = obj.hData.Tables.jtable4.getSelectedRowCount; 
                    % chooseFun = get(obj.hData.hb76x,'Value');  % 64.) Checkbox functional 
                    if selRowCount > 1 %&& ~chooseFun      
                        set(obj.hData.hb67x,...
                            'Value',                1,...    % 67.) PopupMenu Source Component
                            'Enable',               'off') 
                        set(obj.hData.hb72x,...
                            'Value',                1,...    % 72.) PopupMenu Sink Component
                            'Enable',               'off')                
                        set(obj.hData.hb69x,...
                            'String',               '',...  % 69.) Edit Output Port
                            'Enable',               'off')  
                        set(obj.hData.hb74x,...
                            'String',               '',...  % 74.) Edit Input Port
                            'Enable',               'off')
                    elseif selRowCount == 1 %&& ~chooseFun
                        %update the EditWindow of Coupling ----------------------------------------    
                        %case 0 %generell value is chosen
                        selRow = obj.hData.Tables.jtable4.getSelectedRow;
                        selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                        TP = obj.parent.Ses.getTreepath(selNode);
                        objNode = obj.parent.Ses.nodes(TP);
                        set(obj.hData.hb76x,'Enable',               'on')   % 64.) Checkbox functional 
                        ParentName = char(obj.getName(selNode.getParent));
                        Children = selNode.children;
                        ChildrenNode = {' ',ParentName};
                        %find AspectNodes in Siblings
                        while Children.hasMoreElements
                            curNode = Children.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curNode);  %treepath from hierarchyNode    
                            node = obj.parent.Ses.nodes(Treepath);
                            ChildrenNode = [ChildrenNode,node.name];
                        end
                        if ischar(objNode.coupling)
                            EditOutString = '';
                            EditInString = '';
                            valPopUp1 = 1;
                            valPopUp2 = 1;   
                        else
                            data = get(obj.hData.Tables.mtable4,'Data'); 
                            EditOutString = data(selRow+1,2);
                            EditInString = data(selRow+1,4);
                            valPopUp1 = find(strcmp(data(selRow+1,1),ChildrenNode));
                            if isempty(valPopUp1)
                                valPopUp1 = 1;
                            end       
                            valPopUp2 = find(strcmp(data(selRow+1,3),ChildrenNode));
                            if isempty(valPopUp2)
                                valPopUp2 = 1;
                            end     
                        end
                        set(obj.hData.hb67x,...
                            'Value',                valPopUp1,...    % 67.) PopupMenu Source Component
                            'Enable',               'on',...
                            'String',               ChildrenNode)
                        set(obj.hData.hb72x,...
                            'Value',                valPopUp2,...    % 72.) PopupMenu Sink Component
                            'Enable',               'on',...
                            'String',               ChildrenNode) 
                        set(obj.hData.hb69x,...
                            'String',               EditOutString,... % 69.) Edit Output Port
                            'Enable',               'on')                
                        set(obj.hData.hb74x,...
                            'String',               EditInString,...  % 74.) Edit Input Port
                            'Enable',               'on')                
                    end  
                    
                elseif jtable.equals(obj.hData.Tables.jtable5) %Coupling (MAspect)
                    selRowCount = obj.hData.Tables.jtable5.getSelectedRowCount; 
                    if selRowCount > 1                          
                        set(obj.hData.hb67x,...
                            'Value',                1,...   % 67.) PopupMenu Source Component
                            'Enable',               'off') 
                        set(obj.hData.hb72x,...
                            'Value',                1,...   % 72.) PopupMenu Sink Component
                            'Enable',               'off')                
                        set(obj.hData.hb69x,...
                            'String',               '',...  % 69.) Edit Output Port
                            'Enable',               'off')  
                        set(obj.hData.hb74x,...
                            'String',               '',...  % 74.) Edit Input Port
                            'Enable',               'off')
                    elseif selRowCount == 1
                        %update the EditWindow of Coupling ----------------------------------------    
                        %case 0 %generell value is chosen
                        selRow = obj.hData.Tables.jtable5.getSelectedRow;
                        selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
                        TP = obj.parent.Ses.getTreepath(selNode);
                        objNode = obj.parent.Ses.nodes(TP);
                        %        set(obj.hData.hb76x,'Enable',               'on')   % 64.) Checkbox functional 
                        ParentName = char(obj.getName(selNode.getParent));
                        Children = selNode.children;
                        ChildrenNode = {' ',ParentName};
                        %unued ? startInt = objNode.interval(1);
                        %        endInt = objNode.interval(2);
                        popupStr = get(obj.hData.hb95x,'String');  % 95.) popUpMenu select Nr of Replication                       
                        popupVal = get(obj.hData.hb95x,'Value');  % 95.) popUpMenu select Nr of Replication
                        number = str2double(popupStr{popupVal});
                        while Children.hasMoreElements
                            ChildName = obj.getName(Children.nextElement);
                            for i=1:number
                                ChildrenNode = [ChildrenNode,[ChildName,'_',num2str(i)]];              
                            end                            
                        end
                        if ischar(objNode.coupling)
                            EditOutString = '';
                            EditInString = '';
                            valPopUp1 = 1;
                            valPopUp2 = 1;   
                        else
                            data = get(obj.hData.Tables.mtable5,'Data'); 
                            EditOutString = data(selRow+1,2);
                            EditInString = data(selRow+1,4);
                            valPopUp1 = find(strcmp(data(selRow+1,1),ChildrenNode));
                            if isempty(valPopUp1)
                                valPopUp1 = 1;
                            end       
                            valPopUp2 = find(strcmp(data(selRow+1,3),ChildrenNode));
                            if isempty(valPopUp2)
                                valPopUp2 = 1;
                            end     
                        end
                        set(obj.hData.hb67x,...
                            'Value',valPopUp1,...    % 67.) PopupMenu Source Component
                            'Enable',               'on',...
                            'String',               ChildrenNode)
                        set(obj.hData.hb72x,...
                            'Value',valPopUp2,...    % 72.) PopupMenu Sink Component
                            'Enable',               'on',...
                            'String',ChildrenNode) 
                        set(obj.hData.hb69x,...
                            'String',EditOutString,...  % 69.) Edit Output Port
                            'Enable',               'on')                
                        set(obj.hData.hb74x,...
                            'String',EditInString,...  % 74.) Edit Input Port
                            'Enable',               'on')                
                    end
                end
            catch
            end
            
        end%function  
        
        %% ReturnKeyFcn 
        function ReturnKeyCallback(obj,hobj,evt,action)
            if strcmp(evt.Key,'return')       
                obj.OKButtonCallback(hobj,evt,action)
            end
        end%function 
        
        function updateComment(obj,~,~)
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;            
            TP = obj.parent.Ses.getTreepath(selNode);           
            Type = obj.parent.Ses.getType(selNode);                                             
                switch Type
                    case 'Aspect'
                        comment_str = obj.hData.ComAsp.getText();
                    case 'Spec'
                        comment_str = obj.hData.ComSpec.getText();
                    case 'MAspect'
                        comment_str = obj.hData.ComAsp.getText();
                    case 'Entity'
                        comment_str = obj.hData.ComEntity.getText();
                    otherwise
                        return
                end
            objNode = obj.parent.Ses.nodes(TP);    
            objNode.comment = comment_str;
            
        end%function
    end%methods
end
