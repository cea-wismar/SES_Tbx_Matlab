function build_simulate_feedback(mode)

% this function sets options for model_builder
% preliminary collection of data for the examples
% will be replaced by generic GUI version
% Input Arg for Feedforward SES:
%   mode = 0 | 1 --> without or with feedforward
% without out-ports


% general options
mbOpts.backend = 'Simulink';     % or 'SimulinkI' | 'Dymola' | 'OpenModelica'
mbOpts.systemName = 'ctrlSys';
mbOpts.cleanModel = false;        % true (close system & delete files)|false 

% SES options
mbOpts.ses.file = 'Feedback.mat';
mbOpts.ses.opts = {'feedforward'};
mbOpts.ses.vals = {mode};

% simulation options
mbOpts.sim.solver = 'ode45';
mbOpts.sim.stopTime = 50;
mbOpts.sim.maxStep = 0.1;

mbOpts.plot.showResults = false;

modelBuilder(mbOpts);
return