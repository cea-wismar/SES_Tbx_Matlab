function experiment_v1_SL(mode, numsig)
% this function nearly correlates with ./privat/PJ/modelBuilderGUI_SL.m 
% preliminary collection of data for the examples
% will be replaced by generic GUI version
%
% USES SIMULINK SCOPE !!!
% Input Arg for VarSubSysDynCoup
%   mode   = 1 | 2
%   numsig = 1 | 2 | 3


% general options
mbOpts.backend = 'SimulinkI';     % or 'Simulink'
mbOpts.systemName = 'VarSubSysDynCoup';
mbOpts.cleanModel = false;        % true (close system & delete files)|false 

% SES options
mbOpts.ses.file = 'VarSubSysDynCoupSES_v1.mat'; % uses Simulink Scope
mbOpts.ses.opts = {'VSS_MODE', 'NumSignals'};
mbOpts.ses.vals = {mode, numsig};

% simulation options
mbOpts.sim.solver = 'ode45';
mbOpts.sim.stopTime = 10;
mbOpts.sim.maxStep = 0.1;

% plot Options
mbOpts.plot.showResults = false;   %true (default) | false

modelBuilder(mbOpts);
end
