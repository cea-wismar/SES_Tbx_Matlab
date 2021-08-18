function experiment_v2_SL(mode)
% this function defines a simple experiment 
% preliminary collection of data for the example
%
% USES NO SIMULINK SCOPE BUT OUT-BLOCK
% Input Arg for SimpleController
%   mode = 1 | 2

%%% SES options %%%
sesOpts.file = 'VarSubSysSES_v2.mat';   % without Simulink Scope, but with signal out instead
sesOpts.opts = {'VSS_MODE'};            % name of SES var
sesOpts.vals = {mode};                  % value of SES var
%%% END SES options %%%

%%% Options for model builder %%%
mbOpts.backend = 'SimulinkSMR';     % or 'SimulinkSMR'
mbOpts.systemName = 'SimpleControl';
%%% END options for model builder %%%

%%% Options for execution unit %%%
simOpts.backend = mbOpts.backend;
simOpts.systemName = '';
%simOpts.cleanModel = false; % keep or delete models after execution false | true
simOpts.cleanModel = true; % we get simulation output since we have an out-block
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

% We don't have a scope in this example, but an out-block.
% So we will have to make visible results manually.
%
t = simresults.yout.time;
y = simresults.yout.signals(1).values;

figure
plot(t,y);
title('Scope Results Demo2')
xlabel('Time [s]')
ylabel('Signal Value')

end




