function simresults=experiment_v3_SL(mode, numsig)
% this function nearly correlates with ./privat/PJ/modelBuilderGUI_SL.m 
% preliminary collection of data for the examples
% will be replaced by generic GUI version
% Input Arg for VarSubSysDynCoup
%   mode   = 1 | 2
%   numsig = 1 | 2 | 3


% general options
mbOpts.backend = 'SimulinkI';     % or 'Simulink'
mbOpts.systemName = 'VarSubSysDynCoup';
mbOpts.cleanModel = false;        % true (close system & delete files)|false 

% SES options
mbOpts.ses.file = 'VarSubSysDynCoupSES_v2.mat'; % without Simulink Scope
mbOpts.ses.opts = {'VSS_MODE', 'NumSignals'};
mbOpts.ses.vals = {mode, numsig};

% simulation options
mbOpts.sim.solver = 'ode45';
mbOpts.sim.stopTime = 10;
mbOpts.sim.maxStep = 0.1;

% plot options
mbOpts.plot.showResults = false;   % true (default) | false

% sim results option
mbOpts.returnResults = true;    % true | false (default)

simresults = modelBuilder(mbOpts); %simresults.tout, simresults.yvales
end
