%% PES2CMDLine(PesName)
%  author:  Birger Freymann
%  version: 19.11.2015 Germany | Wismar University

function pes2cmdline(PesName)
    npes = load(PesName);
    npes = npes.new;

    clc

    for key = npes.nodes.keys
        cMo = npes.nodes(key{:});

        for p = fieldnames(cMo)'        
            fprintf(1,'%10s: ',p{:});        
            if isempty(cMo.(p{:}))
                disp(' ')
            else 
                if iscell(cMo.(p{:}))
                    for i = cMo.(p{:})  
                        fprintf(1,'''%s''  ',i{:});
                    end
                    disp(' ')
                else
                    disp(cMo.(p{:}))
                end
            end
        end
        disp('-------------------------------------------------')    
    end
end