classdef coupWindow < DefSett
properties
    txtEdit
    parent
    LTxtFld
    RTxtFld
end
    
methods
    function obj = coupWindow()
        obj.parent = ses_tbx.API_GUIHandle();
            
        
        fig = figure(...
            'Name',                 'Coupling Window',...
            'NumberTitle',          'off',...
            'MenuBar',              'None');
        
        VBox = uiextras.VBox(...
            'Parent',               fig,...
            'BackgroundColor',      obj.Color.BG_P,...
            'Spacing',              5,...
            'Padding',              5);               
        BBar = HBttnBar(VBox);  
        
        IconObj = JBttn(BBar.hnd,'cimp','Import coupling from node');
        set(IconObj.hnd,'MouseClickedCallback', @(a,b)obj.GetCouplCurNode);
        
        IconObj = JBttn(BBar.hnd,'cexp','Export ccoupling to node');
        set(IconObj.hnd,'MouseClickedCallback', @(a,b)obj.SetCouplCurNode);
        
        obj.txtEdit = JEdit(VBox,'');     
               
        HBox = uiextras.HBox(...
            'Parent',               VBox,...
            'BackgroundColor',      obj.Color.BG_P,...
            'Spacing',              5,...
            'Padding',              0);  
        
        obj.LTxtFld = JEdit(HBox,'');
        obj.RTxtFld = JEdit(HBox,'');
        IconObj = JBttn(HBox,'repl','replace string with');
        set(IconObj.hnd,'MouseClickedCallback', @(a,b)obj.Replace);
        set(HBox,'Sizes',[-1 -1 30])
                 
        set(VBox,'Sizes',[23 -1 23])
        
    end
    function GetCouplCurNode(obj)
        
        Node = obj.parent.API_NodeGet();
        if isa(Node,'aspect') 
            cp = obj.parent.API_NodeGetData('coupling');   
            cp =cp';
            str =sprintf('''%s'', \t ''%s'', \t ''%s'', \t ''%s''\n',cp{:});
            %set(obj.txtEdit,'String',str)
            obj.txtEdit.jCodePane.setText(str);
        else
            warndlg('Please select a AspectNode first','Selection Warning')
        end
    end
    function SetCouplCurNode(obj)        
        
        Node = obj.parent.API_NodeGet();
        if isa(Node,'aspect') 
            str = char(obj.txtEdit.jCodePane.getText());

            k = strsplit(str,'\n');
            num  = size(k,2);
            cstr = cell(num,4);
            for l = 1:num
                c = strsplit(k{l},',');
                if size(c,2) == 4
                    cstr(l,:) = eval(sprintf('{%s %s %s %s}',c{:}));
                end
            end

            cstr(cellfun('isempty',cstr(:,1)),:)=[];        
            if isempty(cstr)        
                cstr = cell(1,4);
            end      
            obj.parent.API_NodeSetData('coupling',cstr); 
        else
            warndlg('Please select a AspectNode first','Selection Warning')
        end
    end
    function Replace(obj)
        str  = char(obj.txtEdit.jCodePane.getText());        
        lstr = char(obj.LTxtFld.jCodePane.getText());
        rstr = char(obj.RTxtFld.jCodePane.getText());        
        nstr = strrep(str,lstr,rstr);  
        obj.txtEdit.jCodePane.setText(nstr);
    end
end
end

% str = clipboard('paste');
% clipboard('copy',str)

