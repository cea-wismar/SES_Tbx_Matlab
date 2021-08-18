function experiment_v1_SL(mode, numsig)
% this function defines a simple experiment 
% preliminary collection of data for the examples
%
% USES SIMULINK SCOPE !!!
% Input Arg for VarSubSysDynCoup
%   mode   = 1 | 2
%   numsig = 1 | 2 | 3


%%% SES options %%%
sesOpts.file = 'VarSubSysDynCoupSES_v1.mat';   % with Simulink Scope
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
simOpts.cleanModel = false; % keep or delete models after execution false | true
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
simresults = exUnit(simOpts); % simresults are just the times t here, since we have a scope but no Out block in this example 

end
