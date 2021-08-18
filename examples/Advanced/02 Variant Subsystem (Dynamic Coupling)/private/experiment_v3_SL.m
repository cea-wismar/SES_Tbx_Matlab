function simresults=experiment_v3_SL(mode, numsig)
% this function defines a simple experiment
% it returns simulation result, so evaluation can be done in EC
% USES SIMULINK OUT BLOCK
% Input Arg for VarSubSysDynCoup
%   mode   = 1 | 2
%   numsig = 1 | 2 | 3


%%% SES options %%%
sesOpts.file = 'VarSubSysDynCoupSES_v2.mat';   % with Simulink Out block
sesOpts.opts = {'VSS_MODE', 'NumSignals'};     % names of SES var
sesOpts.vals = {mode, numsig};                 % values of SES var
%%% END SES options %%%

%%% Options for model builder %%%
mbOpts.backend = 'SimulinkSME';     % or 'SimulinkSMR'
mbOpts.systemName = 'VarSubSysDynCoup';
%%% END options for model builder %%%

%%% Options for execution unit %%%
simOpts.backend = mbOpts.backend;
simOpts.systemName = '';
simOpts.cleanModel = true; % keep or delete models after execution false | true
simOpts.solver = 'ode45';
simOpts.stopTime = 10;
simOpts.maxStep = 0.1;
%%% END options for execution unit %%%

%%%%%%%%%%%%%%%%%%%% Start experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%
PES = ecGeneralprune(sesOpts);

FPES = ecGeneralflatten(PES);

[components,couplings] = ecGeneralprepare(FPES);

% call model builder
[Sim_modelName] = moBuild(mbOpts,components,couplings);

% transfer model name
simOpts.systemName = Sim_modelName;

% call execution unit and get results
simresults = exUnit(simOpts); % simresults SimulationOutput  
end
