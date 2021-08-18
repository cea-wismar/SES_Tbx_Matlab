function experiment_v1_SL(mode)
% this function defines a simple experiment 
% preliminary collection of data for the example
%
% USES SIMULINK SCOPE !!!
% Input Arg for SimpleController
%   mode = 1 | 2

%%% SES options %%%
sesOpts.file = 'VarSubSysSES_v1.mat';   % with Simulink Scope
sesOpts.opts = {'VSS_MODE'};            % name of SES var
sesOpts.vals = {mode};                  % value of SES var
%%% END SES options %%%

%%% Options for model builder %%%
mbOpts.backend = 'SimulinkSME';     % or 'SimulinkSMR'
mbOpts.systemName = 'SimpleController';
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
