% structure and valid values of options for model builder mbOpts

exOpts = struct;

% general options
exOpts.backend = 'Simulink';            % 'Simulink' | 'SimulinkI' | 'Dymola' | 'OpenModelica'
exOpts.systemName = '';                 % char, unique name
exOpts.returnResults = true;            % true | false
exOpts.cleanModel = false;              % true | false

% SES options
exOpts.ses.file = '';                   % name of .mat of SES
exOpts.ses.opts = {}                    % cell array with names of SES variables
exOpts.ses.vals = {}                    % cell array with corresponding values of SES variables

% simulation options
exOpts.sim.solver = 'ode45';            % or other solvers (string)
exOpts.sim.stopTime = 50;               % simulation time (double)
exOpts.sim.maxStep = 0.1;               % step size, if applicable (double)

% plot options
exOpts.plot.sizeX = 500;               % maximum size of x-axis
exOpts.plot.sizeY = 500;               % maximum size of y-axis
exOpts.plot.nPlots = 2;                % number of (sub-)plots --> needs to correspond to available yout-values!
exOpts.plot.title = 'Sim. Results';    % add a title to plot figure
exOpts.plot.xLabel ={'x1', 'x value'}; % labels for x-axis (cell array of char)
exOpts.plot.yLabel ={'y value', 'y2'}; % labels for y-axis (cell array of char)
