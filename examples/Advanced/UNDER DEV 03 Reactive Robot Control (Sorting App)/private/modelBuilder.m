function modelBuilder(FPES,InitFun,ResultFun)

global A_Puf B_Puf C_Puf Obj infoObj
[LeafNodes,Coupling,Parameters,Validity] = FPES.getResults;

%% if FPES is Valid
if Validity
    if isempty(InitFun)
        nameSystem = 'mySM';
        load_system('simulink');
        h = new_system(nameSystem);
        open_system(h);
    else
        eval(InitFun);
    end
    
    %% translate FPES in executable Simulink model
    modelTranslator(nameSystem,LeafNodes,Coupling,Parameters)
    disp('#mySM generated & in execution#')
    
    %% model execution
       %set simulation solver diagnostic
       %'Automatic solver parameter selection to 'none'  
       set_param(nameSystem,'SolverPrmCheckMsg','none')
    sim(nameSystem);
    
    %% show simulation results
    if ~isempty(ResultFun)
        eval(ResultFun);
    end
    
    disp('#mySM finished & will be closed#')  
    disp('--> PRESS ANY KEY TO PROCEED.')
    pause
   
    %% close and delete Simulink model
    close_system(nameSystem,1)
    delete(sprintf('%s.slx',nameSystem))
else
    disp('FPES is not valid! Application finished')
end
end
