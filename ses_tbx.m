classdef ses_tbx < handle

    properties (Hidden) 
        % Entity Structure -------------------------------------------------
        Ses             % contains all Information about ses
        % Programming Surface
        Hierarchy       % contains all obj and methods about hierarchy area
        Props           % contains all obj and methods about Properties
        Settings        % contains all obj and methods about Settings area
        Menu            % contains all obj and methods about Menu area
        
        InfoCenter      % show information about errors, infos, ...
        TreeView        % show the current ses as a tree
        DebugView       % show information about current ses tree
        
        % Parse and Scan
        Parser          % contains the Parser that verify the inputs             
        
        % Others
        hData           % contains all handles to obj of ses_gui
        SavePath        % path where the model has been saved
        OpenedModels    % contains all open Models 
  
        Default         % contains all Default Settings (Colors,Fonts,...)
        GUI_Ver = 'V1.6'% current Version of GUI
    end
    
    methods    
        function obj = ses_tbx( )  % Constructor 
            import ses_gui_components.*
            
            % use this file as entry point 
            path = fileparts(mfilename('fullpath'));
            addpath(genpath(path)) 
            if isempty(which('layoutRoot'))
                if verLessThan('MATLAB','8.4')
                    unzip('GUILayoutToolbox117.zip',[path,'/ExtToolboxes/GUI_Layout_TBX'])
                else
                    unzip('GUILayoutToolbox233.zip',[path,'/ExtToolboxes/GUI_Layout_TBX'])
                end
                addpath(genpath([path,'/ExtToolboxes']));
            end 
                                     
            %%%%%%%%%%%%%% Figure Window %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.Default = DefSett();
            
            obj.hData.f = figure(...                
                'NumberTitle',      'off',...                
                'MenuBar',          'None',...
                'Name',             'SES EDITOR',...
                'Color',            obj.Default.Color.BG_P,...
                'PaperOrientation', 'landscape',...                
                'PaperPositionMode','manual', ...
                'PaperPosition',    [0.65 0.65 28.4 19.6],... %for print 
                'PaperSize',        [29.7 20.1], ...
                'PaperType',        'A4',...
                'UserData',         obj,...
                'DeleteFcn',        @(hobj,evt)delete(obj)); 
            
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');    
            obj.hData.jFrame = get(handle(obj.hData.f),'JavaFrame');
            
            pause(0.05); 
            drawnow; 
            fprintf(' \b');

            try                
                jRootPane = obj.hData.jFrame.fHG2Client.getWindow;
            catch
                jRootPane = obj.hData.jFrame.fHG1Client.getWindow;
            end
            
            try
            statusbarObj = javaObjectEDT('com.mathworks.mwswing.MJStatusBar');            
            jProgressBar = javaObjectEDT('javax.swing.JProgressBar');
            
            set(jProgressBar, 'Minimum',0, 'Maximum',100, 'Value',0);            
            statusbarObj.add(jProgressBar,'West'); 
            
            jRootPane.setStatusBar(statusbarObj);           
            statusbarObj.setText('loading ...');
            jRootPane.setStatusBarVisible(1);
            catch
            end
            
            
            try                  
                enableDisableFig(obj.hData.f, 'off');
            catch
            end       
                       
            
            % Print MENU default settings
            pt = printtemplate();
            pt.StyleSheet       = 'modified';
            pt.VersionNumber    = 2;   
            pt.FigSize          = [28 19];
            pt.DriverColor      = 1;
            pt.PrintUI          = 0;
            setprinttemplate(obj.hData.f, pt);
            
                       
            % MainPanel 
            obj.hData.f0 = uiextras.VBox(... 
                'Parent',            obj.hData.f,...
                'Spacing',           0,...
                'Padding',           0,...
                'BackgroundColor',   obj.Default.Color.BG_D);
            
            uiextras.Panel(...
                'Parent',            obj.hData.f0,...
                'BackgroundColor',   [.94 .94 .94],...
                'BorderType',        'none',...
                'Title',             '');  
            
            % ContextMenu for TabGroup (for right click option)
            try
                obj.hData.tabgp_cm = uicontextmenu(obj.hData.f);
            catch
                obj.hData.tabgp_cm = uicontextmenu('Parent',obj.hData.f);
            end
            
            warning('off','MATLAB:uitabgroup:DeprecatedFunction')          
            obj.hData.tabgp = uitabgroup(...
                'Parent',            obj.hData.f0,...                
                'Interruptible',     'off');
            
            % add ContextMenu to TabGroup
            set(obj.hData.tabgp,'UIContextMenu',obj.hData.tabgp_cm)
           
                        
            % MainPanel 
            obj.hData.f1 = uiextras.HBoxFlex(...
                'Parent',            obj.hData.f0,...
                'Spacing',           5,...
                'Padding',           5,...
                'BackgroundColor',   obj.Default.Color.BG_D );
            
            Panel = uiextras.Panel(...
                'Parent',            obj.hData.f0,...
                'Padding',           5,...
                'BorderType',        'none',...
                'BackgroundColor',   obj.Default.Color.BG_P);  
               
            obj.hData.PathInfo = BasicText(Panel,'',...
                'FontWeight',       'bold',...
                'FontSize',         obj.Default.Font.SizeS);
            obj.setFigureInfo('./','Untitled1.mat')  
            set(obj.hData.f0,'Sizes',[10 24 -1 25])            
            
            %add Ses object to OpenedModels Property             
            obj.OpenedModels = containers.Map(...
                'KeyType',          'char',...
                'ValueType',        'any');
            %explicite delete all keys 
            obj.OpenedModels.remove(obj.OpenedModels.keys);
            
            obj.SavePath   = './Untitled1.mat';
            
            obj.Menu      = menu(obj);
            obj.Ses       = ses(obj); 
            try
                set(jProgressBar, 'Minimum',0, 'Maximum',100, 'Value',33);
                statusbarObj.setText('loading Properties');
            catch
            end
            % incarnate the left part of GUI (node-specific settings)
            obj.Props     = props(obj);
            
            obj.hData.f2 = uiextras.VBoxFlex(...
                'Parent',            obj.hData.f1,...
                'Spacing',           3,...
                'Padding',           0,...
                'BackgroundColor',   obj.Default.Color.BG_P ); 
            
            try
                set(jProgressBar, 'Minimum',0, 'Maximum',100, 'Value',66);
                statusbarObj.setText('loading Hierarchy');
            catch
            end
            
            % incarnate the upper-center part of GUI (buttons, tree, edit)
            obj.Hierarchy = hierarchy(obj);
            % incarnate the lower-center part of GUI  
            obj.InfoCenter = InfoCenter(obj.hData.f2);          
            set(obj.hData.f2,'Sizes',[-1 100])
            
             % incarnate obj to show SES as a tree
            obj.TreeView = treeView(obj);
             % incarnate obj to show information about SES in one table
            obj.DebugView = debugView(obj);
            
            try 
                set(jProgressBar, 'Minimum',0, 'Maximum',100, 'Value',100);
                statusbarObj.setText('loading Settings');
            catch
            end
            
            % incarnate the right part of GUI (SES-wide settings)
            obj.Settings  = settings(obj);
            % incarnate the parser which checks correctness during input
            obj.Parser    = parser(obj);
            
            obj.OpenedModels('./Untitled1.mat') = obj.Ses;            
                        
            %set selectetNode in uitree after all javaobjects are created
            obj.Hierarchy.hData.Trees.mtree1.setSelectedNode(...
                obj.Hierarchy.hData.Trees.root1);
                      
            set(obj.hData.f1,'Sizes',[-.30 -.4 -.30])
            
            drawnow
            pause(0.05)  
            %obj.hData.jFrame.setMaximized(true) 
            set(obj.hData.f,...
                'Units',    'normalized',...
                'Position', [0.1,0.1,.8,.8]);
            
            try                  
                enableDisableFig(obj.hData.f, 'on');
            catch
            end                  

        try
            jRootPane.setStatusBarVisible(0);
        catch
        end
        
        try
        %check (once per session) if new version is available
        verCEATbx('SES ','01-04-01')
        catch 
        end            
        end
        %% Delete obj after closing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function  delete(obj)
            try obj.TreeView.delete();  catch; end
            try obj.DebugView.delete(); catch; end
            
            try
                set(obj.Settings.hData.Tables.jtable1.getSelectionModel,'ValueChangedCallback',[])
                set(obj.Settings.hData.Tables.jtable2.getSelectionModel,'ValueChangedCallback',[])
                set(obj.Settings.hData.Tables.jtable3.getSelectionModel,'ValueChangedCallback',[])
                set(obj.Settings.hData.Tables.jtable4.getSelectionModel,'ValueChangedCallback',[])
            catch
            end
            try
                set(obj.Props.hData.Tables.jtable1.getSelectionModel,   'ValueChangedCallback',[])
                set(obj.Props.hData.Tables.jtable2.getSelectionModel,   'ValueChangedCallback',[])
                set(obj.Props.hData.Tables.jtable3.getSelectionModel,   'ValueChangedCallback',[])
                set(obj.Props.hData.Tables.jtable4.getSelectionModel,   'ValueChangedCallback',[])
                set(obj.Props.hData.Tables.jtable5.getSelectionModel,   'ValueChangedCallback',[])
            catch
            end
            try
                set(obj.Settings.hData.jhb20e,                          'CaretUpdateCallback',[])
                set(obj.Settings.hData.jhb20c,                          'CaretUpdateCallback',[])
                set(obj.Settings.hData.jhb34,                           'CaretUpdateCallback',[])
            catch
            end
            try
                set(obj.Props.hData.jhb11x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb16x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb34x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb52x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb52cx,                            'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb69x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb74x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb77x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb84x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb87x,                             'CaretUpdateCallback',[])
                set(obj.Props.hData.jhb88x,                             'CaretUpdateCallback',[])
            catch
            end
            
            delete(setdiff(findobj(gcf),gcf))
        end
    end
    methods (Hidden)
        function setFigureInfo(obj,filepath,filename)
            fileinfo = dir([filepath,filename]);
            set(obj.hData.PathInfo.hnd,...
                'String',   sprintf('%s',filepath));
            set(obj.hData.f,...
                'Name',     sprintf('SES EDITOR | %s | %s',filename,fileinfo.date));
        end        
        function disp(obj)
            fprintf(1,['\tSES EDITOR %s by Research Group CEA\n',...
                       '\n',...  
                       'RG Computational Engineering and Automation\n',...
                       'Faculty of Engineering - Wismar University\n',...
                       '\n',...
                       'SUPERVISOR:\n',...
                       'Prof. Dr.-Ing. Thorsten Pawletta \n',...
                       'thorsten.pawletta[at]hs-wismar.de\n'],obj.GUI_Ver);           
        end
    end
        
    methods %(Hidden)
        %EXTERNAL API (UNDER DEVELOPMENT -> HIDDEN)
        
        %##### HIERACHY BASED #####        
        function API_NodeAddSub(obj)
            obj.Hierarchy.addSubNode();
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end
        function API_NodeAddSibling(obj)
            obj.Hierarchy.addSiblingNode();
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end
        function API_NodeChangeType(obj,Type)
            switch Type
                case 'Aspect';     val = 2;                
                case 'Spec';       val = 3;                
                case 'MAspect';    val = 4;                
                otherwise ;        val = 1;
            end            
            set(obj.Hierarchy.hData.hb7,'Value',val)
            obj.Hierarchy.popupMenuCallback(); 
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end
        function API_NodeDelete(obj)
            obj.Hierarchy.deleteSelNode();
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end
        function API_NodeRename(obj,NewName)
            if nargin == 2 && ischar(NewName)
            set(obj.hData.hb5,'String',NewName)
            obj.Hierarchy.renameNode();
            
            drawnow limitrate nocallbacks
            pause(0.2)
            else
                error('You have to specify a new Name for the current Node')
            end
        end
        function API_TreeExpand(obj)
            obj.Hierarchy.expand();
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end
        function API_TreeCollapse(obj)
            obj.Hierarchy.collapse();
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end
                
        %##### MENU BASED #####        
        function API_ModelNew(obj)
             obj.Menu.newModel();
             
             drawnow limitrate nocallbacks
             pause(0.2)
        end        
        function API_ModelSave(obj)
            obj.Menu.saveModel();
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end        
        function API_ModelQuickSave(obj,Name)
            if nargin == 1  %get a random name 
                [~,Name]=fileparts(tempname);
                fprintf(2,'SES saved as: %s.mat\n',Name)
            end
            
            obj.Menu.quickSave2mat(Name)
            
            drawnow limitrate nocallbacks
            pause(0.2)
        end  
        function API_PrunePermCheck(obj)
            obj.Menu.PermissionCheck();
        end
        function API_Prune(obj)
            obj.Menu.prune();
        end            
        function API_PruneFirstLevel(obj)
            obj.Menu.pruneFirstLevel();
        end
        function API_PruneFlatt(obj)
            obj.Menu.flattening();
        end        
        function API_ModelClose(obj)
            obj.Menu.closeWindow();
        end          
        
        %##### PROPERTIES BASED #####
        function API_NodeSetData(obj,Property,Value)
            selNode = obj.Hierarchy.hData.Trees.selectedNode1;
            TP = obj.Ses.getTreepath(selNode);
            Node = obj.Ses.nodes(TP);  
            allowedProps = properties(Node);
            if ismember(Property,allowedProps)
                Node.(Property) = Value;
                obj.Props.UpdatePropertyWindow()   
            else
                error('operation not allowed')
            end 
        end        
     
        %##### SETTINGS BASED #####
        function API_SESSetData(obj,Property,Value)
            SesModel = obj.parent.Ses;            
            allowedProps = properties(SesModel);
            if ismember(Property,allowedProps)
                SesModel.(Property) = Value;                
                obj.Settings.UpdateSesVariables();
                obj.Settings.refreshTreeColors();
                  
            else
                error('operation not allowed')
            end 
        end
        function Value = API_SESGetData(obj,Property)
            SesModel = obj.parent.Ses;            
            allowedProps = properties(SesModel);
            if ismember(Property,allowedProps)
                Value = SesModel.(Property);                    
            else
                error('operation not allowed')
            end 
        end 
        function API_SESExptFcns(obj)
            obj.Settings.createSESFUN();
        end        
        
        %##### OTHER #####
        function Value = API_NodeGetData(obj,Property)
            selNode = obj.Hierarchy.hData.Trees.selectedNode1;
            if ~selNode.isRoot
                TP = obj.Ses.getTreepath(selNode);
                Node = obj.Ses.nodes(TP);  
                allowedProps = properties(Node);
                if ismember(Property,allowedProps)
                    Value =Node.(Property);                
                else
                    error('operation not allowed')
                end 
            else
                Value = [];
            end
        end        
        function Node  = API_NodeGet(obj)
            selNode = obj.Hierarchy.hData.Trees.selectedNode1;
            if ~selNode.isRoot
                TP = obj.Ses.getTreepath(selNode);
                Node = obj.Ses.nodes(TP);  
            else
                Node = [];
            end
        end
    end    
    
    methods(Static)
        %EXTERNAL API
        function API_ModelOpen(File)
            gr = groot;
            tbxobj = [];
            for fig = get(gr,'Children')'
                figure_name = get(fig,'Name');
                if strcmp(figure_name(1:12),'SES EDITOR |')
                    tbxobj = get(fig,'UserData');
                    break
                end
            end
            if isnumeric(tbxobj)            
                tbxobj = ses_tbx();     
            end
            
            if ischar(File) % if path of SES/PES File is used
                FullFilePath = which(File);
                if isempty(FullFilePath)
                    FullFilePath = File;
                end
                [filepath,filename] = fileparts(FullFilePath);
                tbxobj.Menu.openModel(filename,[filepath,'/'])
            else
                tbxobj.Menu.openSES(File) %if file is a SES/PES obj
            end
        end          
        function pathstr = API_PathRootFolder()
            pathstr = fileparts(mfilename('fullpath'));
        end        
        function pathstr = API_PathExmplFolder()
            pathstr = fullfile(fileparts(which('ses_tbx')),'examples');
            if nargout == 0            
                cd(fullfile(pathstr))
                clear pathstr
            end            
        end
        function GUIhnd = API_GUIHandle()
            gr = groot;
            GUIhnd = [];
            for fig = get(gr,'Children')'
                figure_name = get(fig,'Name');
                if strcmp(figure_name(1:12),'SES EDITOR |')
                    GUIhnd = get(fig,'UserData');
                    break
                end
            end
            if isnumeric(GUIhnd)            
                GUIhnd = ses_tbx();     
            end
        end
            
    end
end




% Helper Function 
% CHECK IF TOOLBOX IS UP TO DATE
function verCEATbx(tbx_name,i_ver)

persistent tbx
%tbx = [];

try
    htmlstr = webread('http://www.cea-wismar.de/tbx/versions');
    html_str_array = strsplit(htmlstr,char(10)); %#ok<CHARTEN>
    for k = 1:numel(html_str_array)
        c_line = html_str_array{k};
        searchstr = ['<b>*',tbx_name];
        if ~isempty(regexp(c_line,searchstr,'once'))
            c_ver = html_str_array{k+2}(11:end-4);
            if ~(strcmp(c_ver,i_ver)|| ismember(k,tbx))
                warndlg(['New version: ',c_ver],'Outdated Toolbox')                
            end 
            tbx(k) = k;
            break
        end
    end
catch    
end
end

