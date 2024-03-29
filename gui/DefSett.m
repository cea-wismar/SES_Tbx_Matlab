classdef DefSett < handle
    properties
        Font = struct(...                            Fonts:            
            'NameText', '',...                       % -for all text obj
            'Name',     '',...                       % -
            'SizeS',    8,...                        % -
            'SizeM',    10);                         % -
    end
    properties (Constant)
        Color = struct(...                           Colors:
            'BG_P',     [0.7176  0.8118  1.0000],... % -BackGround 1
            'BG_D',     [0.4039  0.4039  0.4039],... % -BackGround 2 [0.7176  0.8118  1.0000]-0.04    
            'FG',       [1.0000  1.0000  1.0000],... % -ForeGround
            'BC',       [0.5000  0.5000  0.5000]);   % -BorderColor
        
        icons = struct(... 
            'Path',     'gui/icons/',... %PATH that contains all icons
            ...    
            'add',      'cell_add.png',...add.png
            'addSib1',  'addSiblingNode.gif',...
            'addSib2',  'addSiblingNode2.gif',...
            'addSubN',  'addSubNode.gif',...
            'aspect',   'aspect.gif',...
            'aspectY',  'aspect_gelb.gif',...
            'aspectD',  'aspect_openDes.gif',...
            'aspectR',  'aspect_rot.gif',...
            'collapse', 'collapse.png',...
            'del',      'cell_del.png',...delete.png
            'del2',     'delete2.png',...
            'delN',     'deleteNode2.gif',...
            'descNR',   'descript_rot.gif',...
            'entity',   'entity.gif',...
            'expand',   'expand.png',...
            'extract',  'extract.gif',...
            'insert',   'insert.gif',...
            'masp',     'maspect.gif',...
            'maspY',    'maspect_gelb.gif',...
            'maspD',    'maspect_openDes.gif',...
            'maspR',    'maspect_rot.gif',...
            'ok',       'ok.png',...
            'f_up',     'file_upload.png',...
            'f_do',     'file_download.png',...
            'f_de',     'file_delete.png',...
            'f_ad',     'file_add.png',...
            'spec',     'spec.gif',...
            'specY',    'spec_gelb.gif',...
            'specR',    'spec_rot.gif',...
            'tree',     'tree.png',...
            'bug',      'bug.png',...
            'help2',    'help.png',...
            ...            
            'LOGO',     'g4990.png',...
            'FLATTEN',  'flattening.png',...
            'MERGING',  'merging.png',...
            'PRUNING',  'pruning.png',...
            'TTSubN',   'ToolTipAddSubNode.png',...
            'TTSibN',   'ToolTipAddSiblingNode.png',...
            'StartPic', 'SES_EDITOR.gif',...
            ...
            'error',    'dlg_error.png',...
            'help',     'dlg_help.png',...
            'quest',    'dlg_quest.png',...
            'warn',     'dlg_warning.png',...
            ...
            'cimp',     'readC.png',...
            'cexp',     'writeC.png',...
            'repl',     'replace.png');
    end 
    
    
    methods
        function obj = DefSett()
            if isunix
                obj.Font.NameText = 'Helvetica';
                obj.Font.Name     = 'Courier New'; 
            else
                obj.Font.NameText = 'MS Sans Serif'; 
                obj.Font.Name     = 'Courier New'; 
            end
        end
        
        function iconpath = IconPath(obj,IconName)
            allowedIconNames = fieldnames(obj.icons);            
            allowedIconNames(1)=[]; % remove Path info
            
            if any(strcmp(IconName,allowedIconNames))
                path = obj.icons.Path;                         
                iconpath = strrep(which([path,obj.icons.(IconName)]),'\','/'); 
            else
                disp(allowedIconNames)
                error('Icon: %s does not exist',IconName)
            end
        end
    end    
end