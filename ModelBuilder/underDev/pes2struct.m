%% PES2STRUCT(PesName,ShowAllNodes)
%  author:  Birger Freymann
%  version: 19.11.2015 Germany | Wismar University

function RM = pes2struct(PesName,ShowAllNodes)
    pes = load(PesName);
    pes = pes.new;
    RM = [];

    for key = pes.nodes.keys
        node = pes.nodes(key{:});    

        path = regexp(key{:},'/','split');    
        RM = setfield(RM , path{2:end},'cmp', node);
    end
    
    %if user wish to see structure
    if nargin == 2        
        showMB(RM,-1,'',ShowAllNodes)
    end
end

%% show PES structure
function showMB(RM,lvl,separ,ShowAllNodes)
    num = numel(separ);

    for i = fieldnames(RM)'        
        if strcmp(i{:},'cmp')
            if strcmp(RM.cmp.type,'Entity') || ShowAllNodes%skip some nodes                
                fmt = [blanks(lvl*num) separ];                
                fprintf(1,'%s%s\n',fmt,RM.cmp.name);
                lvl = lvl+1;
            end
        else
            nxtCmps = RM.(i{:});
            showMB(nxtCmps,lvl,'|--',ShowAllNodes)            
        end
    end
end