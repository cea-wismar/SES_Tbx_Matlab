
classdef hierarchy < ses_gui_components.supportFun
    properties
        mainPanel
    end
    
    methods
        %% Constructor Hierarchy %
        function obj = hierarchy(parent) %constructor
            obj.parent = parent; 
            import javax.swing.*
            import javax.swing.tree.*;            
          
            VBox = uiextras.VBox(...
                'Parent',           obj.parent.hData.f2,...
                'Spacing',          0,...
                'Padding',          0,...
                'BackgroundColor',  obj.Default.Color.BG_D);
            
            uiextras.Empty(...
                'Parent',           VBox,...                
                'BackgroundColor',  obj.Default.Color.BG_D);
            set(VBox,'Sizes',19)
            
            
            % Design - Hierarchy     
            obj.mainPanel = uiextras.Grid(...
                'Parent',           VBox,...
                'Spacing',          0,...
                'Padding',          0,...
                'BackgroundColor',  obj.Default.Color.BG_P); 
            
            set(VBox,'Sizes',[19 -1])              
            
            uiextras.Empty(...
                'Parent',           obj.mainPanel,...                
                'BackgroundColor',  obj.Default.Color.BG_P); 
            
            % Horizontal Button Bar    
            BBar = VBttnBar(obj.mainPanel);    
            
            %0.)middle - Hierarchy Icon Toolbar
            % 1.) Icon add SubNode
            IconObj = JBttn(BBar.hnd,'addSubN','Add Sub Node');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.addSubNode(hobj,evt));
            set(IconObj.hnd,'MultiClickThreshhold',1);
            obj.hData.jhb1         = IconObj.hnd;
            IconObj.setToolTipPicture('TTSubN');
            
            % 2.) Icon add SibblingNode 
            IconObj = JBttn(BBar.hnd,'addSib2','Add Sibling Node');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.addSiblingNode(hobj,evt));
            obj.hData.jhb2         = IconObj.hnd;
            IconObj.setToolTipPicture('TTSibN');
                          
            % 3.) Icon delete Node 
            IconObj = JBttn(BBar.hnd,'delN','Delete Node');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.deleteSelNode(hobj,evt));
            set(IconObj.hnd,'MultiClickThreshhold',1);
            obj.hData.jhb3         = IconObj.hnd;
            
            
            uiextras.Empty(...
                'Parent',           BBar.hnd,...                
                'BackgroundColor',  obj.Default.Color.BG_P);
            
            % 3.a) Icon expand Node 
            IconObj = JBttn(BBar.hnd,'expand','expand');
            set(IconObj.hnd,'MouseClickedCallback',@(hobj,evt)obj.expand);
            obj.hData.jhb3a         = IconObj.hnd;
            
            
            % 3.b) Icon collapse Node 
            IconObj = JBttn(BBar.hnd,'collapse','collapse');
            set(IconObj.hnd,'MouseClickedCallback',...
                @(hobj,evt)obj.collapse);
            obj.hData.jhb3b         = IconObj.hnd;
                        
            
             uiextras.Empty(...
                'Parent',           BBar.hnd,...                
                'BackgroundColor',  obj.Default.Color.BG_P);
            
            % show TreeView
            IconObj = JTglBttn(BBar.hnd,'tree','TreeView');
            set(IconObj.hnd,'MouseClickedCallback',@(hobj,evt)obj.TrVwState);
            obj.hData.TreeViewBtn   = IconObj.hnd;
            
            % show DebugView
            IconObj = JTglBttn(BBar.hnd,'bug','DebugView');
            set(IconObj.hnd,'MouseClickedCallback',@(hobj,evt)obj.DbVwState);
            obj.hData.DebugViewBtn   = IconObj.hnd;
                        
            HB = uiextras.HBox(...
                'Parent',               obj.mainPanel,... 
                'Padding',              5,...
                'Spacing',              3,...                ..
                'BackgroundColor',      obj.Default.Color.BG_P);  
                    
            % 6.) Text rename node 
            obj.hData.hb6 = [];
            
            % 5.) Edit rename node
            tmp = BasicEdit(HB,'',...
                'callback',             @(hobj,evt)obj.renameNode,...
                'Enable',               'off');
            obj.hData.hb5 = tmp.hnd;
            
            % 8.) Text select Type  
            BasicText(HB,'Type:','HorizontalAlignment','right');
            
            
            % 7.) Popupmenu select Type                       
            obj.hData.hb7 = uicontrol(...
                'Parent',               HB,...
                'Style',                'popupmenu',...
                'BackgroundColor',      obj.Default.Color.FG,...                
                'String',               {' ','Aspect','Spec','MAspect'},...
                'FontSize',             obj.Default.Font.SizeM,...
                'FontName',             obj.Default.Font.Name,...                
                'Enable',               'off',...
                'Callback',@(hobj,evt)popupMenuCallback(obj,hobj,evt)); 
            
            set(HB,'Sizes',[-1 40 100]) 
            
            TreePanel = uiextras.Panel(...
                'Parent',               obj.mainPanel,...
                'Padding',              5,...
                'BorderType',           'none',...
                'BackgroundColor',      obj.Default.Color.BG_P);
            
                        
            % 4.) Tree             
            obj.hData.Trees.root1 = uitreenode('v0', '', '', [], false); %define the root
            obj.hData.Trees.TreeModels.tm1 = DefaultTreeModel(   obj.hData.Trees.root1); %create treemodel
            [obj.hData.Trees.mtree1, obj.hData.Trees.treehandles.th1] = uitree( 'v0', 'root',obj.hData.Trees.root1);
            
            set(obj.hData.Trees.mtree1,...
                'NodeSelectedCallback', @(hobj,evt)nodeSelectedCallback1(obj,hobj,evt)) %generate callback
            obj.hData.Trees.mtree1.setModel( obj.hData.Trees.TreeModels.tm1 );
            
            set(obj.hData.Trees.treehandles.th1,...
                'Visible',              'on',...
                'BackgroundColor',      [0,0,0]);
            
            drawnow limitrate nocallbacks
            pause(.1)
            
            try
                set(obj.hData.Trees.treehandles.th1,...
                    'Parent',           TreePanel);
            catch %Release < R2014b
                set(obj.hData.Trees.treehandles.th1,...
                    'Parent',           TreePanel.double);
            end
            drawnow limitrate nocallbacks
            pause(.1)
            
            %get java Tree
            obj.hData.Trees.jtree1 = handle(obj.hData.Trees.mtree1.getTree,'CallbackProperties');
            obj.hData.Trees.jtree1.setRootVisible(false)
            bgc = obj.Default.Color.FG;
            
            obj.hData.Trees.jtree1.setBackground(java.awt.Color(bgc(1),bgc(2),bgc(3)));
            % obj.hData.Trees.jtree1.setBorder(javax.swing.BorderFactory.createLineBorder(java.awt.Color(bgc(1),bgc(2),bgc(3))))
            % Tree 1: Hierarchy Tree         
            
            %Parent
            set(obj.mainPanel,'RowSizes',[35 -1],'ColumnSizes',[35 -1])      
        end %constructor
        
        %% destructor 
        function delete(obj)
            try
                set(obj.hData.Trees.mtree1,'NodeSelectedCallback', [])
            catch
            end            
        end %destructor        
        
        %% Add a new Sub Node in the Hierarchy Tree %
        function  addSubNode( obj,~,~ )
            %get selected node and its properties
            node = obj.hData.Trees.selectedNode1;
            level = node.getLevel;
            %check if 1 root already exist
            ChNr = obj.hData.Trees.root1.getChildCount;
            if  obj.hData.Trees.root1.equals(node) && ChNr > 0 
                %never minds
            else  
                %check if parent is MAspect; if so, only one Entity node can exist
                NrofSib = node.getChildCount;
                if strcmp(obj.parent.Ses.getType(node),'MAspect') && NrofSib >= 1 
                    %errordlg('Only one Entity Node can exist under a Multiple Aspect Node!','add-SubNode-Error');
                    obj.parent.InfoCenter.MSG('e',2,'');
                else
                    % Axiom Alternate Mode
                    if level/2 == round(level/2)
                        iconPath = obj.Default.IconPath('entity');  %set Icon label
                        EntityCount = 0;                            %set the node counter to 0
                        Count = 2; %Access to the while loop
                        while Count>0 %while at least one identic name exist
                            EntityCount = EntityCount+1;
                            newName = ['e',num2str(EntityCount)];  %desired node name
                            allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                            Count = obj.nameExist( newName, allNodes ); %check how often desired Name exist
                        end% now the newName is unic
                    else 
                        iconPath = obj.Default.IconPath('descNR');          %set Icon label 
                        DescriptiveCount = 0;                               %set the node counter to 0
                        Count = 2; %Access to the while loop
                        while Count>0 %while at least one identic name exist
                            DescriptiveCount = DescriptiveCount+1;
                            newName = ['d',num2str(DescriptiveCount)];  %desired node name
                            allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                            Count = obj.nameExist( newName, allNodes ); %check how often desired Name exist
                        end% now the newName is unic
                    end%alternate mode
                    %put unique name under each equal parent
                    allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                    parentName = obj.getName(node);
                    [ Count, equalParent ] = obj.nameExist( parentName, allNodes ); %counts equal parentnames and returns the nodes
                    for i = 1:Count
                        curParent = equalParent{i};
                        childNode = uitreenode('v0','dummy', newName, iconPath, 0);
                        obj.hData.Trees.TreeModels.tm1.insertNodeInto(childNode,curParent,0); 
                        % "ses-class": generate node object
                        obj.parent.Ses.addNode(childNode);
                        
                    end
                    obj.hData.Trees.mtree1.setSelectedNode( node.getFirstChild );     %node prop updated and showing childNode
                    % Update the List of selectable Node for Selection Constraints 
                    obj.parent.Settings.getListOfSelectableNodes  
                    
                    %check if all descissions are made, if not color icon red-
                    allNodes = values(obj.parent.Ses.nodes);
                    obj.validateDescissionNodes(allNodes);
                    
                end %multiplerAspect          
            end    
            
        end %function
        %
        
        %% Add a new Sibbling Node in the Hierarchy Tree %        
        function  addSiblingNode( obj,~,~ )
  
            %get selected node and its properties
            node = obj.hData.Trees.selectedNode1;
            level = node.getLevel;
            parentNode = getParent(node);
            ChNr = obj.hData.Trees.root1.getChildCount;
            if  obj.hData.Trees.root1.equals(parentNode) && ChNr > 0 %Root = Parent und bereits 1 kind vorhanden
                % never mind
            else        
                %         if  parent is not the SES root
                if ~isempty(parentNode)
                    %check if parent is MAspect; if so, only one Entity node can exist
                    NrofSib = node.getSiblingCount;
                    %Only one Entity Node can exist under a Multiple Aspect Node
                    if strcmp(obj.parent.Ses.getType(node.getParent),'MAspect') && NrofSib >= 1 %                         
                        obj.parent.InfoCenter.MSG('e',2,'');
                    else
                        if level/2 == round(level/2) 
                            iconPath = obj.Default.IconPath('descNR');                %set Icon label
                            DescriptiveCount = 0;                           %set the node counter to 0
                            Count = 2; %Access to the while loop
                            while Count>0 %while at least one identic name exist
                                DescriptiveCount = DescriptiveCount+1;
                                newName = ['d',num2str(DescriptiveCount)];  %desired node name
                                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                                [ Count ] = obj.nameExist( newName, allNodes ); %check how often desired Name exist
                            end% now the newName is unique  
                        else
                            iconPath = obj.Default.IconPath('entity');              %set Icon label
                            EntityCount = 0;                            %set the node counter to 0
                            Count = 2; %Access to the while loop
                            while Count>0 %while at least one identic name exist
                                EntityCount = EntityCount+1;
                                newName = ['e',num2str(EntityCount)];  %desired node name
                                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                                [ Count ] = obj.nameExist( newName, allNodes ); %check how often desired Name exist
                            end% now the newName is unique   
                        end
                        %define the place where the child shall be inserted
                        children = parentNode.children;
                        for i = 1:parentNode.getChildCount()
                            nextChild = children.nextElement;
                            if strcmp(obj.getName(nextChild),obj.getName(node))
                                childInsert = i;
                                break
                            end     
                        end
                        %put unique name under each equal parent
                        allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                        parentName = obj.getName(parentNode);
                        [ Count, equalParent ] = obj.nameExist( parentName, allNodes ); %counts equal parentnames and returns the nodes
                        for i = 1:Count
                            curParent = equalParent{i};
                            childNode = uitreenode('v0','dummy', newName, iconPath, 0);
                            obj.hData.Trees.TreeModels.tm1.insertNodeInto(childNode,curParent,childInsert); 
                            % "ses-class": generate node object
                            obj.parent.Ses.addNode(childNode);
                             
                        end 
                        obj.hData.Trees.mtree1.setSelectedNode( node.getNextSibling); %change selection to added Sibling
                        % Update the List of selectable Node for Selection Constraints 
                        obj.parent.Settings.getListOfSelectableNodes  
                                     
                        %check if all descissions are made, if not color icon red-
                        allNodes = values(obj.parent.Ses.nodes);
                        obj.validateDescissionNodes(allNodes);
                        
                    end%multipleAspect
                end    
            end 
            
        end %function        
        
        %% Delete selected node in the Hierarchy Tree %       
        function deleteSelNode( obj,~,evt )
            %This is important to slow down the click tempo which will lead to error messages
            %every second click is acceptable, when user is clicking very fast
            ClickCount = get(evt,'ClickCount');
            if round(ClickCount/2) ~= ClickCount/2
                node = obj.hData.Trees.selectedNode1;
                %             selNode = node; %is needed for typeProp Update            
                if ~node.isRoot
                    nodeName = obj.getName(node);
                    allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                    [ Count, equalNode ] = obj.nameExist( nodeName, allNodes );
                    %falls mehr als ein Knotenname
                    %1. Mglk: l�schen aller gleichnamigen Knotennamen
                    %2. Mglk: l�schen des ersten gleichnamigen Vaters
                    %3. Mglk: Abbrechen
                    %sonst normales l�schen
                    if Count > 1
                        % auswahlfigure window
%                         button = questdlg('More than one node with the same name exist.','Select the deletion method!',...
%                         'All Equal Names','First Equal Ancestor','Cancel','Cancel' );
                        button = obj.parent.InfoCenter.MSG('q',1,'');                           
                        
                        switch button
                            case 'All Equal Names'
                            %Selektionsregel nach L�schen des Knoten
                            nP = node.getPreviousSibling;
                            nN = node.getNextSibling;
                            if ~isempty( nN )
                                obj.hData.Trees.mtree1.setSelectedNode( nN );
                            elseif ~isempty( nP )
                                obj.hData.Trees.mtree1.setSelectedNode( nP );
                            else
                                obj.hData.Trees.mtree1.setSelectedNode( node.getParent );
                            end 
                            for i = 1:Count 
                                curNode = equalNode{i};
                                % Update TypeProperties after Node Change      
                                obj.UpdateHierarchyChange('delete',curNode)
                                             
                                % "ses-class": delete node object--
                                obj.parent.Ses.deleteNode(curNode);
                                
                                obj.hData.Trees.TreeModels.tm1.removeNodeFromParent( curNode );
                                obj.parent.Props.UpdatePropertyWindow %kann vllt raus aus der Schleife
                            end
                            % --Update Selection Constraints according to a tree change 
                            obj.parent.Settings.UpdateSelConAfterTreeChange( 'Others' )
                            obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged')
                                            
                            case 'First Equal Ancestor'
                            %finde ersten Vater im Pfad der doppelt auftritt
                            Count = 2;
                            while Count > 1
                                parentNode = node.getParent;
                                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                                [ Count ] = obj.nameExist( obj.getName(parentNode), allNodes );
                                if Count >1
                                    node = parentNode;
                                end
                            end
                            % Update TypeProperties after Node Change      
                            obj.UpdateHierarchyChange('delete',node)
                                      
                            % "ses-class": delete node object--
                            obj.parent.Ses.deleteNode(node);
                                            
                            %                Selektionsregel nach L�schen des Knoten
                            nP = node.getPreviousSibling;
                            nN = node.getNextSibling;
                            if ~isempty( nN )
                                obj.hData.Trees.mtree1.setSelectedNode( nN );
                            elseif ~isempty( nP )
                                obj.hData.Trees.mtree1.setSelectedNode( nP );
                            else
                                obj.hData.Trees.mtree1.setSelectedNode( parentNode );
                            end
                            obj.hData.Trees.TreeModels.tm1.removeNodeFromParent( node );
                            % --Update Selection Constraints according to a tree change 
                            obj.parent.Settings.UpdateSelConAfterTreeChange( 'Others' )
                            obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged')
                                     
                            case 'Cancel'
                            %never mind
                        end%switch
                    else %node name exist only one time
%                         button = questdlg('Do you really want to delete the Node including Subnodes?','Warning!',...
%                         'Yes','Cancel','Yes' );
                        button = obj.parent.InfoCenter.MSG('q',2,'');
                        
                        if strcmp(button,'Yes')
                            % Update TypeProperties after Node Change      
                            obj.UpdateHierarchyChange('delete',node)
                            
                            %Selektionsregel nach L�schen des Knoten
                            nP = node.getPreviousSibling;
                            nN = node.getNextSibling;
                            if ~isempty( nN )
                                obj.hData.Trees.mtree1.setSelectedNode( nN );
                            elseif ~isempty( nP )
                                obj.hData.Trees.mtree1.setSelectedNode( nP );
                            else
                                obj.hData.Trees.mtree1.setSelectedNode( node.getParent );
                            end          
                            % "ses-class": delete node object--
                            obj.parent.Ses.deleteNode(node);
                                      
                            obj.hData.Trees.TreeModels.tm1.removeNodeFromParent( node );
                            % --Update Selection Constraints according to a tree change 
                            obj.parent.Settings.UpdateSelConAfterTreeChange( 'Others' )
                            obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged')
                                       
                        end          
                    end 
                    %check if all descissions are made, if not color icon red-
                    allNodes = values(obj.parent.Ses.nodes);
                    obj.validateDescissionNodes(allNodes);
                            
                end 
            end
            
        end%function delete selected node  
        
        %% Renaming Node       
        function renameNode(obj)            
            %used Variables
            
            futureName = get(obj.hData.hb5,'String');      % 5.) Edit rename node 
            selectedName = obj.getName(obj.hData.Trees.selectedNode1);           
            
            % prepare variable that check if futureNames already exist in the tree    
            
            %�berpr�fungsvariable: zuk�nftiger Name bereits mind. einmal vorhanden
            allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
            [ Count ] = obj.nameExist( futureName, allNodes );
            futureNameExist = Count > 0;
            
            %start of the if-elseif-else-end-construct--
            
            if ~isvarname(futureName)
                %errordlg('Desired name is not a valid node name!','Rename Error');  
                obj.parent.InfoCenter.MSG('e',3,'')
            elseif futureNameExist %if futureName already exist
                
                %Function that checks if parent is a MAspect node
                 
                %check if a treenode is equal to the selected node
                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                [ Count,equalNode ] = obj.nameExist( selectedName, allNodes );
                parentisMasp = false;
                for i = 1:Count
                    %check if any equal sel Node has a parent that is maspect 
                    parentNode = equalNode{i}.getParent;
                    if strcmp(obj.parent.Ses.getType(parentNode),'MAspect')
                        parentisMasp = true;
                        break
                    end
                end
                
                %Function that checks if the Axiom "valid Brothers" is broken--
                
                %check if a treenode is equal to the selected node
                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                [ Count,equalNode ] = obj.nameExist( selectedName, allNodes );
                valBroExist = false;
                for i = 1:Count
                    %check if any equal sel Node has a sibling with the futureName
                    Siblings = equalNode{i}.getParent.children;
                    [ Count_sameSibName ] = obj.nameExist( futureName, Siblings );
                    if Count_sameSibName > 0
                        valBroExist = true;
                        break
                    end
                end
                
                %Function that checks if the Axiom "strict Hierarchy" is broken-
                
                %check if a treenode is equal to the selected node
                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                [ Count,equalNode ] = obj.nameExist( selectedName, allNodes );
                strictHierExist = false;
                for i = 1:Count
                    %check if any equal sel Node has an ancestor with the futureName
                    pathRoot2Node = equalNode{i}.pathFromAncestorEnumeration(obj.hData.Trees.root1);
                    [ CountAnc ] = obj.nameExist( futureName, pathRoot2Node );
                    %check if any equal sel Node has an descendant with the futureName
                    pathNode2Leafs = equalNode{i}.depthFirstEnumeration;
                    [ CountDes ] = obj.nameExist( futureName, pathNode2Leafs );
                    if CountAnc + CountDes > 0
                        strictHierExist = true;
                        break
                    end
                end                                               
                
                %Function that checks if Nodetypes are unequal
                
                %find one node that correspond to the futureNode
                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                [ ~,equalNode ] = obj.nameExist( futureName, allNodes );
                IdenticNode = equalNode{1};
                %check if node types between future and present node are equal
                unequalTypes = xor( IdenticNode.getLevel/2 == ...       %different node type
                round(IdenticNode.getLevel/2) , ...
                obj.hData.Trees.selectedNode1.getLevel/2 == ...
                round(obj.hData.Trees.selectedNode1.getLevel/2) ); 
                %exclude selected Name if its the same like futureName
                if strcmp(futureName,selectedName)
                    %never mind
                elseif parentisMasp
                    %errordlg('It is not allowed to replace an Entity node under a Multiple Aspect!','Replace Error');     
                    obj.parent.InfoCenter.MSG('e',4,'');
                elseif ~obj.hData.Trees.selectedNode1.isLeaf
                    %errordlg('Desired name already exist. Only Leaf Nodes are allowed to get existing names!','Replace Error');     
                    obj.parent.InfoCenter.MSG('e',5,'');
                elseif unequalTypes
                    %errordlg('Desired name belongs to a node with a different type!','Replace Error');
                    obj.parent.InfoCenter.MSG('e',6,'');
                elseif valBroExist
                    %errordlg('Replacing the node is not possible, because it stands in conflict with the Axiom "Valid Brothers"!','Replace Error');
                    obj.parent.InfoCenter.MSG('e',7,'');
                elseif strictHierExist
                    %errordlg('Replacing the node is not possible, because it stands in conflict with the Axiom "Strict Hierarchy"!','Replace Error');
                    obj.parent.InfoCenter.MSG('e',8,'');
                else %clone function
%                     button = questdlg('Do you really want to replace the Node?','Warning!',...
%                             'Yes','Cancel','Yes' );
                    button = obj.parent.InfoCenter.MSG('q',3,'');
                            
                        
                    if strcmp(button,'Yes')
                        allNodes = obj.hData.Trees.root1.depthFirstEnumeration;        
                        [ Count,equalNode ] = obj.nameExist( selectedName, allNodes );
                        for i = 1:Count
                            %save children and children�s children of selNode via rekursive Fcn
                            if IdenticNode.getChildCount == 0   %if identicNode has no children
                                SubTree = uitreenode('v0', 'subroot', 'subroot', [], false);
                                SubTree.add(IdenticNode.clone); 
                            else
                                knotcur = uitreenode('v0', 'subroot', 'subroot', [], false);
                                [ SubTree ] = getSubTree( knotcur,IdenticNode );  
                            end%if
                            %define the place where the replaced Node shall be inserted
                            children = equalNode{i}.getParent.children;
                            for l = 1:equalNode{i}.getParent.getChildCount()
                                nextChild = children.nextElement;
                                if strcmp(obj.getName(nextChild),obj.getName(equalNode{i}))
                                    childInsert = l;
                                    break
                                end     
                            end    
                            Clone = SubTree.getFirstChild; %subrootknoten vernachl�ssigen
                            obj.hData.Trees.TreeModels.tm1.insertNodeInto...
                            (Clone,equalNode{i}.getParent,childInsert);        
                            %     obj.hData.Trees.mtree1.setSelectedNode( Clone );    
                            [Path] = obj.parent.Ses.getTreepath(equalNode{i});
                            objNode = obj.parent.Ses.nodes(Path);   
                            firstNode = struct('name',objNode.name,...
                                'type',     objNode.type,...
                                'parent',   objNode.parent);
                            % "ses-class": replace node object--
                            obj.parent.Ses.replaceNode(equalNode{i},IdenticNode);
                            % Clone: der neue bereits geklonte Knoten mit all seinen Kindern und
                            % Kindeskindern mit richtigem Pfad 
                            %> entnommen wird: name, treepath, parent, children
                            % IdenticNode: ein bereits vorhandener identischer Knoten der an
                            % entsprechender Stelle f�r curNode gesetzt werden soll
                            %entnommen wird: type, children, name, parent
                            %equalNode: der zu ersetzende Knoten/zu l�schende Knoten
                            %> entnommen wird: first parent, treepath
                             
                            obj.hData.Trees.TreeModels.tm1.removeNodeFromParent( equalNode{i} );
                            obj.hData.Trees.mtree1.setSelectedNode( Clone );
                            % Update TypeProperties after Node Change      
                            obj.UpdateHierarchyChange('replace',firstNode,Clone)
                                    
                            %refresh the visible type property of the selected node--
                            obj.parent.Props.UpdatePropertyWindow
                             
                            % Update Selection Constraints according to a tree change 
                            obj.parent.Settings.UpdateSelConAfterTreeChange( 'Others' )
                            obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged') %for Updating current SelConWindow
                            
                        end
                        % Update the List of selectable Node for Selection Constraints 
                        % obj.parent.Settings.getListOfSelectableNodes  
                        
                    else %you dont want to replace the node
                        set(obj.hData.hb5,'String',selectedName);      % 5.) Edit rename node 
                    end
                end
                
            else %futureName doesnot exist, so rename every equal presentName
                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
                [ Count,equalNode ] = obj.nameExist( selectedName, allNodes );
                for i = 1:Count
                    % Update TypeProperties after Node Change   
                    obj.UpdateHierarchyChange('rename',equalNode{i},futureName)
                            
                    %RENAME METHODS INPUT OF SES HERE
                    obj.parent.Ses.renameNode(equalNode{i},futureName)
                    
                    obj.setName(equalNode{i},futureName)
                    %update equal Node
                    %        if equalNode{i}.getParent.isRoot
                    %        %treat root different, because reloading will collapse the whole tree    
                    %             obj.hData.Trees.mtree1.collapse(equalNode{i}) 
                    %             obj.hData.Trees.mtree1.expand(equalNode{i}) 
                    if equalNode{i}.isLeaf
                        obj.hData.Trees.mtree1.reloadNode(equalNode{i})
                    else                        
                        jPath = javax.swing.tree.TreePath(equalNode{i}.getPath);
                        if obj.hData.Trees.jtree1.isExpanded(jPath)
                            obj.hData.Trees.mtree1.collapse(equalNode{i}) 
                            obj.hData.Trees.mtree1.expand(equalNode{i}) 
                        else
                            obj.hData.Trees.mtree1.expand(equalNode{i}) 
                            obj.hData.Trees.mtree1.collapse(equalNode{i}) 
                        end                        
                    end                    
                end
                
                % refresh the visible type property of the selected node
                obj.parent.Props.UpdatePropertyWindow
                  
                % Update Selection Constraints according to a tree change 
                obj.parent.Settings.UpdateSelConAfterTreeChange( 'Rename',equalNode{i},selectedName )
                % obj.parent.Settings.UpdateSelConAfterTreeChange( 'Others' )
                obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged')
                  
                % Update the List of selectable Node for Selection Constraints 
                % obj.parent.Settings.getListOfSelectableNodes  
                  
            end %end of the if-elseif-else-end-construct
            
            %check if all descissions are made, if not color icon red
            allNodes = values(obj.parent.Ses.nodes);
            obj.validateDescissionNodes(allNodes);
                      
            %% getSubTree (rekursive)            
            function SubTree = getSubTree(knotcur,rootNode)        
                % falls Vater keine Kinder hat ergibt sich knot1 aus Vater
                if rootNode.getChildCount == 0
                    knotcur.add(rootNode.clone);
                else
                    Children = rootNode.children;
                    ChildNr = rootNode.getChildCount;
                    allChildren = cell(1,ChildNr);
                    for kk = 1:ChildNr
                        allChildren{kk} = Children.nextElement;
                    end
                    knotnew = rootNode.clone;
                    for chnr = 1:ChildNr
                        knotnew = getSubTree( knotnew, allChildren{chnr} );
                    end
                    knotcur.add(knotnew);    
                end
                SubTree = knotcur;
            end%function
            
        end %function rename node    
        
        %% PopUpMenu Change-Type-Function %         
        function popupMenuCallback(obj, ~, ~)    %Type
            val = get(obj.hData.hb7,'Value');  %7.) Popupmenu Type
            selNode = obj.hData.Trees.selectedNode1;
            oldType = obj.parent.Ses.getType(selNode);
            switch oldType
                case 'Aspect'
                oldVal = 2;
                
                case 'Spec'
                oldVal = 3;
                
                case 'MAspect'
                oldVal = 4;
                
                otherwise 
                oldVal = 1;
            end
            
            if val == oldVal %if same selction nothing happens
                return
            end            
            
            % check if parent is MAspect; if so, only one Entity node can exist
            NrofSib = selNode.getChildCount;
            if val == 4 && NrofSib>1 
                %errordlg('You can not change the Type of the Node to MAspect, unless more than one Entity Node exist!','Change-Type-Error');       
                obj.parent.InfoCenter.MSG('e',9,'');
                set(obj.hData.hb7,'Value',oldVal)
                return
%             elseif val == 4 && NrofSib == 1
%                 check if new type is maspect than child must be leaf -> not any more             
%                 if ~selNode.getFirstChild.isLeaf
%                     %errordlg('You can not change the Type of the Node to MAspect, unless the child is not a leaf!','Change-Type-Error');       
%                     obj.parent.InfoCenter.MSG('e',10,'');
%                     set(obj.hData.hb7,'Value',oldVal)
%                     return
%                 end
            end
           
            NodeName = obj.getName(selNode);          
            allNodes = obj.hData.Trees.root1.depthFirstEnumeration;
            [Count, equalNodes] = obj.nameExist(NodeName, allNodes);
            [Treepath] = obj.parent.Ses.getTreepath(equalNodes{1});
            curNode = obj.parent.Ses.nodes(Treepath);
            if sum(strcmp(curNode.type,{'Aspect','Spec','MAspect'})) == 1
%                 choice = questdlg('Pressing OK will delete the Type Properties of the selected Node!','!! Warning !!','OK','Cancel','Cancel');
                choice = obj.parent.InfoCenter.MSG('q',4,'');
                     
            else
                choice = 'OK';
            end
            
            switch choice                
                case 'Cancel'
                L = find(strcmp(curNode.type,get(obj.hData.hb7,'String')));
                set(obj.hData.hb7,'Value',L);  %7.) Popupmenu Type
                
                case 'OK'
                for i = 1:Count 
                    [Treepath] = obj.parent.Ses.getTreepath(equalNodes{i});
                    curNode = obj.parent.Ses.nodes(Treepath); 
                    
                    %if the same type is selected than do nothing          
                    sameSelection = (strcmp(curNode.type,'Aspect')) && (val == 2)||...       
                        (strcmp(curNode.type,'Spec'))   && (val == 3)||...
                        (strcmp(curNode.type,'MAspect'))&& (val == 4);
                    
                    if ~sameSelection          
                        %set the icon
                        switch val
                            case 1
                            iconPath = obj.Default.IconPath('descNR');
                            newNode = node(get(curNode,'name'),...  
                                get(curNode,'treepath'),...
                                get(curNode,'parent'),...
                                get(curNode,'children'));
                            case 2
                            iconPath = obj.Default.IconPath('aspect');
                            newNode = aspect(get(curNode,'name'),...  
                                get(curNode,'treepath'),...
                                get(curNode,'parent'),...
                                get(curNode,'children'),'Aspect');
                            case 3
                            iconPath = obj.Default.IconPath('spec');
                            newNode = spec(get(curNode,'name'),...  
                                get(curNode,'treepath'),...
                                get(curNode,'parent'),...
                                get(curNode,'children'),'Spec');
                            case 4
                            iconPath = obj.Default.IconPath('masp');
                            newNode = maspect(get(curNode,'name'),...  
                                get(curNode,'treepath'),...
                                get(curNode,'parent'),...
                                get(curNode,'children'),'MAspect');
                        end
                        
                        %Update TypeProperties after Node Change                        
                        obj.UpdateHierarchyChange('changeType',curNode,newNode)
                        
                        obj.parent.Ses.nodes(Treepath) = newNode;
                        jImage = java.awt.Toolkit.getDefaultToolkit.createImage(iconPath);
                        equalNodes{i}.setIcon(jImage);
                        obj.hData.Trees.jtree1.treeDidChange();
                        
                        %Update Selection Constraints after Tree Structure changed        
                        obj.parent.Settings.UpdateSelConAfterTreeChange('Others')
                        
                        %Update the List of selectable Node for Selection Constraints 
                        obj.parent.Settings.getListOfSelectableNodes  
                        
                        %Update Selection Constraints Window 
                        obj.parent.Settings.UpdateSelConWindow('TableSelectionChanged')
                        obj.parent.Settings.UpdateSelConWindow('TreeSelectionChanged')   
                        
                        %check if all descissions are made, if not color icon red
                        allNodes = values(obj.parent.Ses.nodes);
                        obj.validateDescissionNodes(allNodes);
                                
                    end%if not same selection
                end%for  
            end%switch
            
            %refresh the visible type property of the selected node
            obj.parent.Props.UpdatePropertyWindow  
            
        end%function   
        
        %% Selection Changed in Tree Callback %
        function nodeSelectedCallback1(obj,~, evt)
            obj.hData.Trees.jtree1.setEnabled(false); 
            
            obj.hData.Trees.selectedNode1 = evt.getCurrentNode();
            obj.UpdateHierarchyWindow();
            
            obj.parent.Props.UpdatePropertyWindow();
            
            %Update Selection Constraints Window 
            obj.parent.Settings.UpdateSelConWindow('TreeSelectionChanged')
            
            %Enable/Disable Merging 
            obj.parent.Menu.enableDisableMerge();
                        
            obj.hData.Trees.jtree1.setEnabled(true);
            pause(0),drawnow limitrate nocallbacks;
            obj.hData.Trees.jtree1.requestFocus();
            
        end %nodeSelectionCbck
        
        %% Update the Hierarchy Window %       
        function UpdateHierarchyWindow(obj)
            node = obj.hData.Trees.selectedNode1;  
            if node.isRoot
                set(obj.hData.hb5,...
                    'Enable',   'off',...    %5.) Edit rename node 
                    'String',   '')       
                set(obj.hData.jhb2,...
                    'Enable',   false)      % 2.) Icon add SibblingNode
                set(obj.hData.jhb3,...
                    'Enable',   false)      % 3.) Icon delete Node
                set(obj.hData.hb7,...
                    'Value',    1,...     %7.) Popupmenu Type
                    'Enable',   'off') 
                
            elseif node.getParent.isRoot
                set(obj.hData.jhb1,...
                    'Enable',   true)       % 1.) Icon add SubNode
                set(obj.hData.jhb2,...
                    'Enable',   false)      % 2.) Icon add SibblingNode
                set(obj.hData.jhb3,...
                    'Enable',   true)       % 3.) Icon delete Node
                NodeName = char(obj.getName(node));
                set(obj.hData.hb5,...
                    'Enable',   'on',...     %1.) Edit rename node 
                    'String',   NodeName)
                
                
                Type = obj.parent.Ses.getType(node);              
                switch Type
                    case 'Aspect'    
                    set(obj.hData.hb7,...   %7.) Popupmenu Type
                        'String',   {' ','Aspect','Spec','MAspect'},...  
                        'Enable',   'on',...
                        'Value',    2)              
                    case 'Spec'
                    set(obj.hData.hb7,...   %7.) Popupmenu Type
                        'String',   {' ','Aspect','Spec','MAspect'},...  
                        'Enable',   'on',...
                        'Value',    3)     
                    case 'MAspect'  
                    set(obj.hData.hb7,...   %7.) Popupmenu Type
                        'String',   {' ','Aspect','Spec','MAspect'},...  
                        'Enable',   'on',...
                        'Value',    4)
                    case 'Entity'                 
                    set(obj.hData.hb7,...   %7.) Popupmenu Type
                        'String',   {' ','Aspect','Spec','MAspect','Entity'},...     
                        'Value',    5,...           
                        'Enable',   'off')            
                    otherwise
                    set(obj.hData.hb7,...   %7.) Popupmenu Type
                        'String',   {' ','Aspect','Spec','MAspect'},...  
                        'Enable',   'on',...
                        'Value',    1)
                end
                
            else
                % check if parent of any equal named selected Node is maspect
                allNodes = obj.hData.Trees.root1.depthFirstEnumeration;        
                [Count, equalNode] = obj.nameExist(obj.getName(node), allNodes);
                parentIsMasp = false;
                for i = 1:Count
                    nextNode = equalNode{i};
                    if strcmp(obj.parent.Ses.getType(nextNode.getParent),'MAspect')
                        parentIsMasp = true;
                    end
                end
                if parentIsMasp
                    %set(obj.hData.jhb1,...
                       % 'Enable',   false)       % 1.) Icon add SubNode 
                     set(obj.hData.jhb1,...
                        'Enable',   true)        % 1.) Icon add SubNode 
                    set(obj.hData.jhb2,...
                        'Enable',   false)       % 2.) Icon add SibblingNode
                    set(obj.hData.jhb3,...
                        'Enable',   true)        % 3.) Icon delete Node#
                    NodeName = char(obj.getName(node));
                    set(obj.hData.hb5,...
                        'Enable',   'on',...     %5.) Edit rename node
                        'String',   NodeName) 
                    set(obj.hData.hb7,...        %7.) Popupmenu Type
                        'String',   {' ','Aspect','Spec','MAspect','Entity'},...     
                        'Value',    5,...           
                        'Enable',   'off')            
                else
                    % check if selected Node is MAspect than disable addSubnode if childCount == 1    
                    if strcmp(obj.parent.Ses.getType(node),'MAspect') && node.getChildCount == 1
                        set(obj.hData.jhb1,...
                            'Enable',   false)       % 1.) Icon add SubNode 
                    else
                        set(obj.hData.jhb1,...
                            'Enable',   true)        % 1.) Icon add SubNode 
                    end 
                    set(obj.hData.jhb2,...
                        'Enable',   true)       % 2.) Icon add SibblingNode
                    set(obj.hData.jhb3,...
                        'Enable',   true)       % 3.) Icon delete Node#
                    NodeName = char(obj.getName(node));
                    set(obj.hData.hb5,...
                        'Enable',   'on',...     %5.) Edit rename node
                        'String'    ,NodeName) 
                    
                    Type = obj.parent.Ses.getType(node);              
                    switch Type
                        case 'Aspect'    
                        set(obj.hData.hb7,...   %7.) Popupmenu Type
                            'String',   {' ','Aspect','Spec','MAspect'},...  
                            'Enable',   'on',...
                            'Value',    2)              
                        case 'Spec'
                        set(obj.hData.hb7,...   %7.) Popupmenu Type
                            'String',   {' ','Aspect','Spec','MAspect'},...  
                            'Enable',   'on',...
                            'Value',    3)     
                        case 'MAspect'  
                        set(obj.hData.hb7,...   %7.) Popupmenu Type
                            'String',   {' ','Aspect','Spec','MAspect'},...  
                            'Enable',   'on',...
                            'Value',    4)
                        case 'Entity'                 
                        set(obj.hData.hb7,...   %7.) Popupmenu Type
                            'String',   {' ','Aspect','Spec','MAspect','Entity'},...     
                            'Value',    5,...           
                            'Enable',   'off')            
                        otherwise
                        set(obj.hData.hb7,...   %7.) Popupmenu Type
                            'String',   {' ','Aspect','Spec','MAspect'},...  
                            'Enable',   'on',...
                            'Value',    1)
                    end              
                end                  
            end
            
        end %UpdateHierarchy
        
        %% Update SES after Hierarchy has changed %
        function UpdateHierarchyChange(obj,event,firstNode,secondNode)
            if strcmp(event,'delete')
                %Meaning of variables:
                %firstNode -> Node that will be deleted
                %secondNode -> not important for delete-event
                nodeType = obj.parent.Ses.getType(firstNode);
                if ~firstNode.getParent.isRoot
                    parentType = obj.parent.Ses.getType(firstNode.getParent);
                    [Treepath] = obj.parent.Ses.getTreepath(firstNode.getParent);
                    nodeObj = obj.parent.Ses.nodes(Treepath);
                else
                    parentType = 'none';
                end
                if strcmp(nodeType,'Aspect') || strcmp(nodeType,'MAspect')
                    % Delete aspectrule case from (m)aspect siblings 
                    Siblings = firstNode.getParent.children;
                    %find all Aspect Siblings
                    AspSiblings = {};
                    while Siblings.hasMoreElements
                        curSibNode = Siblings.nextElement;
                        %treepath from hierarchyNode
                        [Treepath] = obj.parent.Ses.getTreepath(curSibNode);  
                        Node = obj.parent.Ses.nodes(Treepath);
                        if strcmp(Node.type,'Aspect')||strcmp(Node.type,'MAspect')
                            AspSiblings = [AspSiblings,{Node}];
                        end
                    end
                    if length(AspSiblings) <= 2
                        for i = 1:length(AspSiblings)
                            AspSiblings{i}.aspectrule = cell(1,2);
                        end
                    else
                        for i = 1:length(AspSiblings)
                            SibNode = AspSiblings{i};
                            Data = SibNode.aspectrule;
                            if isempty(Data) %if no data then not dependant
                                %never mind
                            else
                                firstName = char(obj.getName(firstNode));
                                AspNames = Data(:,1);
                                ind = strcmp(firstName,AspNames);
                                Data(ind,:) = [];
                                if isempty(Data)
                                    Data = cell(1,2);
                                end
                                SibNode.aspectrule = Data;
                            end
                        end
                    end
                    
                elseif strcmp(nodeType,'Entity')                    
                    switch parentType                        
                        case 'Aspect'
                            % delete coupling case from parent Aspect 
                            Data = nodeObj.coupling;
                            firstName = char(obj.getName(firstNode));
                            AspNames = [Data(:,1),Data(:,3)];
                            ind1 = strcmp(firstName,AspNames(:,1));
                            ind2 = strcmp(firstName,AspNames(:,2));
                            ind = or(ind1,ind2);
                            Data(ind,:) = [];
                            if isempty(Data)
                                Data = cell(1,4);
                            end
                            nodeObj.coupling = Data;
                            
                        case 'Spec'
                            % delete specrule case from parent Spec 
                            Data = nodeObj.specrule;
                            if ~isstruct(Data)
                                if isempty(Data)     %if no data then not dependant
                                    %never mind
                                else
                                    firstName = char(obj.getName(firstNode));
                                    SpecNames = Data(:,1);
                                    ind = strcmp(firstName,SpecNames);
                                    Data(ind,:) = [];
                                    if isempty(Data)
                                        Data = cell(1,2);
                                    end
                                    nodeObj.specrule = Data;
                                end
                            end
                            
                        case 'MAspect'
                            % delete whole coupling cases  
                            endInt = nodeObj.interval(2);
                            nodeObj.coupling = cell(1,endInt);
                            nodeObj.coupling = cellfun(@(x)cell(1,4),nodeObj.coupling,'UniformOutput',false);
                        otherwise %descriptive
                            %never mind
                    end
                end %if-elseif-end
                %update ses variables Table
                obj.parent.Settings.UpdateSesVariables
                
            elseif strcmp(event,'rename')
                % rename descriptive Node 
                
                %Meaning of variables:
                %firstNode -> Node that holds the old name
                %secondNode -> just the new Name of the Node (String)
                oldNode = firstNode;
                oldName = char(obj.getName(oldNode));
                newName = secondNode;
                level = oldNode.getLevel;
                if level/2 == round(level/2) %descripteve node -> only effect on (m)aspect nodes
                    NodeType = obj.parent.Ses.getType(oldNode);
                    if strcmp(NodeType,'Aspect')||strcmp(NodeType,'MAspect')
                        Siblings = oldNode.getParent.children;
                        %find all Aspect Siblings
                        AspSiblings = {};
                        while Siblings.hasMoreElements
                            curSibNode = Siblings.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curSibNode);  %treepath from hierarchyNode
                            Node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(Node.type,'Aspect')||strcmp(Node.type,'MAspect')
                                AspSiblings = [AspSiblings,{Node}];
                            end
                        end
                        for i = 1:length(AspSiblings)
                            SibNode = AspSiblings{i};
                            Data = SibNode.aspectrule;
                            if isempty(Data)     %if no data then not dependant
                                %never mind
                            else
                                AspNames = Data(:,1);
                                ind = strcmp(oldName,AspNames);
                                Data(ind,1) = {newName};
                                SibNode.aspectrule = Data;
                            end
                        end
                    end
                    
                else %entity node is selected and will be renamed
                    if ~oldNode.getParent.isRoot
                        parentType = obj.parent.Ses.getType(oldNode.getParent);
                        [Treepath] = obj.parent.Ses.getTreepath(oldNode.getParent);
                        nodeObj = obj.parent.Ses.nodes(Treepath);
                        switch parentType
                            case 'Aspect'
                                Data = nodeObj.coupling;
                                if ~ischar(Data)% ignoriere SES Functionen
                                    firstName = char(obj.getName(firstNode));
                                    AspNames = [Data(:,1),Data(:,3)];
                                    ind1 = strcmp(firstName,AspNames(:,1));
                                    ind2 = strcmp(firstName,AspNames(:,2));
                                    Data(ind1,1) = {newName};
                                    Data(ind2,3) = {newName};
                                    nodeObj.coupling = Data;
                                end
                            case 'Spec'
                                Data = nodeObj.specrule;
                                if ~isstruct(Data)
                                    if isempty(Data) %if no data then not dependant
                                        %never mind
                                    else
                                        SpecNames = Data(:,1);
                                        ind = strcmp(oldName,SpecNames);
                                        Data(ind,1) = {newName};
                                        nodeObj.specrule = Data;
                                    end
                                end
                            case 'MAspect'
                                for i = 1:length(nodeObj.coupling)
                                    %length of the nr that stands in the end of name
                                    LNri = length(i); 
                                    if ~ischar(nodeObj.coupling) %skip this Part for SES funktions
                                        Data = nodeObj.coupling{i};
                                        Data(cellfun(@isempty,Data)) = {'  '};
                                        Datarow1 = cellfun(@(x)x(1:end-(LNri+1)),Data(:,1),'UniformOutput',false);
                                        Datarow3 = cellfun(@(x)x(1:end-(LNri+1)),Data(:,3),'UniformOutput',false);
                                        firstName = char(obj.getName(firstNode));
                                        AspNames = [Datarow1,Datarow3];
                                        ind1 = strcmp(firstName,AspNames(:,1));
                                        ind2 = strcmp(firstName,AspNames(:,2));
                                        lastCharrow1 = cellfun(@(x)x(end-LNri:end),Data(:,1),'UniformOutput',false);
                                        lastCharrow3 = cellfun(@(x)x(end-LNri:end),Data(:,3),'UniformOutput',false);
                                        DataRow1 = cellfun(@(x)[newName,x],lastCharrow1,'UniformOutput',false);
                                        Data(ind1,1) = DataRow1(ind1);
                                        DataRow3 = cellfun(@(x)[newName,x],lastCharrow3,'UniformOutput',false);
                                        Data(ind2,3) = DataRow3(ind2);
                                        nodeObj.coupling{i} = Data;
                                    end
                                end
                            otherwise %descriptive
                                %never mind
                        end
                    end
                    %check children whether they are (M)Aspect Nodes
                    %in that case Check Coupling Property if it need a Change
                    Children = oldNode.children;
                    while Children.hasMoreElements
                        nextChild = Children.nextElement;
                        TP = obj.parent.Ses.getTreepath(nextChild);
                        childObjNode = obj.parent.Ses.nodes(TP);
                        if strcmp(childObjNode.type,'Aspect')
                            Data = childObjNode.coupling;
                            if ~ischar(Data) % ignoriere SES Functionen
                                AspNames = [Data(:,1),Data(:,3)];
                                firstName = char(obj.getName(firstNode));
                                ind1 = strcmp(firstName,AspNames(:,1));
                                ind2 = strcmp(firstName,AspNames(:,2));
                                Data(ind1,1) = {newName};
                                Data(ind2,3) = {newName};
                                childObjNode.coupling = Data;
                            end
                        elseif strcmp(childObjNode.type,'MAspect')
                            if ~ischar(childObjNode.coupling)
                                for i = 1:length(childObjNode.coupling)
                                    Data = childObjNode.coupling{i};                                
                                    AspNames = [Data(:,1),Data(:,3)];
                                    firstName = char(obj.getName(firstNode));
                                    ind1 = strcmp(firstName,AspNames(:,1));
                                    ind2 = strcmp(firstName,AspNames(:,2));
                                    Data(ind1,1) = {newName};
                                    Data(ind2,3) = {newName};
                                    childObjNode.coupling{i} = Data;                                
                                end
                            end
                        end
                    end
                end
                
            elseif strcmp(event,'replace')
                %Meaning of variables:
                %firstNode -> oldNode that will be replaced (objNode)
                %secondNode -> new Node (TreeNode)
                firstName = firstNode.name;
                firstType = firstNode.type;
                secondType = obj.parent.Ses.getType(secondNode);
                secondName = obj.getName(secondNode);
                level = secondNode.getLevel;
                if level/2 == round(level/2) %descriptive node -> only effect on (m)aspect nodes
                    % like change type 
                    % delete aspectrule case from aspect siblings (aspect + maspect) 
                    if strcmp(firstType,'Aspect')||strcmp(firstType,'MAspect')
                        Siblings = secondNode.getParent.children; %!!!
                        %find all Aspect Siblings
                        AspSiblings = {};
                        while Siblings.hasMoreElements
                            curSibNode = Siblings.nextElement;
                            
                            %treepath from hierarchyNode
                            [Treepath] = obj.parent.Ses.getTreepath(curSibNode);  
                            Node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(Node.type,'Aspect') || strcmp(Node.type,'MAspect')
                                AspSiblings = [AspSiblings,{Node}];
                            end
                        end
                        if length(AspSiblings) < 2
                            for i = 1:length(AspSiblings)
                                AspSiblings{i}.aspectrule = cell(1,2);
                            end
                        else
                            for i = 1:length(AspSiblings)
                                SibNode = AspSiblings{i};
                                Data = SibNode.aspectrule;
                                if isempty(Data) %if no data then not dependant
                                    %never mind
                                else
                                    AspNames = Data(:,1);
                                    ind = strcmp(firstName,AspNames);
                                    Data(ind,:) = [];
                                    if isempty(Data)
                                        Data = cell(1,2);
                                    end
                                    SibNode.aspectrule = Data;
                                end
                            end
                        end
                    end
                    
                    % add the existing aspectrule cases to the new (m)aspect node 
                    if strcmp(secondType,'Aspect')||strcmp(secondType,'MAspect')
                        Siblings = secondNode.getParent.children; %!!!!!!!!!!!!!!!!!!!
                        %find an Aspect Sibling
                        
                        %unused? AspSiblings = {};
                        while Siblings.hasMoreElements
                            curSibNode = Siblings.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curSibNode);  %treepath from hierarchyNode
                            Node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(Node.type,'Aspect') && ~strcmp(Node.treepath,obj.parent.Ses.getTreepath(secondNode))
                                [secTP] = obj.parent.Ses.getTreepath(secondNode);
                                secNodeObj = obj.parent.Ses.nodes(secTP);
                                secNodeObj.aspectrule = Node.aspectrule;
                                break
                            end
                        end
                    end
                    
                else %replace entity node
                    parentType = obj.parent.Ses.getType(secondNode.getParent);
                    switch parentType
                        case 'Aspect'
                            [Treepath] = obj.parent.Ses.getTreepath(secondNode.getParent);
                            nodeObj = obj.parent.Ses.nodes(Treepath);
                            Data = nodeObj.coupling;
                            AspNames = [Data(:,1),Data(:,3)];
                            ind1 = strcmp(firstName,AspNames(:,1));
                            ind2 = strcmp(firstName,AspNames(:,2));
                            Data(ind1,1) = {secondName};
                            Data(ind2,3) = {secondName};
                            nodeObj.coupling = Data;
                        case 'Spec'
                            [Treepath] = obj.parent.Ses.getTreepath(secondNode.getParent);
                            nodeObj = obj.parent.Ses.nodes(Treepath);
                            Data = nodeObj.specrule;
                            if ~isstruct(Data)
                                Data(cellfun(@isempty,Data)) = [];  %delete empty cell entries
                                if isempty(Data)     %if no data then not dependant
                                    %never mind
                                else
                                    SpecNames = Data(:,1);
                                    ind = strcmp(firstName,SpecNames);
                                    Data(ind,1) = {secondName};
                                    nodeObj.specrule = Data;
                                end
                            end
                        case 'MAspect'
                            [Treepath] = obj.parent.Ses.getTreepath(secondNode.getParent);
                            nodeObj = obj.parent.Ses.nodes(Treepath);
                            for i = 1:length(nodeObj.coupling)
                                Data = nodeObj.coupling{i};
                                Data(cellfun(@isempty,Data)) = {' '};
                                Datarow1 = cellfun(@(x)x(1:end-1),Data(:,1),'UniformOutput',false);
                                Datarow3 = cellfun(@(x)x(1:end-1),Data(:,3),'UniformOutput',false);
                                AspNames = [Datarow1,Datarow3];
                                ind1 = strcmp(firstName,AspNames(:,1));
                                ind2 = strcmp(firstName,AspNames(:,2));
                                lastCharrow1 = cellfun(@(x)x(end),Data(:,1),'UniformOutput',false);
                                lastCharrow3 = cellfun(@(x)x(end),Data(:,3),'UniformOutput',false);
                                DataRow1 = cellfun(@(x)[secondName,x],lastCharrow1,'UniformOutput',false);
                                Data(ind1,1) = DataRow1(ind1);
                                DataRow3 = cellfun(@(x)[secondName,x],lastCharrow3,'UniformOutput',false);
                                Data(ind2,3) = DataRow3(ind2);
                                nodeObj.coupling{i} = Data;
                            end
                        otherwise %descriptive
                            %never mind
                    end
                end
                % Effects on the Entity Nodes considering the Attributes 
                allChildren = secondNode.depthFirstEnumeration;
                while allChildren.hasMoreElements
                    nextChildren = allChildren.nextElement;
                    childLevel = nextChildren.getLevel;
                    if ~(childLevel/2 == round(childLevel/2)) %uneven numbers
                        nextName = obj.getName(nextChildren);
                        [Count, equalNodes] = obj.nameExist(nextName, secondNode.getRoot.depthFirstEnumeration);
                        [TP_newNode] = obj.parent.Ses.getTreepath(nextChildren);
                        for i = 1:Count
                            [Treepath] = obj.parent.Ses.getTreepath(equalNodes{i});
                            if ~strcmp(TP_newNode,Treepath)
                                nodeObj = obj.parent.Ses.nodes(Treepath);
                                data = nodeObj.attributes;
                                Names = data(:,1);
                                Values = cell(length(Names),1);
                                newData = [Names,Values];
                                nodeObj2 = obj.parent.Ses.nodes(TP_newNode);
                                nodeObj2.attributes = newData;
                            end
                        end
                    end
                end
                %update ses variables Table
                obj.parent.Settings.UpdateSesVariables
                
            elseif strcmp(event,'changeType')
                %Meaning of variables:
                %firstNode -> Node with old type ->objNode(oldNode)
                %secondNode -> Node with new type ->objNode(newNode)
                [treenode] = obj.parent.Ses.getTreeNode(firstNode.treepath);
                oldType = firstNode.type;
                newType = secondNode.type;
                % delete aspectrule case from aspect siblings (aspect + maspect) %
                if strcmp(oldType,'Aspect')||strcmp(oldType,'MAspect')
                    % delete only if newType is not (M)Aspect
                    if  ~(strcmp(newType,'Aspect')||strcmp(newType,'MAspect'))
                        treeName = char(obj.getName(treenode));
                        Siblings = treenode.getParent.children;
                        %find all Aspect Siblings
                        AspSiblings = {};
                        while Siblings.hasMoreElements
                            curSibNode = Siblings.nextElement;
                            [Treepath] = obj.parent.Ses.getTreepath(curSibNode);  %treepath from hierarchyNode
                            Node = obj.parent.Ses.nodes(Treepath);
                            if strcmp(Node.type,'Aspect') || strcmp(Node.type,'MAspect')
                                AspSiblings = [AspSiblings,{Node}];
                            end
                        end
                        if length(AspSiblings) <= 2
                            for i = 1:length(AspSiblings)
                                AspSiblings{i}.aspectrule = cell(1,2);
                            end
                        else
                            for i = 1:length(AspSiblings)
                                SibNode = AspSiblings{i};
                                Data = SibNode.aspectrule;
                                if isempty(Data)     %if no data then not dependant
                                    %never mind
                                else
                                    AspNames = Data(:,1);
                                    ind = strcmp(treeName,AspNames);
                                    Data(ind,:) = [];
                                    if isempty(Data)
                                        Data = cell(1,2);
                                    end
                                    SibNode.aspectrule = Data;
                                end
                            end
                        end
                    end
                end
                % add the existing aspectrule cases to the new (m)aspect node 
                if strcmp(newType,'Aspect')||strcmp(newType,'MAspect')
                    Siblings = treenode.getParent.children;
                    %find an Aspect Sibling
                    
                    %unused? AspSiblings = {};
                    while Siblings.hasMoreElements
                        curSibNode = Siblings.nextElement;
                        
                        %treepath from hierarchyNode
                        [Treepath] = obj.parent.Ses.getTreepath(curSibNode); 
                        Node = obj.parent.Ses.nodes(Treepath);
                        if (strcmp(Node.type,'Aspect')||strcmp(Node.type,'MAspect')) && ~strcmp(Node.treepath,firstNode.treepath)
                            secondNode.aspectrule = Node.aspectrule;
                            break
                        end
                    end
                end
                %update ses variables Table
                obj.parent.Settings.UpdateSesVariables                
            end
            
        end%function
        
        %%
        % check if there are uncompleted descission nodes is SES or current PES  
        % flag is 1 -> all descissions are made (no semantic test)
        % flag is 0 -> at least one descission is uncompleted (but pruning is working)
        % flag is-1 -> a descriptive node is a leaf or not specified -> no pruning allowed
        function flag = validateDescissionNodes(obj,allNodes)
            flag = true;
            %             allNodes = values(obj.parent.Ses.nodes);
            %prepare Sinks in Selection Constraints for considering rulecases
            SelConRow2 = obj.parent.Ses.Selection_Constraints.Pathes(:,2);
            SelConRow2(cellfun(@isempty,SelConRow2)) = [];  %delete empty cell entries
            Sinks = {};
            for ii = 1:length(SelConRow2)
                Sinks = [Sinks,SelConRow2{ii}];
            end
            for i = 1:length(allNodes)
                nextNode = allNodes{i};
                switch nextNode.type
                    case 'Spec'
                    NrOfChildren = length(nextNode.children);
                    Rulecases = nextNode.specrule(:,1);
                    Rulecases(cellfun(@isempty,Rulecases)) = [];  %delete empty cell entries
                    NrOfRulecases = length(Rulecases);
                    %consider rulecases via selection constraints
                    %check Spec children are sink
                    [ChildrenPath] = nextNode.getChildrenPath;
                    NrOfRulecases = NrOfRulecases + sum(ismember(ChildrenPath,Sinks));
                    NodeOK = NrOfRulecases == NrOfChildren;
                    if NrOfChildren == 0
                        iconPath = obj.Default.IconPath('specR');
                        flag = -1;
                    elseif NodeOK
                        iconPath = obj.Default.IconPath('spec');
                    else
                        iconPath = obj.Default.IconPath('specY');
                        flag = 0;
                    end
                    jImage = java.awt.Toolkit.getDefaultToolkit.createImage(iconPath);
                    treenode = obj.parent.Ses.getTreeNode(nextNode.treepath);
                    treenode.setIcon(jImage)
                    obj.hData.Trees.jtree1.treeDidChange();
                    
                    case {'Aspect','MAspect'}
                    [ParentPath] = nextNode.getParentPath;
                    ParentNode = obj.parent.Ses.nodes(ParentPath);
                    [ChildrenPath] = ParentNode.getChildrenPath;
                    AspCount = 0;
                    AspSibPath = {};
                    for ii = 1:length(ChildrenPath)
                        childNode = obj.parent.Ses.nodes(ChildrenPath{ii});
                        if strcmp(childNode.type,'Aspect')||strcmp(childNode.type,'MAspect')
                            AspCount = AspCount+1;
                            AspSibPath = [AspSibPath,childNode.treepath];
                        end
                    end
                    %check if Nr of CHildren is zero -> red color
                    NrOfChildren = length(nextNode.children);
                    Rulecases = nextNode.aspectrule(:,1);
                    Rulecases(cellfun(@isempty,Rulecases)) = [];  %delete empty cell entries
                    NrOfRulecases = length(Rulecases);
                    
                    %consider rulecases via selection constraints
                    %check aspect children are sinks
                    NrOfRulecases = NrOfRulecases + sum(ismember(AspSibPath,Sinks));
                    NodeOK = NrOfRulecases == AspCount;
                    if NrOfChildren == 0
                        switch nextNode.type
                            case 'Aspect'
                            iconPath = obj.Default.IconPath('aspectR');
                            case 'MAspect'
                            iconPath = obj.Default.IconPath('maspR');
                        end
                        flag = -1;
                        %elseif there is a descission but not specified
                    elseif ~NodeOK && (AspCount > 1)
                        switch nextNode.type
                            case 'Aspect'
                            iconPath = obj.Default.IconPath('aspectY');
                            case 'MAspect'
                            iconPath = obj.Default.IconPath('maspY'); 
                        end
                    else 
                        switch nextNode.type
                            case 'Aspect'
                            iconPath = obj.Default.IconPath('aspect'); 
                            case 'MAspect'
                            iconPath = obj.Default.IconPath('masp');  
                        end
                        flag = 0;
                    end
                    jImage = java.awt.Toolkit.getDefaultToolkit.createImage(iconPath);
                    treenode = obj.parent.Ses.getTreeNode(nextNode.treepath);
                    treenode.setIcon(jImage)
                    obj.hData.Trees.jtree1.treeDidChange();
                end
            end%for
            
        end%function
        
        %% Expand Icon Callback %        
        function expand(obj)
            selNode = obj.hData.Trees.selectedNode1;
            Node2Leafs = selNode.breadthFirstEnumeration;
            while Node2Leafs.hasMoreElements
                nextNode = Node2Leafs.nextElement;
                obj.hData.Trees.mtree1.expand(nextNode);
            end
        end%function
        
        %% Collapse Icon Callback %        
        function collapse(obj)
            selNode = obj.hData.Trees.selectedNode1;
            Node2Leafs = selNode.depthFirstEnumeration;
            while Node2Leafs.hasMoreElements
                nextNode = Node2Leafs.nextElement;
                obj.hData.Trees.mtree1.collapse(nextNode);
            end
        end%function         
        
        %%
        function TrVwState(obj)
            v_=ver;
            [installedToolboxes{1:length(v_)}] = deal(v_.Name);
            ictInstalled = all(ismember('Instrument Control Toolbox',installedToolboxes));
            obj.hData.TreeViewBtn.setSelected(false);
            if ictInstalled
                import xml_Interface.*
                ses = obj.parent.Ses;
                xDoc = SES2XML_viewer(ses);
                xChar = xmlwrite(xDoc);
                
                %write string to file -> testing
%                 fileID = fopen('send.txt','w');
%                 fprintf(fileID, '%s', xChar);
%                 fclose(fileID);
                
                t = tcpip('127.0.0.1', 54545);
                t.OutputBufferSize = 2*length(xChar);
                try
                    fopen(t);
                    fwrite(t, xChar)
                    fclose(t);
                catch ME
                    msgbox('Please start SESViewEl!', 'No Viewer', 'warn');
                end
                delete(t);
            else
                msgbox('The Matlab Instrument Control Toolbox needs to be installed and licensed.', 'Toolbox Needed', 'warn');
            end
%usage of the built-in viewer
%             TreeViewObj = obj.parent.TreeView;
%             if obj.hData.TreeViewBtn.isSelected
%                 TreeViewObj.ShowFcn();
%             else                
%                 TreeViewObj.HideFcn();
%             end
            
            %obj.hnd.isSelected
            %obj.hnd.setSelected(true)
        end 
        
        %%
        function DbVwState(obj)
            DebugViewObj = obj.parent.DebugView;
            if obj.hData.DebugViewBtn.isSelected
                DebugViewObj.ShowFcn();
            else                
                DebugViewObj.HideFcn();
            end
            
            %obj.hnd.isSelected
            %obj.hnd.setSelected(true)
        end 
    end
end
