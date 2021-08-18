classdef menu < ses_gui_components.supportFun
    properties (Hidden)
        NumOfScSh = 1; %Number of ScreenShots taken
    end
    
    methods
        %% Constructor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = menu(parent) %constructor
            
            if nargin == 0 %JUST FOR TESTING
            	parent.hData.f = figure(...
                    'MenuBar',          'None',...
                    'PaperOrientation', 'landscape',...
                    'NumberTitle',      'off',...
                    'PaperPositionMode','manual', ...
                    'PaperPosition',    [0 0.5 29.5 20], ...
                    'PaperSize',        [29.68 20.98], ...
                    'PaperType',        'A4');  
                parent.SavePath = './Untitled1.mat';
                parent.hData.tabgp = uitabgroup(...
                    'Parent',           parent.hData.f);
                parent.hData.jFrame = get(handle(parent.hData.f),'JavaFrame');
            end           
            
            obj.parent = parent; 
            
            % load Menu bar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            %% File 
            obj.hData.menu.f = uimenu(...
                obj.parent.hData.f,...
                ...'Callback',             @(hobj,evt)Accelorator4SaveAs(obj,hobj,evt),...
                'Label',                'File');
            obj.hData.menu.f1 = uimenu(...
                obj.hData.menu.f,...
                'Label',                'New Model',...
                'Callback',             @(hobj,evt)newModel(obj),...
                'Accelerator',          'N');
            
            obj.hData.menu.f2 = uimenu(...
                obj.hData.menu.f,...
                'Label',                'Open Model...',...                
                'Callback',             @(hobj,evt)openModel(obj),...
                'Accelerator',          'O');            
            obj.hData.menu.f2b = uimenu(...
                obj.hData.menu.f,...
                'Separator',            'on',...
                'Label',                'Open Examples...',...
                'Accelerator',          'E',...
                'Callback',             @(hobj,evt)openModel(obj,'examples'));             
                                       
            obj.hData.menu.f3 = uimenu(...
                obj.hData.menu.f,...
                'Label',                'Save Model',...
                'Callback',             @(hobj,evt)saveModel(obj,hobj,evt),...
                'Accelerator',          'S');
            obj.hData.menu.f4 = uimenu(...
                obj.hData.menu.f,...
                'Label',                'Save Model as...',...
                'Callback',             @(hobj,evt)saveModel(obj,hobj,evt));                                        
            obj.hData.menu.f5 = uimenu(...
                obj.hData.menu.f,...
                'Label',                'Close Model',...
                'Callback',             @(hobj,evt)closeWindow(obj),...
                'Accelerator',          'Q');                                        
                                        
            obj.hData.menu.f7 = uimenu(...
                obj.hData.menu.f,...
                'Label',                'Quit',...
                'Callback',             @(hobj,evt)closeEditor(obj,hobj,evt),...
                'Separator',            'on',...
                'Accelerator',          'W'); 
            
            %% Pruning 
            obj.hData.menu.p = uimenu(...
                obj.parent.hData.f,...
                'Label',                'Pruning');
            obj.hData.menu.p1 = uimenu(...
                obj.hData.menu.p,...
                'Label',                'Check');
            obj.hData.menu.p11 = uimenu(...
                obj.hData.menu.p1,...
                'Label',                'Pruning Permission',...
                'Callback',             @(hobj,evt)PermissionCheck(obj),...
                'Accelerator',          '0');            
            obj.hData.menu.p12 = uimenu(...
                obj.hData.menu.p1,...
                'Label',                'Decisions by Inheritance',...
                'Callback',             @(hobj,evt)checkNextLevelDescissions(obj),...
                'Accelerator',          '4');  
            obj.hData.menu.p2 = uimenu(...
                obj.hData.menu.p,...
                'Label',                'Prune');
            obj.hData.menu.p21 = uimenu(...
                obj.hData.menu.p2,...
                'Label',                'First-Level (PES)',...
                'Callback',             @(hobj,evt)pruneFirstLevel(obj),...
                'Accelerator',          '1');                             
            obj.hData.menu.p22 = uimenu(...
                obj.hData.menu.p2,...
                'Label',                'Complete (PES)',...
                'Callback',             @(hobj,evt)prune(obj),...
                'Accelerator',          '2');
            obj.hData.menu.p23 = uimenu(obj.hData.menu.p2,...
                'Label',                'Flattening (FPES)',...
                'Callback',             @(hobj,evt)flattening(obj),...
                'Accelerator',          '3');                 
            
            %% Merging 
            obj.hData.menu.m = uimenu(...
                obj.parent.hData.f,...
                'Label',                'Merging');  
            obj.hData.menu.m1 = uimenu(...
                obj.hData.menu.m,...
                'Label',                'Import Model...',...
                'Callback',             @(hobj,evt)merge(obj),...
                'Enable',               'off',...
                'Accelerator',          'V');
            
            %% Tools             
            obj.hData.menu.tools = uimenu(...
            	obj.parent.hData.f,...
                'Label',                'Tools'); 
            
            obj.hData.menu.tools_scncap = uimenu(...
            	obj.hData.menu.tools,...
                'Label',                'Screen Capture...',...
                'Callback',             @(hobj,evt)takeImage(obj));            
      
%             obj.hData.menu.tools_cpfig = uimenu(...
%             	obj.hData.menu.tools,...
%                 'Label',                'Copy Figure',...
%                 'Callback',             @(hobj,evt)print('-clipboard','-dbitmap'));
%             
%             obj.hData.menu.tools_print = uimenu(...
%             	obj.hData.menu.tools,...
%                 'Label',                'Print Figure...',...
%                 'Callback',             @(hobj,evt)printpreview,...
%                 'Accelerator',          'P');  
            
            obj.hData.menu.tools_srcSESMAT = uimenu(...
            	obj.hData.menu.tools,...
                'Label',                'Find SES *.mat Files...',...
                'Callback',             'SESMatFiles',...
                'Accelerator',          'F');   
            
            obj.hData.menu.tools_maxfig = uimenu(...
            	obj.hData.menu.tools,...
                'Label',                'Maximize Figure',...
                'Callback',             @(hobj,evt)obj.parent.hData.jFrame.setMaximized(true),...
                'Accelerator',          'L');  
            obj.hData.menu.tools_genRep = uimenu(...
            	obj.hData.menu.tools,...
                'Label',                'Generate Report...',...
                'Callback',             @(hobj,evt)generateReport(obj),...
                'Accelerator',          'R');  
            
            
            %% help menu
            obj.hData.menu.Help = uimenu(...
                obj.parent.hData.f,...
                'Label',                'Help'); 
            obj.hData.menu.Help1 = uimenu(...
                obj.hData.menu.Help,...
                'Label',                'Copyrights',...
                'Accelerator',          'I',...
                'Callback',             @(hobj,evt)showNotes(obj,...
                                        'SES_GUI_Notes/copyrights.txt'));  
            obj.hData.menu.Help2 = uimenu(...
                obj.hData.menu.Help,...
                'Label',                'Release Notes',...
                'Callback',             @(hobj,evt)showNotes(obj,...
                                        'SES_GUI_Notes/releasenotes.txt',...
                                        'HorizontalAlignment','left'));

            obj.hData.menu.Help4 = uimenu(...
                obj.hData.menu.Help,...
                'Separator',            'on',...
                'Label',                'Contact Information',...
                'Accelerator',          'M',...
                'Callback',             @(hobj,evt)showNotes(obj,...
                                        'SES_GUI_Notes/contact.txt',...
                                        'Enable',           'on',...               
                                        'ButtonDownFcn',    '' ));  
            obj.hData.menu.Help5 = uimenu(...
                obj.hData.menu.Help,...
                'Label',                'How To Cite',...
                'Callback',             @(hobj,evt)showNotes(obj,...
                                        'SES_GUI_Notes/how_to_cite.txt',...
                                        'Enable',               'on',...                                        
                                        'ButtonDownFcn',        '' ));  
            obj.hData.menu.Help6 = uimenu(...
                obj.hData.menu.Help,...
                'Label',                'Example Doc',...
                'Separator',            'on',...
                'Accelerator',          'D',...
                'Callback',             @(hobj,evt)web(...
                                            'ses_tbx_index.html',...
                                            '-new'));   
            
        	obj.hData.menu.Help7 = uimenu(...
                obj.hData.menu.Help,...                
                'Label',                'Visit Website',...                
                'Accelerator',          'H',...
                'Callback',             @(hobj,evt)web(...
                                        'https://www.cea-wismar.de/tbx/SES_Tbx/sesToolboxMain.html',...
                                        '-new')); %'-browser'
            %dynamic TABs           
            obj.hData.menu.dynWindow = uitab(...
                obj.parent.hData.tabgp,...
                'Title',                'Untitled1.mat',...
                'Tag',                  obj.parent.SavePath);
            try
                set(obj.parent.hData.tabgp,...
                    'SelectionChangedFcn',  @(hobj,evt)openWindow(obj,hobj,evt));
            catch %older Matlab
%                 set(obj.parent.hData.tabgp,...
%                     'SelectionChangeFcn',  @(hobj,evt)openWindow(obj,hobj,evt));
               
                set(obj.parent.hData.tabgp,...
                    'SelectionChangeCallback',  @(hobj,evt)openWindow(obj,hobj,evt));               
            end
            
            
            uimenu(...
                obj.parent.hData.tabgp_cm,...
                'Label',                'New Model',...
                'Callback',             @(hobj,evt)newModel(obj));
            
            uimenu(...
                obj.parent.hData.tabgp_cm,...
                'Label',                'Open Model...',...                
                'Callback',             @(hobj,evt)openModel(obj));            
            uimenu(...
                obj.parent.hData.tabgp_cm,...
                'Label',                'Open Examples...',...                
                'Callback',             @(hobj,evt)openModel(obj,'examples'));
            
            %MENU TWEAKS (which are based on Java)
            %automatical opens; Accelorator for SaveAs; Picture as ToolTip
            AddMenuFeatures(obj)
            
        end%loadMenu
        
        %% close Window 
        function closeWindow(obj)            
            for i=1:length(obj.parent.OpenedModels)
                nextWindow = obj.hData.menu.dynWindow(i);                
                tag_str = get(nextWindow,'Tag');%                                
                if strcmp(obj.parent.SavePath,tag_str)
                    oldWindow = obj.hData.menu.dynWindow(i); 
                    if i == 1 && length(obj.parent.OpenedModels) > 1
                        newWindow = obj.hData.menu.dynWindow(2);
                        
                    elseif length(obj.parent.OpenedModels) > 1
                        newWindow = obj.hData.menu.dynWindow(i-1);
                    end
                    break
                end
            end
            
            %delete the oldWindow, that shall be closed
            delete(oldWindow)
            obj.hData.menu.dynWindow(i) = [];
            remove(obj.parent.OpenedModels,obj.parent.SavePath);
            if length(obj.parent.OpenedModels) < 1
                obj.newModel()               
            else
                %show the new Window
                obj.parent.SavePath = get(newWindow,'Tag');
                [filepath,name,ext] = fileparts(obj.parent.SavePath);
                filename = [name,ext];
                
                newSes = obj.parent.OpenedModels(obj.parent.SavePath);
                obj.open(newSes)
                %set figure name to Untitled
                obj.parent.setFigureInfo(filepath,filename)
                
            end
        end%function
        
        %% open Window
        function openWindow(obj,~,hdata)
            
            try %MATLAB R2014b and above                
                cPath = get(hdata.NewValue,'Tag');
            catch %MATLAB R2014a and below
                tabs = get(obj.parent.hData.tabgp,'Children');
                ctab = tabs(hdata.NewValue);
                set(obj.parent.hData.tabgp,'SelectedIndex',hdata.NewValue)
                cPath = get(ctab,'Tag');               
            end
            
            %Do Nothing if SAVEPATH equals Current PATH 
            if strcmp(obj.parent.SavePath,cPath)
                return
            end
                        
            obj.parent.SavePath = cPath;            
            
            newSes = obj.parent.OpenedModels(obj.parent.SavePath);
            obj.open(newSes);
            
            %set figure name to Untitled
            [filepath,name,ext] = fileparts(obj.parent.SavePath);
            filename = [name,ext];
            obj.parent.setFigureInfo([filepath,'/'],filename)
            
            obj.parent.DebugView.updateWindow(); 
            %obj.parent.TreeView.initWindow();
        end%function
        
        %% generate new Model %%           
        function newModel(obj) 
            %select root of SES
            obj.parent.Hierarchy.hData.Trees.mtree1.setSelectedNode( obj.parent.Hierarchy.hData.Trees.mtree1.getRoot )    
            % reset all SES input 
            obj.parent.Ses = ses(obj.parent);
            
            %add new Model to OpenedModels, but find free identifier
            nr = 1;
            Key = ['./Untitled',num2str(nr),'.mat'];
            while isKey(obj.parent.OpenedModels,Key)
                nr = nr+1;
                Key = ['./Untitled',num2str(nr),'.mat'];
            end
            obj.parent.OpenedModels(Key) = obj.parent.Ses;
            obj.parent.SavePath = Key;
            
            [~,name,ext] = fileparts(obj.parent.SavePath);
            filename = [name,ext];
            
            newTab = uitab(...
                obj.parent.hData.tabgp,...
                'Title',            filename,...
                'Tag',              obj.parent.SavePath);
            set(obj.parent.hData.tabgp,...
                'SelectedTab',      newTab);
            obj.hData.menu.dynWindow(end+1) = newTab;
            
            %## RESET ALL SETTINGS TABLES ##
            
            % 12) generating table in Selection Constraints
            set(obj.parent.Settings.hData.Tables.mtable1,'Data',cell(1,2)) 
            % 19) generating table in Variables
            set(obj.parent.Settings.hData.Tables.mtable2,'Data',cell(1,2)) 
            % 24) generating table in Functions
            set(obj.parent.Settings.hData.Tables.mtable3,'Data',cell(1))   
            % 31) generating table in Semantic Conditions
            set(obj.parent.Settings.hData.Tables.mtable4,'Data',cell(1))   
            pause(0.1)
            drawnow limitrate nocallbacks
            
            obj.parent.Settings.hData.Tables.jtable1.setRowSelectionInterval(0,0)
            obj.parent.Settings.hData.Tables.jtable2.setRowSelectionInterval(0,0)            
            obj.parent.Settings.hData.Tables.jtable3.setRowSelectionInterval(0,0)            
            obj.parent.Settings.hData.Tables.jtable4.setRowSelectionInterval(0,0)
            
            %reset Selection Constraints Selection
            obj.parent.Settings.Selectioncbck('','',obj.parent.Settings.hData.Tables.jtable1);
            
            % reset tree
            obj.parent.Hierarchy.hData.Trees.mtree1.removeAllChildren(...
                obj.parent.Hierarchy.hData.Trees.mtree1.getRoot)
            obj.parent.Hierarchy.hData.Trees.mtree1.reloadNode(...
                obj.parent.Hierarchy.hData.Trees.mtree1.getRoot)
            
            %set figure name to Untitled            
            [filepath,name,ext] = fileparts(obj.parent.SavePath);
            filename = [name,ext];
            obj.parent.setFigureInfo([filepath,'/'],filename)
                    
        end %function   
        
        %%
        function quickSave2mat(obj,filename)
            new = obj.parent.Ses;       
            parent = new.parent;
            new.parent = [];
            save([filename,'.mat'],'new')
            new.parent = parent;
        end
        
        %% save Model %%           
        function saveModel(obj,hobj,~)
            import xml_Interface.*
            
            %copy SES object
            this = obj.parent.Ses;
            if isa(this,'pes')
                new = feval(class(this),this.Ses);
            else
                new = feval(class(this),[]);                
            end
            p = properties(this);
            for i = 1:length(p)
                if ~strcmp(p{i},'parent')
                    new.(p{i}) = this.(p{i});
                end
            end 
           
            if strcmp(obj.parent.SavePath(1),'.')
                hobj = obj.hData.menu.f4;
            end
           
            if hobj == obj.hData.menu.f4 %Save As...
                dev_name = obj.parent.SavePath;
                dev_name = strrep(dev_name,'.xml','');% remove .xml
                dev_name = strrep(dev_name,'.mat','');% remove .mat
                [filename, filepath] = uiputfile(...
                    {'*.mat','MAT-files (*.mat)';'*.xml','XML-files (*.xml)'},...
                    'Save Model',dev_name);
                if filename      
                    filepath = strrep(filepath,'\','/');
                    if strcmp(filename(end-3:end),'.xml')                                                
                    	ses = obj.parent.Ses;
                        xDoc = SES2XML(ses);
                        xmlwrite([filepath,filename], xDoc);      
                    end
                end  
                
            elseif hobj == obj.hData.menu.f3 %Save     
                try
                    [filepath,filename,ext] = fileparts(obj.parent.SavePath);
                            
                    filename = [filename,ext];
                    filepath = [filepath,'/'];
                    if strcmp(filename(end-3:end),'.xml')                        
                        ses = obj.parent.Ses;
                        xDoc = SES2XML(ses);
                        xmlwrite([filepath,filename], xDoc);  
                    end
                catch
                    filepath = '';
                    filename = obj.parent.SavePath;
                end
            end
            
            % return, if user cancels save as process
            if filepath == 0
                return
            end
            
            %check if savepath is not a file that is already open on a different window
            if isKey(obj.parent.OpenedModels,[filepath,filename]) && ~strcmp([filepath,filename],obj.parent.SavePath)
                %errordlg(['"',filename,'" is already open in the Editor. To overwrite the file, close the original first.'],'Save-Error')
                obj.parent.InfoCenter.MSG('e',16,filename);
                return
            end
            
            if filename ~=0
                if strcmp(filename(end-3:end),'.mat')
                    save([filepath,filename],'new')
                end               
                
                remove(obj.parent.OpenedModels,obj.parent.SavePath);
                oldSavePath = obj.parent.SavePath;
                obj.parent.SavePath = [filepath,filename];
                obj.parent.OpenedModels(obj.parent.SavePath) = obj.parent.Ses;
                
                obj.parent.setFigureInfo(filepath,filename)            
                
                for i=1:length(obj.hData.menu.dynWindow)
                    if strcmp(get(obj.hData.menu.dynWindow(i),'Tag'),oldSavePath)
%                         set(obj.hData.menu.dynWindow(i),...
%                             'Tag',      obj.parent.SavePath,...
%                             'Label',    filename)
                        set(obj.hData.menu.dynWindow(i),...
                            'Tag',      obj.parent.SavePath,...
                            'Title',    filename)
                    end
                end
            end
        end%function
        
        %% open Model %%             
        function openModel(obj,filename,filepath)
            import xml_Interface.*
            
            oldPath = pwd;             
            if nargin < 3            
                if nargin == 2                
                    cd(fullfile(fileparts(which('ses_tbx')),filename))           
                end            
                [filename, filepath] = uigetfile({'*.mat','MAT-files (*.mat)';'*.xml','XML-files (*.xml)'},...
                    'Open Model');
            end
            cd(oldPath)
            
            if filename ~=0                
                filepath = strrep(filepath,'\','/');%use linux path system                
                if strcmp(filename(end-3:end),'.xml')                              
                    XmlObj = xmlread([filepath,filename]);
                    LoadModel.new = XML2SES(XmlObj);
                else
                    LoadModel = load ([filepath,filename]); %,'-mat'
                end
                existingVars = fieldnames(LoadModel);
                
                if ~ismember('new',existingVars)
%                     errordlg('File not valid.','File Error');
                    obj.parent.InfoCenter.MSG('e',13,'');
                    clear LoadModel  
                    
                elseif ~isa(LoadModel.new,'ses')    
%                     errordlg('File not valid.','File Error');
                    obj.parent.InfoCenter.MSG('e',13,'');
                    clear LoadModel
                    
                elseif isa(LoadModel.new,'ses')
                    %if file is already open than just switch to it
                    if obj.parent.OpenedModels.isKey([filepath,filename])
                        for i = 1:length(obj.parent.OpenedModels)
                            nextWindow = obj.hData.menu.dynWindow(i);
                            if strcmp([filepath,filename],get(nextWindow,'Tag'))
                                %workaround to use openWindow function 
                                hdata.NewValue = nextWindow; 
                                set(obj.parent.hData.tabgp,'SelectedTab',nextWindow);
                                obj.openWindow([],hdata); 
                                %obj.openWindow(nextWindow); 
                                break
                            end
                        end
                        
                    else %open new file
                        % upload SES structure
                        newSes = LoadModel.new;
                        newSes.parent = obj.parent;
                        clear LoadModel
                        obj.open(newSes);
                        
                        %set figure name to filename
                        obj.parent.setFigureInfo(filepath,filename)

                        obj.parent.SavePath = [filepath,filename];
                        obj.parent.OpenedModels(obj.parent.SavePath) = obj.parent.Ses;   
                        
                        newTab = uitab(...
                            obj.parent.hData.tabgp,...
                            'Title',            filename,...
                            'Tag',              obj.parent.SavePath);
                        set(obj.parent.hData.tabgp,'SelectedTab',newTab);
                        obj.hData.menu.dynWindow(end+1) = newTab;
                    end
                end
            end
            %obj.parent.TreeView.initWindow();
        end%function
        
        function openSES(obj,newSes)    
                                  
            nr = 1;
            Key = ['./Untitled',num2str(nr),'.mat'];
            while isKey(obj.parent.OpenedModels,Key)
                nr = nr+1;
                Key = ['./Untitled',num2str(nr),'.mat'];
            end
                        
            obj.parent.OpenedModels(Key) = obj.parent.Ses;
            obj.parent.SavePath = Key;               
            
            newSes.parent = obj.parent;            
            obj.open(newSes);
            
            %set figure name to filename
            obj.parent.setFigureInfo('./',Key(3:end))
            
            newTab = uitab(...
                obj.parent.hData.tabgp,...
                'Title',            Key(3:end),...
                'Tag',              obj.parent.SavePath);
            set(obj.parent.hData.tabgp,'SelectedTab',newTab);
            obj.hData.menu.dynWindow(end+1) = newTab;             
        end
        
        %%
        function open(obj,SES)
            %set selected Node to root of SES to avoid updateProperty error message
            obj.parent.Hierarchy.hData.Trees.mtree1.setSelectedNode( obj.parent.Hierarchy.hData.Trees.mtree1.getRoot )
            obj.parent.Ses = SES;
            % upload tree
            obj.parent.Hierarchy.hData.Trees.mtree1.removeAllChildren(obj.parent.Hierarchy.hData.Trees.mtree1.getRoot)        
            obj.parent.Hierarchy.hData.Trees.mtree1.reloadNode(obj.parent.Hierarchy.hData.Trees.mtree1.getRoot)
            %find Root
            NodeCount = obj.parent.Ses.nodes.Count;
            %get treestructure only if nodes are inserted  
            
            
            
            if NodeCount > 0
                Indices = 1:NodeCount;
                Values = values(obj.parent.Ses.nodes);
                for i=1:NodeCount
                    nextObjNode = Values{i};
                    if isempty(nextObjNode.parent)
                        rootfather = nextObjNode;
                        Values(i) = [];
                        Indices(i) = [];
                        break
                    end
                end
                %insert the rootnode
                rootNode = uitreenode('v0','dummy', rootfather.name, obj.Default.IconPath('entity'), 0);
                obj.parent.Hierarchy.hData.Trees.TreeModels.tm1.insertNodeInto(rootNode,obj.parent.Hierarchy.hData.Trees.mtree1.getRoot,0); 
                obj.parent.Hierarchy.hData.Trees.mtree1.setSelectedNode( rootNode )
                %reload tree structure
                    
                root = obj.parent.Hierarchy.hData.Trees.mtree1.getRoot;
                Level = 0;
                while ~isempty(Indices)
                    NodeCountLeft = length(Indices);
                    %save all current leaves
                    LeafCount = root.getLeafCount;
                    firstLeaf = root.getFirstLeaf;
                    allLeaves = cell(1,LeafCount);
                    for j=1:LeafCount
                        if j==1        
                            allLeaves{j} = firstLeaf;
                        elseif j==LeafCount
                            allLeaves{j} = root.getLastLeaf;
                        else
                            allLeaves{j} = allLeaves{j-1}.getNextLeaf;
                        end
                    end
                    Level = Level+1;     
                    %             insertedChildNrs = [];
                    for i = NodeCountLeft:-1:1
                        nextObjNode = Values{i};
                        TP = nextObjNode.treepath;
                        LocOfSlash = strfind(TP,'/');
                        NrOfSlash = length(LocOfSlash);
                        if NrOfSlash == Level %node is child of the right level
                            %find the right father
                            for j=1:LeafCount
                                nextLeaf = allLeaves{j};
                                LeafPath = obj.parent.Ses.getTreepath(nextLeaf);
                                if strcmp(LeafPath,nextObjNode.getParentPath)
                                    father = nextLeaf;
                                    TPfather = obj.parent.Ses.getTreepath(father);
                                    objFather = obj.parent.Ses.nodes(TPfather);
                                    break
                                end
                            end
                            %find the right icon
                            switch nextObjNode.type
                                case 'Entity'
                                iconPath = obj.Default.IconPath('entity');
                                case 'Spec'
                                iconPath = obj.Default.IconPath('spec');
                                case 'Aspect'
                                iconPath = obj.Default.IconPath('aspect');
                                case 'MAspect'
                                iconPath = obj.Default.IconPath('masp');
                                otherwise
                                iconPath = obj.Default.IconPath('descNR');
                            end
                            
                            % obj.parent.Hierarchy.expand DEBUG !!!
                            
                            %find the right location of the inserted Node
                            ChildreninTree = father.children;
                            Children = objFather.children;
                            ChildPos = find(strcmp(Children,nextObjNode.name))-1;
                            insertedPos = 0;
                            while ChildreninTree.hasMoreElements
                                nxtChld = ChildreninTree.nextElement;
                                TPch = obj.parent.Ses.getTreepath(nxtChld);
                                objChild = obj.parent.Ses.nodes(TPch);
                                nxtChildPos = find(strcmp(Children,objChild.name))-1;
                                if ChildPos > nxtChildPos 
                                    insertedPos = insertedPos +1;
                                else
                                    break
                                end
                            end                             
                            newNode = uitreenode('v0','dummy', nextObjNode.name, which(iconPath), 0);
                            obj.parent.Hierarchy.hData.Trees.TreeModels.tm1.insertNodeInto(newNode,father,insertedPos);     
                            %                obj.Hierarchy.hData.Trees.mtree1.setSelectedNode( newNode )
                            Values(i) = []; 
                            Indices(i) = [];     
                        end%if
                    end%for
                end%while
                obj.parent.Hierarchy.hData.Trees.mtree1.setSelectedNode(...
                    obj.parent.Hierarchy.hData.Trees.mtree1.getRoot.getFirstChild ) 
                obj.parent.Hierarchy.hData.Trees.mtree1.reloadNode(...
                    obj.parent.Hierarchy.hData.Trees.mtree1.getRoot.getFirstChild)
                pause(0.1)
                drawnow limitrate nocallbacks
                
                %Expand tree
                obj.parent.Hierarchy.expand
                %check if all Descissionnodes are valid
                allNodes = values(obj.parent.Ses.nodes);
                obj.parent.Hierarchy.validateDescissionNodes(allNodes);
            end
            
            % prepare tabledata for Selection Constraints
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
            
            %refresh Table s of Selection Constraints
            SelConData = cell(rows,2);
            for i=1:rows
                if ~isempty(SelCons{i,1})
                    sourcePath = SelCons{i,1};
                    sourceNode = obj.parent.Ses.getTreeNode(sourcePath);
                    %                     [~,htmlname] = obj.parent.Ses.getName(sourceNode);
                    colorfg = obj.parent.Ses.Selection_Constraints.Color{i};
                    if isempty(colorfg)
                        htmlnameSource = sources{i}; %for Table and Node
                        htmlnameSink = sinks{i}; %only for Table
                    else
                        htmlnameSource = strcat(['<html><span style="color: ' colorfg '; font-weight: bold;">'],sources{i});
                        sourceNode.setName(strcat(['<html><span style="color: ' colorfg '; font-weight: bold;">'],sources{i}));
                        htmlnameSink = strcat(['<html><span style="color: ' colorfg ';">'],sinks{i});
                    end
                    SelConData{i,1} = htmlnameSource;
                    SelConData{i,2} = htmlnameSink;
                    %                     sinkNames = '';
                    for k=1:length(SelCons{i,2})
                        sinkPath = SelCons{i,2}{k};
                        sinkNode = obj.parent.Ses.getTreeNode(sinkPath);
                        nodeName = obj.parent.Ses.getName(sinkNode);
                        if isempty(colorfg)
                            htmlNodeName = nodeName;
                        else
                            htmlNodeName = strcat(['<html><span style="color: ' colorfg ';">'],nodeName);
                        end
                        sinkNode.setName(htmlNodeName);                        
                    end                    
                    obj.parent.Hierarchy.hData.Trees.jtree1.treeDidChange();
                else
                    SelConData(i,:) = cell(1,2);
                end
            end%for     
            if isempty(SelConData)
                SelConData = cell(1,2);
                obj.parent.Ses.Selection_Constraints.Pathes = cell(1,2);
            end
            
            % Prepare Tabledata for Functions
            FunData = cell(length(obj.parent.Ses.fcn),1);
            for indF=1:length(obj.parent.Ses.fcn)
                FunData{indF} = obj.parent.Ses.fcn{indF}.Filename;
            end
            
            % Prepare Tabledata for Semantic Conditions
            if isempty(obj.parent.Ses.Semantic_Conditions)
                obj.parent.Ses.Semantic_Conditions = cell(1,1);
            end
            % upload all Setting Tables
            set(obj.parent.Settings.hData.Tables.mtable1,'Data',SelConData)
            set(obj.parent.Settings.hData.Tables.mtable2,'Data',obj.parent.Ses.var)
            set(obj.parent.Settings.hData.Tables.mtable3,'Data',FunData)
            set(obj.parent.Settings.hData.Tables.mtable4,'Data',obj.parent.Ses.Semantic_Conditions)        
            drawnow limitrate nocallbacks,pause(0.1)
            obj.parent.Settings.hData.Tables.jtable1.setRowSelectionInterval(0,0)
            obj.parent.Settings.hData.Tables.jtable2.setRowSelectionInterval(0,0)            
            obj.parent.Settings.hData.Tables.jtable3.setRowSelectionInterval(0,0)            
            obj.parent.Settings.hData.Tables.jtable4.setRowSelectionInterval(0,0)      
            obj.parent.Settings.Selectioncbck('','',obj.parent.Settings.hData.Tables.jtable1);%reset Selection Constraints Selection
        
            %obj.parent.TreeView.initWindow();
        end%function
        
        %% Prune SES %%
        function prune(obj)
            [flag,err] = obj.checkPermission;
            if ~flag
                for errNr = 1:length(err) 
%                     errordlg(err{errNr});
                    obj.parent.InfoCenter.MSG('e',1,err{errNr});                  
                end
                return
            end
            sesVars = obj.parent.Ses.var;   
            sesVars(cellfun(@isempty,sesVars(:,1)),:) = [];  %delete empty cell entries
            varValues = cell(1,size(sesVars,1));
            NrOfVars = length(varValues);
            %prepare cellarray where executed vars will be saved
            evalsesvars = cell(NrOfVars,1);
            loop = 0;
            flag = true;
            while flag && loop<=NrOfVars && NrOfVars>0 %&& NrOfVars>0 : 25.09.2015
                loop = loop + 1;
                flag = false;
                % check each SESVars for SESFunctions
                for i = 1:NrOfVars
                    %check if variable is not yet evaluated
                    if isempty(evalsesvars{i})
                        try
                            evalsesvars{i} = eval(sesVars{i,2});
                            str = obj.convert2str(evalsesvars{i});
                            str = [sesVars{i,1},' = ',str,'; '];
                            eval(str)
                        catch %some input parameters are not defined yet, so try in next loop
                            evalsesvars{i} = [];
                            flag = true; %another while loop is needed
                        end              
                    end
                end
            end%while
            if loop>NrOfVars
                error('Value assignment for SES variables fails.')
            end
            % update SESVars 
            for i=1:size(sesVars,1)
                varValues{i}{1} = sesVars(i,1);
                varValues{i}{2} = evalsesvars{i};
            end
            newPes = pes(obj.parent.Ses);
            newPes.prune(varValues);
            
            [filename, filepath] = newPes.save;
            openModel(obj,filename,filepath)
        end%function
        
        %% Prune First-Level PES %%
        function pruneFirstLevel(obj)
            [flag,err] = obj.checkPermission;
            if ~flag
                for errNr = 1:length(err) 
%                     errordlg(err{errNr}); 
                    obj.parent.InfoCenter.MSG('e',1,err{errNr});
                end
                return
            end
            obj.parent.InfoCenter.MSG('h',1,'');
                 
            sesVars = obj.parent.Ses.var;   
            sesVars(cellfun(@isempty,sesVars(:,1)),:) = [];  %delete empty cell entries
            varValues = cell(1,size(sesVars,1));
            NrOfVars = length(varValues);
            %prepare cellarray where executed vars will be saved
            evalsesvars = cell(NrOfVars,1);
            loop = 0;
            flag = true;
            while flag && loop<=NrOfVars && NrOfVars>0 %&& NrOfVars>0 : 25.09.2015
                loop = loop + 1;
                flag = false;
                % check each SESVars for SESFunctions
                for i=1:NrOfVars
                    %check if variable is not yet evaluated
                    if isempty(evalsesvars{i})
                        try
                            evalsesvars{i} = eval(sesVars{i,2});
                            [str] = obj.convert2str(evalsesvars{i});
                            str = [sesVars{i,1},' = ',str,'; '];
                            eval(str)
                        catch %some input parameters are not defined yet, so try in next loop
                            evalsesvars{i} = [];
                            flag = true; %another while loop is needed
                        end              
                    end
                end
            end%while
            if loop>NrOfVars
                error('Value assignment for SES variables fails.')
            end
            % update SESVars 
            for i=1:size(sesVars,1)
                varValues{i}{1} = sesVars(i,1);
                varValues{i}{2} = evalsesvars{i};
            end
            newPes = pes(obj.parent.Ses);
            newPes.firstLevelPrune(varValues);
            
            [filename, filepath] = newPes.save;
            openModel(obj,filename,filepath)
        end%function
        
        %% flatten SES/PES %%%
        function flattening(obj)
            [flag,err] = obj.checkPermission;
            if ~flag
                for errNr = 1:length(err) 
%                     errordlg(err{errNr}); 
                    obj.parent.InfoCenter.MSG('e',1,err{errNr});
                end
                return
            end
            sesVars = obj.parent.Ses.var;   
            sesVars(cellfun(@isempty,sesVars(:,1)),:) = [];  %delete empty cell entries
            varValues = cell(1,size(sesVars,1));
            NrOfVars = length(varValues);
            %prepare cellarray where executed vars will be saved
            evalsesvars = cell(NrOfVars,1);
            loop = 0;
            flag = true;
            while flag && loop<=NrOfVars
                loop = loop + 1;
                flag = false;
                % check each SESVars for SESFunctions
                for i=1:NrOfVars
                    %check if variable is not yet evaluated
                    if isempty(evalsesvars{i})
                        try
                            evalsesvars{i} = eval(sesVars{i,2});                            
                            [str] = obj.convert2str(evalsesvars{i});
                            str = [sesVars{i,1},' = ',str,'; '];
                            eval(str)
                        catch %some input parameters are not defined yet, so try in next loop
                            evalsesvars{i} = [];
                            flag = true; %another while loop is needed
                        end              
                    end
                end
            end%while
            if loop>NrOfVars && NrOfVars>0
                error('Value assignment for SES variables fails.')
            end
            % update SESVars 
            for i=1:size(sesVars,1)
                varValues{i}{1} = sesVars(i,1);
                varValues{i}{2} = evalsesvars{i};
            end
            newFPes = fpes(obj.parent.Ses);
            newFPes.prune(varValues);
            newFPes.flatten;
            
            [filename, filepath] = newFPes.save;
            openModel(obj,filename,filepath)
        end%function
        
        %% check Pruning Permission %%
        function PermissionCheck(obj)
            [flag,err] = obj.checkPermission;
            if flag
                % 'Pruning is allowed!'
                obj.parent.InfoCenter.MSG('h',2,'');
            else
                for errNr = 1:length(err)  
                    obj.parent.InfoCenter.MSG('e',1,err{errNr});
                end
            end
        end%function
        
        %% checks if pruning is allowed
        function [flag,err] = checkPermission(obj)
            %function returns flag = true, if pruning is allowed
            %function returns flag = flase, if pruning is not allowed
            flag = true;
            err = {};
            
            %% check if descriptive Nodes exist in Tree structure or zero Nodes
            descNodes = 0;
            allNodes = values(obj.parent.Ses.nodes);
            if obj.parent.Ses.nodes.Count == 0
                flag = false;
                err{end+1} = 'Nodes need to be specified before pruning!';
            else
                for i=1:obj.parent.Ses.nodes.Count
                    nextNode = allNodes{i};
                    if strcmp(class(nextNode),'node')
                        flag = false;
                        descNodes = descNodes+1;
                        err{end+1} = ['The type of ',num2str(descNodes),' node(s) is not defined!'];
                    end
                end
            end
            
            %% check if all ses variables have a value
            variables = obj.parent.Ses.var;
            variables(cellfun(@isempty,variables(:,1)),:) = [];  %delete empty cell entries
            vals = variables(:,2);
            valsNotEmpty = vals;
            valsNotEmpty(cellfun(@isempty,valsNotEmpty)) = [];  %delete empty cell entries
            if length(valsNotEmpty)<length(vals)
                flag = false;
                err{end+1} = 'Some SES Variables are not assigned to a value!';
            end
            
            %% check if leaf nodes are entities
            for i=1:obj.parent.Ses.nodes.Count
                nextNode = allNodes{i};
                if isempty(nextNode.children)
                    if ~strcmp(nextNode.type,'Entity')
                        flag = false;
                        err{end+1} = 'Descriptive Nodes are not allowed to be Leaf Nodes!';
                    end
                end
            end
            
            %% check if MAspect Attribute NumRep is assigned to a concrete Value
            %eval all ses Vars
            vars = obj.parent.Ses.var;
            vars(cellfun(@isempty,vars(:,1)),:) = [];  %delete empty cell entries
            val = vars(:,2);
            varnames = vars(:,1);
            NrOfVars = length(varnames);
            loop = 0;
            flagL = true;
            while flagL && loop<=NrOfVars
                loop = loop + 1;
                flagL = false;
                for i=1:length(varnames)
                    try
                        [str] = obj.convert2str(eval(val{i}));
                        str = [varnames{i},' = ',str,'; '];
                        eval(str)
                    catch %some input parameters are not defined yet, so try in next loop
                        flagL = true; %another while loop is needed
                    end            
                end
            end
            if loop > NrOfVars && NrOfVars>0
                flag = false;
                err{end+1} = 'Incorrect dependecies in SES Variables!';
                return
            end
            for i=1:obj.parent.Ses.nodes.Count
                nextNode = allNodes{i};
                if strcmp(nextNode.type,'MAspect')
                    NumRep = nextNode.numRep;
                    if isempty(NumRep)
                        flag = false;
                        err{end+1} = ['The NumRep of the MAspect ',nextNode.name,' is not assigned to a concrete value!'];
                        % Check if MAspect Numrep Variables have the right Data type
                    elseif isnumeric(eval(nextNode.numRep))
                        if length(eval(nextNode.numRep))==1
                            if eval(nextNode.numRep)>0 && uint16(eval(nextNode.numRep)) == eval(nextNode.numRep)
                                %everything ok
                            else
                                flag = false;
                                err{end+1} = ['Numrep Value of MultiAspect ',nextNode.name,' must be integer greater than 0!'];
                            end
                        else
                            flag = false;
                            err{end+1} = ['Numrep Value of MultiAspect ',nextNode.name,' must be a SINGLE integer value greater than 0!'];
                        end
                    else
                        flag = false;
                        err{end+1} = ['Numrep Value of MultiAspect ',nextNode.name,' must be integer greater than 0!'];
                    end
                end
            end  
            
            %% check Semantic Conditions
            Sem_Con = obj.parent.Ses.Semantic_Conditions;
            Sem_Con(cellfun(@isempty,Sem_Con(:,1)),:) = [];  %delete empty cell entries
            if ~isempty(Sem_Con)
                for i=1:length(Sem_Con)
                    nextSem_Con = Sem_Con{i};
                    try
                        evalCond = eval(nextSem_Con);
                        if ~evalCond
                            flag = false;
                            err{end+1} = ['SEM COND FALSE: ',nextSem_Con];
                        end
                    catch me
                        flag = false;
                        err{end+1} = ['SEM COND ERROR: ',nextSem_Con,' see promt'];
                        fprintf(2,'%s\n%s\n',nextSem_Con,me.message)
                    end                        
                end
            end
        end%function
        
        %% Merge 2 SES %%
        function merge(obj)
            [filename, pathname] = uigetfile({'*.mat','MAT-files (*.mat)'},...
                'Open Model');
            if filename ==0   %cancel was clicked  
                return
            else
                LoadModel = load ([pathname,filename]);
                existingVars = fields(LoadModel);
            end
            if ~ismember('new',existingVars)
%                 errordlg('File not valid.','File Error');
                obj.parent.InfoCenter.MSG('e',13,'');
                clear LoadModel  
            elseif ~isa(LoadModel.new,'ses')    
%                 errordlg('File not valid.','File Error');
                obj.parent.InfoCenter.MSG('e',13,'');
                clear LoadModel
            elseif isa(LoadModel.new,'ses')
                newSes = LoadModel.new;    
                %find Root in newSes
                NodeCount = newSes.nodes.Count;
                Indices = 1:NodeCount;
                Values = values(newSes.nodes);
                for i=1:NodeCount
                    nextObjNode = Values{i};
                    if isempty(nextObjNode.parent)
                        rootfather = nextObjNode;
                        Values(i) = [];
                        Indices(i) = [];
                        break
                    end
                end
            end
            %% get TreeStructure for replacing node    
            % create the rootnode
            IcPath = obj.Default.IconPath('entity');
            rootNode = uitreenode('v0','dummy', rootfather.name,IcPath, 0); 
            %create tree structure of newSes
            Level = 0;
            while ~isempty(Indices)
                NodeCountLeft = length(Indices);
                %save all current leaves
                LeafCount = rootNode.getLeafCount;
                firstLeaf = rootNode.getFirstLeaf;
                allLeaves = cell(1,LeafCount);
                for j=1:LeafCount
                    if j==1        
                        allLeaves{j} = firstLeaf;
                    elseif j==LeafCount
                        allLeaves{j} = rootNode.getLastLeaf;
                    else
                        allLeaves{j} = allLeaves{j-1}.getNextLeaf;
                    end
                end
                %look in next level
                Level = Level+1;     
                for i = NodeCountLeft:-1:1
                    nextObjNode = Values{i};
                    TP = nextObjNode.treepath;
                    LocOfSlash = strfind(TP,'/');
                    NrOfSlash = length(LocOfSlash);
                    if NrOfSlash == Level %node is child of the right level
                        %find the right father
                        for j=1:LeafCount
                            nextLeaf = allLeaves{j};
                            LeafName = obj.getName(nextLeaf);
                            if strcmp(LeafName,nextObjNode.parent)
                                father = nextLeaf;
                                break
                            end
                        end
                        %find the icon
                        switch nextObjNode.type
                            case 'Entity'
                            iconPath = obj.Default.IconPath('entity');
                            case 'Spec'
                            iconPath = obj.Default.IconPath('spec');
                            case 'Aspect'
                            iconPath = obj.Default.IconPath('aspect');
                            case 'MAspect'
                            iconPath = obj.Default.IconPath('masp');
                            otherwise
                            iconPath = obj.Default.IconPath('descNR');
                        end
                        %find the right location of the inserted Node
                        Children = father.children;
                        [treepath] = newSes.getTreepath(father);
                        objNodeFather = newSes.nodes(treepath);
                        ChildPos = 0;
                        while Children.hasMoreElements
                            Children.nextElement;
                            nxtChild = objNodeFather.children{ChildPos+1};
                            if strcmp(nxtChild,nextObjNode.name) 
                                break
                            end
                            ChildPos = ChildPos +1;
                        end                           
                        newNode = uitreenode('v0','dummy', nextObjNode.name, iconPath, 0);
                        father.insert(newNode,ChildPos) 
                        Values(i) = []; 
                        Indices(i) = [];                                
                    end%if
                end%for
            end%while 
            
            %% check if Node is replaceable
            %selected Node
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            selPath = obj.parent.Ses.getTreepath(selNode);
            selnodeObj = obj.parent.Ses.nodes(selPath);
            selName = selnodeObj.name;
            %rootNode of newSes
            rootPath = newSes.getTreepath(rootNode);
            rootnodeObj = newSes.nodes(rootPath);
            rootName = rootnodeObj.name;
            
            %--Function that checks if an inserted nodeName already exist--
            
            %get allnames of newSes tree
            if strcmp(rootName,selName) 
                allNewNodes = rootNode.breadthFirstEnumeration;
                allNewNodes.nextElement; %important to avoid checking the root for multi existance
            else
                allNewNodes = rootNode.breadthFirstEnumeration;
            end
            
            %check if there are equal nodes
            insertedNameExist = false;
            while allNewNodes.hasMoreElements
                nextNode = allNewNodes.nextElement;
                nextName = obj.getName(nextNode);
                allNodes=obj.parent.Hierarchy.hData.Trees.root1.depthFirstEnumeration;
                [ CountAnc ] = obj.nameExist( nextName, allNodes );
                if CountAnc  > 0
                    insertedNameExist = true;
                    break
                end
            end
            
            %% check validity -> if ok, replace node   
            if insertedNameExist
%                 errordlg('Merging is not possible, because at least one of the inserted Nodes already exist!','Merge Error');
                obj.parent.InfoCenter.MSG('e',15,'');
            else %merge all equal nodes as the selected one
                allNodes=obj.parent.Hierarchy.hData.Trees.root1.depthFirstEnumeration;        
                [ Count,equalNode ] = obj.nameExist( selName, allNodes );
                for i = 1:Count
                    %clone children and children�s children of rootNode via rekursive Fcn
                    if rootNode.getChildCount==0   %if identicNode has no children
                        SubTree = uitreenode('v0', 'subroot', 'subroot', [], false);
                        SubTree.add(rootNode.clone); 
                    else
                        knotcur = uitreenode('v0', 'subroot', 'subroot', [], false);
                        [ SubTree ] = getSubTree( knotcur,rootNode );  
                    end%if    
                    rootNodeClone = SubTree.getFirstChild; %ignore real Root of subtree    
                    %change Treepathes of new ObjNodes and insert them to Ses
                    Path = obj.parent.Ses.getTreepath(equalNode{i});
                    objNode = obj.parent.Ses.nodes(Path);
                    addPath = objNode.getParentPath;   
                    parentNode = obj.parent.Ses.nodes(addPath);
                    newValues = values(newSes.nodes);
                    %pepare Selection Constraints
                    SelCons = newSes.Selection_Constraints.Pathes;
                    SelCons(cellfun(@isempty,SelCons(:,1)),:) = [];  %delete empty cell entries
                    for ii=1:newSes.nodes.Count
                        %copy node
                        copyNode = feval(class(newValues{ii}),[],[],[],[],[]);
                        pnode = properties(newValues{ii});
                        for jj = 1:length(pnode)
                            copyNode.(pnode{jj}) = newValues{ii}.(pnode{jj}); 
                        end
                        newPath = [addPath,'/',copyNode.treepath];
                        %change parentname and Childname if it is the root
                        if isempty(copyNode.parent)
                            copyNode.parent = parentNode.name;
                            rightChild = strcmp(parentNode.children,selName);
                            parentNode.children{rightChild} = copyNode.name;
                            %change SelCon of node that shall be replaced (if exist)
                            [obj.parent.Ses.Selection_Constraints.Pathes] = obj.adjustPathesInSelCon(obj.parent.Ses.Selection_Constraints.Pathes,Path,newPath);
                            %if replaced node is part of selcon and has a color, than give
                            %new rootnode the same color
                            htmlname = char(selNode.getName);
                            if ismember('>',htmlname) %node has a color
                                htmlpart = strfind(htmlname,'>'); 
                                htmlpart = htmlpart(end);
                                htmlpart = htmlname(1:htmlpart);
                                rootNodeClone.setName([htmlpart,obj.getName(rootNodeClone)]);
                                pause(0.1)
                                drawnow limitrate nocallbacks
                            end
                            %if father of node that shall be replaced is spec, than look
                            %for specrule case and change name potentially
                            if strcmp(parentNode.type,'Spec')
                                Specrule = parentNode.specrule;
                                Selection = Specrule(:,1);
                                Selection(cellfun(@isempty,Selection)) = [];  %delete empty cell entries
                                rightName = strcmp(selName,Selection);
                                parentNode.specrule(rightName,1) = {copyNode.name};
                            end
                        end
                        %check if node is part of selection constraints and change path
                        SelCons = obj.adjustPathesInSelCon(SelCons,copyNode.treepath,newPath);
                        copyNode.treepath = newPath;
                        obj.parent.Ses.nodes(newPath) = copyNode;
                    end
                    %define the place where the replaced Node shall be inserted
                    children=equalNode{i}.getParent.children;
                    for l=1:equalNode{i}.getParent.getChildCount()
                        nextChild = children.nextElement;
                        if strcmp(obj.getName(nextChild),obj.getName(equalNode{i}))
                            childInsert = l;
                            break
                        end     
                    end        
                    [treenode] = obj.parent.Ses.getTreeNode(addPath); %parent Treenode for inserting 
                    obj.parent.Hierarchy.hData.Trees.TreeModels.tm1.insertNodeInto(rootNodeClone,treenode,childInsert); 
                    %remove node only if the inserted root and selected node have different names
                    if ~strcmp(rootName,selName) 
                        remove(obj.parent.Ses.nodes,obj.parent.Ses.getTreepath(equalNode{i}));
                    end
                    obj.parent.Hierarchy.hData.Trees.TreeModels.tm1.removeNodeFromParent( equalNode{i} );
                    obj.parent.Hierarchy.hData.Trees.mtree1.setSelectedNode( rootNodeClone );
                    %% add all SelectionC Constraints of newSes to obj.parent.Ses
                    obj.parent.Ses.Selection_Constraints.Pathes = [obj.parent.Ses.Selection_Constraints.Pathes;SelCons];
                end
                
                %% add all Variables of newSes to obj.parent.Ses
                newSes.var(cellfun(@isempty,newSes.var(:,1)),:) = [];  %delete empty cell entries
                SesVars = obj.parent.Ses.var(:,1);
                SesVars(cellfun(@isempty,SesVars)) = [];%delete empty cell entries
                for varNr = 1:size(newSes.var,1)
                    nextVarname = newSes.var{varNr,1};
                    %if variable doesnt exist is main Ses -> add variable
                    if ~ismember(nextVarname,SesVars)
                        obj.parent.Ses.var = [obj.parent.Ses.var;newSes.var(varNr,:)];
                    end
                end
                
                %% add all Semantic Conditions of newSes to obj.parent.Ses
                newSes.Semantic_Conditions(cellfun(@isempty,newSes.Semantic_Conditions)) = [];  %delete empty cell entries
                obj.parent.Ses.Semantic_Conditions(cellfun(@isempty,obj.parent.Ses.Semantic_Conditions)) = [];  %delete empty cell entries
                SemanticRelsold = obj.parent.Ses.Semantic_Conditions;
                for h=1:length(newSes.Semantic_Conditions)
                    nextSemRelnew = newSes.Semantic_Conditions{h};
                    flag = false;
                    for g=1:length(SemanticRelsold)
                        nextSemRelold = SemanticRelsold{g};
                        obj.parent.Parser.TranslationUnit(nextSemRelnew,'Condition',obj.parent.Ses)
                        SymListnew = obj.parent.Parser.SymList;
                        obj.parent.Parser.TranslationUnit(nextSemRelold,'Condition',obj.parent.Ses)
                        SymListold = obj.parent.Parser.SymList;
                        [flag] = obj.parent.Parser.symcmp(SymListnew,SymListold);
                        if flag
                            break
                        end 
                    end
                    if ~flag
                        obj.parent.Ses.Semantic_Conditions = [obj.parent.Ses.Semantic_Conditions;nextSemRelnew];
                    end 
                end
                if isempty(obj.parent.Ses.Semantic_Conditions)
                    obj.parent.Ses.Semantic_Conditions = cell(1);
                end
                
                % obj.parent.Ses.Semantic_Conditions = [obj.parent.Ses.Semantic_Conditions;newSes.Semantic_Conditions];
                %% add all Functions of newSes to obj.parent.Ses
                existingFunNames = {};
                for funNr = 1:length(obj.parent.Ses.fcn)
                    nextName = obj.parent.Ses.fcn{funNr}.Filename;
                    existingFunNames = [existingFunNames,nextName];
                end
                for funNr =1:length(newSes.fcn)
                    nextName = newSes.fcn{funNr}.Filename;
                    if ~isempty(nextName) && ~ismember(nextName,existingFunNames)
                        obj.parent.Ses.fcn = [obj.parent.Ses.fcn;newSes.fcn{funNr}];
                    end
                end
            end
            
            %% prepare tabledata for Selection Constraints
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
            
            %refresh Table Colors of Selection Constraints
            SelConData = cell(rows,2);
            for i=1:rows
                if ~isempty(SelCons{i,1})
                    sourcePath = SelCons{i,1};
                    sourceNode = obj.parent.Ses.getTreeNode(sourcePath);
                    [~,htmlname] = obj.parent.Ses.getName(sourceNode);
                    SelConData{i,1} = htmlname;
                    sinkNames = '';
                    for k=1:length(SelCons{i,2})
                        sinkPath = SelCons{i,2}{k};
                        sinkNode = obj.parent.Ses.getTreeNode(sinkPath);
                        [name2,htmlname2] = obj.parent.Ses.getName(sinkNode);
                        sinkNames = [sinkNames,' , ',name2];
                    end
                    sinkNames = sinkNames(4:end);
                    if strcmp(name2,htmlname2)
                        SelConData{i,2} = sinkNames;
                    else
                        htmlpartend = strfind(htmlname2,'>');
                        htmlpartend = htmlpartend(end);
                        htmlpart = htmlname2(1:htmlpartend);
                        SelConData{i,2} = [htmlpart,sinkNames];
                    end
                else
                    SelConData(i,:) = cell(1,2);
                end
            end%for  
            
            if isempty(SelConData)
                SelConData = cell(1,2);
                obj.parent.Ses.Selection_Constraints.Pathes = cell(1,2);
            end
            
            %% Prepare Tabledata for Functions
            FunData = cell(length(obj.parent.Ses.fcn),1);
            for indF=1:length(obj.parent.Ses.fcn)
                FunData{indF} = obj.parent.Ses.fcn{indF}.Filename;
            end
            % upload all Setting Tables
            set(obj.parent.Settings.hData.Tables.mtable1,'Data',SelConData)
            set(obj.parent.Settings.hData.Tables.mtable2,'Data',obj.parent.Ses.var)
            set(obj.parent.Settings.hData.Tables.mtable3,'Data',FunData)
            set(obj.parent.Settings.hData.Tables.mtable4,'Data',obj.parent.Ses.Semantic_Conditions)
            pause(0.1)
            drawnow limitrate nocallbacks
            obj.parent.Settings.hData.Tables.jtable1.setRowSelectionInterval(0,0)
            obj.parent.Settings.hData.Tables.jtable2.setRowSelectionInterval(0,0)            
            obj.parent.Settings.hData.Tables.jtable3.setRowSelectionInterval(0,0)            
            obj.parent.Settings.hData.Tables.jtable4.setRowSelectionInterval(0,0)        
            %- Update TypeProperties after Node Change      
            % obj.parent.Hierarchy.UpdateHierarchyChange('replace',firstNode,rootNode)
                    
            %refresh the visible type property of the selected node--
            obj.parent.Props.UpdatePropertyWindow
             
            % --Update Selection Constraints according to a tree change 
            obj.parent.Settings.UpdateSelConAfterTreeChange( 'Others' )
            obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged') %for Updating current SelConWindow
            
            
            %% recursive function to clone new treestructure 
            function SubTree = getSubTree( knotcur,rootNode )        
                % falls Vater keine Kinder hat ergibt sich knot1 aus Vater
                if rootNode.getChildCount==0
                    knotcur.add(rootNode.clone);
                else
                    Children= rootNode.children;
                    ChildNr = rootNode.getChildCount;
                    allChildren = cell(1,ChildNr);
                    for kk=1:ChildNr
                        allChildren{kk} = Children.nextElement;
                    end
                    knotnew = rootNode.clone;
                    for chnr = 1:ChildNr
                        [ knotnew ] = getSubTree( knotnew, allChildren{chnr} );
                    end
                    knotcur.add(knotnew);    
                end
                SubTree = knotcur;
            end%function
        end%function
        
        function SelCons = adjustPathesInSelCon(~,SelCons,oldPath,newPath)
            Sources = SelCons(:,1);
            equalPath = strcmp(oldPath,Sources);
            SelCons(equalPath,1) = {newPath};
            Sinks = SelCons(:,2);
            for i=1:length(Sinks)
                nextSinks = Sinks{i};
                equalPath = strcmp(oldPath,nextSinks);
                SelCons{i,2}(equalPath) = {newPath};
            end
        end%function
        
        function enableDisableMerge(obj)
            selNode = obj.parent.Hierarchy.hData.Trees.selectedNode1;
            if selNode.isRoot
                %during programstart menu doesnt exist when method is called
                if isfield(obj.hData,'menu')
                    set(obj.hData.menu.m1,'Enable','off')
                end
            else
                %check all Nodes with equal names if parent is maspect
                allNodes=obj.parent.Hierarchy.hData.Trees.root1.depthFirstEnumeration;
                [ Count,equalNode ] = obj.nameExist( obj.getName(selNode), allNodes );
                parentIsMAsp = false;
                for i=1:Count
                    nextNode = equalNode{i};
                    if strcmp(obj.parent.Ses.getType(nextNode.getParent),'MAspect')
                        parentIsMAsp = true;
                        break
                    end
                end
                TP = obj.parent.Ses.getTreepath(selNode);
                nodeObj = obj.parent.Ses.nodes(TP);
                if strcmp(nodeObj.type,'Entity') && selNode.isLeaf && ~selNode.getParent.isRoot && ~parentIsMAsp
                    %enable Merging
                    set(obj.hData.menu.m1,'Enable','on')
                else
                    %disable Merging
                    set(obj.hData.menu.m1,'Enable','off')
                end
            end
        end%function
        
        % Check if descission nodes will be created during the pruning process
        function AspConnection = checkNextLevelDescissions(obj)
            [flag,err] = obj.checkPermission;
            if ~flag
                for errNr = 1:length(err) 
                    %errordlg(err{errNr}); 
                    obj.parent.InfoCenter.MSG('e',1,err{errNr});
                end
                return
            end
            import javax.swing.*
            import javax.swing.tree.*;
            allNodeObj = values(obj.parent.Ses.nodes);
            AspConnection = {};
            for i=1:obj.parent.Ses.nodes.Count
                nextnodeObj = allNodeObj{i};
                if ismember(nextnodeObj.type,{'Aspect','MAspect'})
                    [ParentPath] = nextnodeObj.getParentPath;
                    ParentNode = obj.parent.Ses.nodes(ParentPath);
                    [Connection] = getAspConnection(ParentNode);
                    AspConnection = [AspConnection;{Connection}];
                end%if
            end%for
            %delete all connections with length == 1
            for j=length(AspConnection):-1:1
                nextConnect = AspConnection{j};
                if length(nextConnect) == 1
                    AspConnection(j) = [];
                end
            end
            for jj=length(AspConnection):-1:1
                treepaths1 = cell(1,length(AspConnection{jj}));
                for tp=1:length(AspConnection{jj})
                    treepaths1{tp} = AspConnection{jj}{tp}.treepath;
                end
                for jjj=length(AspConnection):-1:1
                    if jjj ~= jj
                        for tp=1:length(AspConnection{jjj})
                            treepaths2{tp} = AspConnection{jjj}{tp}.treepath;
                        end
                        flag = ismember(treepaths1,treepaths2);
                        %all treepaths are equal
                        if ~ismember(false,flag)
                            AspConnection(jj) = [];
                            break
                        end
                    end
                end
            end
            
            %open figure with table to show connections of inheritenceAsp
            %Descission
            if ~isempty(AspConnection)
                %prepare Data,
                obj.hData.openDes.Connections = cell(length(AspConnection),1);
                Data = cell(length(AspConnection),1);
                for kk=1:length(AspConnection)
                    nextConnect = AspConnection{kk};
                    name = '';
                    obj.hData.openDes.Connections{kk} = cell(1,length(nextConnect));
                    for kkk=1:length(nextConnect)
                        name = [name,' , ',nextConnect{kkk}.name];
                        obj.hData.openDes.Connections{kk}{kkk} = nextConnect{kkk}.treepath;
                    end
                    Data{kk} = name(4:end);
                end
                
               
                obj.hData.openDes.subfig = dialog(... %orig: figure()
                    'Color',        obj.Default.Color.BG_P,...
                    'Name',         'Open Decisions',...
                    'Units',        'normalized',...
                    'Position',     [0.3,0.3,0.3,0.2],...
                    'DeleteFcn',    @(hobj,evt) obj.delete2);  
                
                VBox = uiextras.VBox(... 
                    'Parent',            obj.hData.openDes.subfig,...
                    'Spacing',           0,...
                    'Padding',           0,...
                    'BackgroundColor',   obj.Default.Color.BG_P);
                
                tmp = BasicJTable(VBox,{'Connected (M)Aspects'},...
                    'Data',             Data);
                obj.hData.openDes.mtable = tmp.hnd;
                obj.hData.openDes.jtable = tmp.jtable;
                
                
                set(obj.hData.openDes.jtable.getSelectionModel,...
                    'ValueChangedCallback',@(hobj,evt)obj.Selectioncbck)               
                    
                obj.Selectioncbck            
            else
%                 helpdlg('No Open Decisions exist!','Check Open Decisions');
                obj.parent.InfoCenter.MSG('h',3,'');
            end
            %% recursive function to find nextLevelRules
            function AspConnection = getAspConnection(ParentNode)
                AspConnection = {};
                %                 newConnection = {};
                ChildrenPath = ParentNode.getChildrenPath;
                allChildren = {};
                for k=1:length(ChildrenPath)
                    allChildren = [allChildren,{obj.parent.Ses.nodes(ChildrenPath{k})}];
                end
                for ii=1:length(allChildren)
                    nextChildren = allChildren{ii};
                    Type = nextChildren.type;
                    switch Type
                        case {'Entity','Spec'}
                        [newConnection] = getAspConnection(nextChildren);
                        AspConnection = [AspConnection,newConnection];
                        case {'Aspect','MAspect'}
                        AspConnection = [AspConnection,{nextChildren}];
                    end
                end
            end
        end%function
        
        %% SelectionChangeFcn in Open Descissions %%       
        function Selectioncbck(obj)
            connectedPaths = obj.hData.openDes.Connections;
            selRow = obj.hData.openDes.jtable.getSelectedRow;
            for j=1:length(connectedPaths)
                conPathsRow = connectedPaths{j};
                for i = 1:length(conPathsRow)
                    nextPath = conPathsRow{i};
                    TreeNode = obj.parent.Ses.getTreeNode(nextPath);
                    Type = obj.parent.Ses.getType(TreeNode);
                    if j==selRow+1
                        switch Type
                            case 'Aspect'
                            iconPath = obj.Default.IconPath('aspectD');
                            case 'MAspect'
                            iconPath = obj.Default.IconPath('maspD');
                        end
                    else
                        switch Type
                            case 'Aspect'
                            iconPath = obj.Default.IconPath('aspect');
                            case 'MAspect'
                            iconPath = obj.Default.IconPath('masp');  
                        end
                    end
                    jImage = java.awt.Toolkit.getDefaultToolkit.createImage(iconPath);
                    TreeNode.setIcon(jImage)
                end
            end
            obj.parent.Hierarchy.hData.Trees.jtree1.treeDidChange();
        end%function
        
        %% delete sub Figure 
        function delete2(obj)
            allNodes = values(obj.parent.Ses.nodes);
            obj.parent.Hierarchy.validateDescissionNodes(allNodes);
            set(obj.hData.openDes.jtable.getSelectionModel,'ValueChangedCallback',[])
            delete(obj.hData.openDes.mtable)
            obj.hData = rmfield(obj.hData,'openDes');            
        end%function        
        
        %%        
        function showNotes(~,Name,varargin)            
            uicontrol(...
                'Parent',           figure('NumberTitle','off','MenuBar','None'),...
                'BackgroundColor',  [1 1 1],...
                'Units',            'normalized',...
                'Position',         [0,0,1,1],...
                'Style',            'edit',...                  
                'Max',              60,...
                'Enable',           'inactive',...
                'String',           fileread(which(Name)),...
                'ButtonDownFcn',    @(edt_obj,~)close(edt_obj.Parent),...    
                varargin{:})
        end 
        
        %%
        function takeImage(obj)            
            bild = getframe(obj.parent.hData.f); 
            [jpegfile, path2jpeg] = uiputfile(...
                ['Screenshot_',date,'_P',num2str(obj.NumOfScSh),'.png'],'Save to '); 
            if jpegfile
                FileName = fullfile(path2jpeg, jpegfile); 
                imwrite(bild.cdata, FileName, 'png');
                obj.NumOfScSh = obj.NumOfScSh + 1;
            end
        end        
        
        %%
        function closeEditor(obj,varargin)
            obj.closeWindow();
            close(obj.parent.hData.f);
        end  
        
        %%
        function AddMenuFeatures(obj)
            %### Some Java Tweaks ###
            try
                jMenuBar = obj.parent.hData.jFrame.fHG2Client.getMenuBar;
            catch
                jMenuBar = obj.parent.hData.jFrame.fHG1Client.getMenuBar;
            end
            
            
            try % Dynamic menu behavior
                for menuIdx = 1 : jMenuBar.getComponentCount
                    jMenu = jMenuBar.getComponent(menuIdx-1);
                    
                    %try to render the menu somehow
                    jMenu.repaint; drawnow;
                    jMenu.doClick; drawnow;
                    jMenu.doClick; drawnow;
                    
                    jMenu.repaint; drawnow;
                    jMenu.doClick; drawnow;
                    jMenu.doClick; drawnow;
                    
                    %hjMenu = handle(jMenu,'CallbackProperties');
                    %set(hjMenu,'MouseEnteredCallback','doClick(gcbo)');
                end
                drawnow; pause(.1)
                
                %DO THIS TWICE ! DO THIS TWICE ! DO THIS TWICE ! DO THIS TWICE
                
                for menuIdx = 1 : jMenuBar.getComponentCount
                    jMenu = jMenuBar.getComponent(menuIdx-1);
                    
                    %try to render the menu somehow
                    jMenu.repaint; drawnow;
                    jMenu.doClick; drawnow;
                    jMenu.doClick; drawnow;
                    
                    jMenu.repaint; drawnow;
                    jMenu.doClick; drawnow;
                    jMenu.doClick; drawnow;
                    
                    jMenu.ABORT;
                    %hjMenu = handle(jMenu,'CallbackProperties');
                    %set(hjMenu,'MouseEnteredCallback','doClick(gcbo)');
                end
            catch
            end
            
            try % Custom accelerator shortcut keys
                jFileMenu = jMenuBar.getComponent(0);   % inspect(jFileMenu)
                jFileMenu.repaint; drawnow;
                jFileMenu.doClick; drawnow;
                jFileMenu.doClick; drawnow;
                jSaveAs = jFileMenu.getMenuComponent(5);
                
                jAccelerator = javax.swing.KeyStroke.getKeyStroke('ctrl shift S');
                jSaveAs.setAccelerator(jAccelerator);
            catch
            end
            drawnow; pause(.1)
            
            try % Tooltip and (highlight: jSaveAs.setArmed(true);)
                jPrunningMenu = jMenuBar.getComponent(1);
                jPrunningMenu.repaint; drawnow;
                jPrunningMenu.doClick; drawnow;
                jPrunningMenu.doClick; drawnow;
                jPruneMenu    = jPrunningMenu.getMenuComponent(1);
                jPruneMenu_1  = jPruneMenu.getMenuComponent(0);
                jPruneMenu_2  = jPruneMenu.getMenuComponent(1);
                jPruneMenu_3  = jPruneMenu.getMenuComponent(2);
                
                jMergingMenu  = jMenuBar.getComponent(2);
                jMergingMenu.repaint; drawnow;
                jMergingMenu.doClick; drawnow;
                jMergingMenu.doClick; drawnow;
                jMergingMenu.ABORT;
                jMergingMenu.doLayout;
                jMerging      = jMergingMenu.getMenuComponent(0);
                
                filePath = obj.Default.IconPath('PRUNING');
                htmlstr = ['<html><center><img src="file:' filePath '">'];
                jPruneMenu_1.setToolTipText(htmlstr);
                jPruneMenu_2.setToolTipText(htmlstr);
                
                filePath = obj.Default.IconPath('FLATTEN');
                htmlstr = ['<html><center><img src="file:' filePath '">'];
                jPruneMenu_3.setToolTipText(htmlstr);
                
                filePath = obj.Default.IconPath('MERGING');
                htmlstr = ['<html><center><img src="file:' filePath '">'];
                jMerging.setToolTipText(htmlstr);
            catch
            end
        end
        
        function generateReport(obj)
            title = get(get(obj.parent.hData.tabgp,'SelectedTab'),'Title');
            [filename, filepath] = uiputfile(...
                    {'*.html','HTML-file (*.html)'},'Save Report',title(1:end-4));
            if filename ~=0  
                GenSesHTMLDoc(obj.parent.Ses,title,[filepath,filename])
            end
        end
    end
end
