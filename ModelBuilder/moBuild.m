function [systemName] = moBuild(mbOpts,objects,couplings)
% generic modelbuilder
% OUTPUT ARG: name of system that was created
% INPUT ARGS:
% mbOpts.backend = 'SimulinkSME';     % or 'SimulinkSME'
% mbOpts.systemName = 'ctrlSys';
% objects = struct('name', [ ], 'mb', [ ], 'parameters', [ ]) --> all nodes of FPES;
% couplings: cell array of couplings of FPES

% get backend functions
switch mbOpts.backend
  case 'Dymola'
    mbOpts.f = moBuildLibDymola();
  case 'SimulinkSMR'       % creating Matlab script files
    mbOpts.f = moBuildLibSimulinkSMR();
  case 'SimulinkSME'      % using Matlab calls directly
    mbOpts.f = moBuildLibSimulinkSME();
  case 'OpenModelica'
    mbOpts.f = moBuildLibOpenModelica();
  otherwise
    fprintf('\nError: wrong architecture %s\n', mbOpts.backend);
    return;
end



[hSystem, systemName] = mbOpts.f.initModel(mbOpts);% returns pointer to open system/file and its name
mbOpts.systemName = systemName; % name could have changed due to existing other models
mbOpts.hSystem = hSystem;       % for SimulinkSME this is a handle of an m-file which defines commands to build a model
                                % for Simulink SMR this is a handle of a Simulink model
     

% create a model with name system from list of objects and connections
mbOpts.f.addComponents(mbOpts, objects);
mbOpts.f.addConnections(mbOpts, couplings);

% build model and save it
mbOpts.f.saveModel(mbOpts);
% return model



 end

