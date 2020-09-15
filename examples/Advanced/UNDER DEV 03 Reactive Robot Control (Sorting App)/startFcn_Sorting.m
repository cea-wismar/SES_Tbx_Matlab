function startFcn_Sorting
% experiment file executing the control application

disp('### START OF APPLICATION #############################')
disp('# App. runs until A_Puf<=3 & B_Puf<=3 & C_Puf<=3     #')
disp('# stop criteria defined as Sementic Condition in SES #')
disp('######################################################')
disp(' ')

%% load SES, init input SESvars
load SortingSES2.mat %current SES is loaded in variable new
Ses = new;
%instantiate FPES obj and transfer SES
FPes = fpes(Ses);
%instantiate SES Variables
global A_Puf B_Puf C_Puf Obj infoObj
A_Puf = 0; B_Puf = 0; C_Puf = 0; Obj = 0; infoObj = 0;
disp('#SES is loaded, SES input variables are set to:')
disp(['Obj=',num2str(Obj),'; infoObj=',num2str(infoObj),'; A_Puf=',...
   num2str(A_Puf),'; B_Puf=',num2str(B_Puf),'; C_Puf=',num2str(C_Puf),'#'])

%% pruning & flattening
FPes.prune({ {'Obj',Obj},... 
             {'infoObj',infoObj},...
             {'A_Puf',A_Puf},...
             {'B_Puf',B_Puf},...
             {'C_Puf',C_Puf} }); 
FPes.flatten;
disp('#FPES is generated#')
key=input('--> Press S for saving FPES or ANY OTHER KEY TO PROCEED. ','s');
if key=='S'
    FPes.save('SortingFPES2.mat');
    disp('#FPES saved as SortingFPES2.mat#')
end

%% control application runs while FPES is valid 
while FPes.validity
    %generate and execute model
    modelBuilder(FPes,'initFun','resultFun')
    
    disp(' ')
    disp('#Updated SES variables are:#')
    disp(['#Obj=',num2str(Obj),'; infoObj=',num2str(infoObj),...
    '; A_Puf=',num2str(A_Puf),'; B_Puf=',num2str(B_Puf),...
    '; C_Puf=',num2str(C_Puf),'#'])
    
    %pruning
    FPes.prune({ {'Obj',Obj},... 
                 {'infoObj',infoObj},...
                 {'A_Puf',A_Puf},...
                 {'B_Puf',B_Puf},...
                 {'C_Puf',C_Puf} }); 
    %flattening
    FPes.flatten;
    disp(' ')
    disp('### GENERATE NEW MODEL ###')
    disp('#New FPES is generated#')
    str='--> Press S for saving FPES; ANY KEY to PROCEED; Ctrl+C to stop. ';
    key=input(str,'s');
    if key=='S'
        FPes.save('SortingFPES2.mat');
        disp('#FPES saved as SortingFPES2.mat#')
        disp('--> Press any key to proceed.')
        pause
    end
end%while
disp('### END OF APPLICATION ###')
end