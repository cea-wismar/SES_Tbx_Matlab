function modelBuilderGUI_SL_Oven(mf, pc, pp)
% preliminary collection of data for the examples
% will be replaced by generic GUI version
%
% EXAMPLES: USES SIMULINK, SIMEVENTS & SIMSCAPE BLOCKS
% Input Arg for oven
%   mf = 1 | 2      material flow 
%   pc = 1 | 2 | 3  process control
%   pp = 1 | 2 | 3  process physics

% general options
mbOpts.backend      = 'Simulink';
mbOpts.systemName   = 'Oven';
mbOpts.cleanModel   = true;        % true | false 

% SES options
mbOpts.ses.file     = 'ovenSES.mat';
mbOpts.ses.opts     = {'mfVariant', 'pcVariant', 'ppVariant'};
mbOpts.ses.vals     = {mf, pc, pp};

% simulation options
mbOpts.sim.solver   = 'ode15s';
mbOpts.sim.stopTime = 1e5;
mbOpts.sim.maxStep  = 1;

% plot Options
mbOpts.plot.sizeX   = 500;
mbOpts.plot.sizeY   = 700;
mbOpts.plot.nPlots  = 4;
mbOpts.plot.title   = 'Oven Results';
mbOpts.plot.xLabel  = {'t [s]', 't [s]', 't [s]', 't [s]'};
mbOpts.plot.yLabel  = {'Pheat [kWh]', 'Eheat [kWh]', 'phase', ...
                      '#entities out'};
modelBuilder(mbOpts);
end
