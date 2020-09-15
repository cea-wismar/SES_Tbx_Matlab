function experiment_v2_SL(mode)
% this function nearly correlates with ./privat/PJ/modelBuilderGUI_SL.m 
% preliminary collection of data for the examples
% will be replaced by generic GUI version
% Input Arg for SimpleController
%   mode = 1 | 2


% general options
mbOpts.backend = 'SimulinkI';     % or 'Simulink'
mbOpts.systemName = 'SimpleController';
mbOpts.cleanModel = true;        % true (close system & delete files)|false 

% SES options
mbOpts.ses.file = 'VarSubSysSES_v2.mat';
mbOpts.ses.opts = {'VSS_MODE'};
mbOpts.ses.vals = {mode};

% simulation options
mbOpts.sim.solver = 'ode45';
mbOpts.sim.stopTime = 10;
mbOpts.sim.maxStep = 0.1;

% plot Options
mbOpts.plot.sizeX = 500;
mbOpts.plot.sizeY = 400;
mbOpts.plot.nPlots = 1;
mbOpts.plot.title = 'Scope Results Demo2';
mbOpts.plot.xLabel = {'Time [s]'};
mbOpts.plot.yLabel = {'Signal Value'};

modelBuilder(mbOpts);
return
