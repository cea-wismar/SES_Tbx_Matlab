function simresults = build_simulate_feedback_with_outputs(mode)

% this function sets options for model_builder
% preliminary collection of data for the examples
% will be replaced by generic GUI version
% Input Arg for Feedforward SES:
%   mode = 0 | 1 --> without or with feedforward


% general options
mbOpts.backend = 'Simulink';     % or 'SimulinkI'
mbOpts.systemName = 'ctrlSys';
mbOpts.cleanModel = false;        % true (close system & delete files)|false 

% SES options
%mbOpts.ses.file = 'Feedback.mat';
mbOpts.ses.file = 'Feedback_with_outputs.mat';
mbOpts.ses.opts = {'feedforward'};
mbOpts.ses.vals = {mode};

% simulation options

mbOpts.sim.solver = 'ode45';
mbOpts.sim.stopTime = 50;
mbOpts.sim.maxStep = 0.1;

% plot Options
%mbOpts.plot.showResults = false;
mbOpts.plot.sizeX = 500;
mbOpts.plot.sizeY = 500;
mbOpts.plot.nPlots = 3;
mbOpts.plot.title = 'Simulation Results';
mbOpts.plot.xLabel = {'t [s]', 't [s]','t [s]'};
mbOpts.plot.yLabel = {'controlled variable','disturbance','setpoint'};

% get results
mbOpts.returnResults = true;

simresults = modelBuilder(mbOpts);
return