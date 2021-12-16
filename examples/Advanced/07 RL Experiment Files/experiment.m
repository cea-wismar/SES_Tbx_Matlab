%experiment file for RL


% modus 0 --> train
% modus 1 --> eval

clear
learnrate = 0.005;

for modus = 0:1
%%% SES options %%%
sesOpts.file = 'Experiment_Simple_SES.mat';
sesOpts.opts = {'mode','rate'}; % names of SES vars
sesOpts.vals = {modus,learnrate};  % values of SES vars
%%% END SES options %%%

%%% Options for model builder %%%
mbOpts.backend = 'Files';     % just put files into a folder
mbOpts.systemName = 'RL';
%%% END options for model builder %%%


PES = ecGeneralprune(sesOpts);

FPES = ecGeneralflatten(PES);

[components,couplings] = ecGeneralprepare(FPES);

% call model builder
[Sim_modelName] = moBuild(mbOpts,components,couplings);

%%% Options for execution unit %%%
simOpts.backend = mbOpts.backend;
simOpts.systemName = '';
simOpts.cleanModel = false; % keep or delete models after execution false | true
if modus == 0
    startfile = ['ExMeth_','train','(input)'];
    simOpts.input = learnrate; 
else
    startfile = ['ExMeth_','eval','(input)'];
    simOpts.input = simresults;
end
simOpts.solver = startfile; % solver is function/script to start with in folder
%%% END options for execution unit %%%

% transfer model name
simOpts.systemName = Sim_modelName;

% call execution unit and get results
simresults = exUnit(simOpts);

end