function Data = SESMatFiles()
% This function finds all 'SES *.mat files' on Matlab search path including
% current path (without subpathes)
% 
% called with no return value >> SESMatFiles() the results are presented as  
% table otherwise a cell array with is return for each SES found 
% Data = SESMatFiles() %Data = {'File Name','Comment','Full Path'} [n x 3]


Data =  findSESMatFiles;
if nargout == 0
    fig = figure(...
        'Units',            'normalized',...
        'Position',         [.1 .1 .8 .8],...
        'Color',            [1 1 1],...
        'Name',             'SES MAT FILES',...
        'MenuBar',          'none',...
        'ToolBar',          'none',...
        'NumberTitle',      'off');
    
    
    BasicJTable(fig,    ...
        {'File Name','Comment','Path'},...
        'ColumnWidth',  {100 100 1000},...
        'Data',         Data,...
        'Units',        'normalized',...
        'Position',     [0 0 1 1]);
 
    
    clear Data
end
end


function Data = findSESMatFiles

search_path = strsplit(path,';'); % find all pathes
search_path = [search_path,strsplit(genpath(pwd),';')];

search_path = unique(search_path); % remove duplicate entries

Data = cell(100,3);
cnt  = 1;

m_root = matlabroot;
num_mr = numel(m_root);

for k = search_path  
    
    if strncmp(k{:},m_root,num_mr)
        continue %skip file in matlab root
    end  
    
    filelist = dir(k{:});
    
    for l = 3:numel(filelist)
        c_file = [k{:},filesep,filelist(l).name];
        [~,filename,ext] = fileparts(c_file);
        if strcmp(ext,'.mat')
            file = load(c_file);
            if isfield(file,'new') && isa(file.new,'ses')
                Data{cnt,1} = filename; 
                Data{cnt,2}   = char(file.new.comment);
                Data{cnt,3}   = c_file;   
                cnt = cnt + 1;
            end
        end
    end
    Data(cnt+1:end,:) = [];
end
end