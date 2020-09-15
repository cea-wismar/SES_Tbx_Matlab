%% pruning_viaAPI.m
% example script for pruning and flattening an SES via API fcn. 

%% complete pruning
%1) load and save SES
load('B10_modelSES.mat'); %LOADS THE SES IN INTERNAL VARIABLE new
mySES = new;
%2) create PES object and transfer SES
myPES = pes(mySES);
%3) complete pruning operation
myPES.prune({{'varVariant',1}});
% myPES.firstLevelPrune({{'varVariant',1}});

   % optional: save PES
   myPES.save('PES_varVariant_is_1.mat')


%% flattening
%1) load and save SES
%load('modelSES.mat');
%mySES = new;
%2) create PES object and transfer SES
myFPES = fpes(mySES);
%3) complete pruning operation
myFPES.prune({{'varVariant',1}});
% myFPES.firstLevelPrune({{'varVariant',1}});
%4) flattening
myFPES.flatten;
   % optional: save FPES
   myFPES.save('FPES_varVariant_is_1.mat')

%5) get Results of FPES
[LeafNodes,Coupling,Parameters,Validity] = myFPES.getResults;


%% testing PES
%get Nodes from PES
%nodes = values(myFPES.nodes);


