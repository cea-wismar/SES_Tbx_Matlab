function newPES = ecGeneralprune(sesOpts)
        %prune an SES with current settings of SES vars
        %   general function for EC
        
        % load SES -> pruning
        load(sesOpts.file); % results in an SES object in variable 'new'
        newSES = new;       % copy to local variable
        newPES = fpes(newSES); % incarnate (F)PES object; not perfect, but..
        % ... caused by flattening being a class-method of class fpes
        
        % splice cell arrays together
        % there must be a simpler solution ...
        N = length(sesOpts.opts);
        pruneOpts = cell(1,N);
        for I=1:N
            pruneOpts{I} = {sesOpts.opts{I}, sesOpts.vals{I}};
        end
        % end splice
        newPES.prune(pruneOpts);
end

