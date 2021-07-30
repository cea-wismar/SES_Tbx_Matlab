function simresults = exUnit(simOpts)
% generic execution unit
% OUTPUT ARG:
%   struct  simresults.tout ...time values
%           simresults.yout ...signal values

% get backend functions
switch simOpts.backend
  case 'Dymola'
    simOpts.f = exUnitLibDymola();
  case 'SimulinkSMR'       % creating Matlab script files
    simOpts.f = exUnitLibSimulinkSMR();
  case 'SimulinkSME'       % using Matlab calls directly
    simOpts.f = exUnitLibSimulinkSME();
  case 'OpenModelica'
    simOpts.f = exUnitLibOpenModelica();
  otherwise
    fprintf('\nError: wrong architecture %s\n', simOpts.backend);
    return;
end

% configure model (add simulation parameters)
simOpts.f.confSystem(simOpts);

% run model
simresults = simOpts.f.runSystem(simOpts);

% delete model after execution, if desired
if simOpts.cleanModel
    simOpts.f.tidyUp(simOpts);
end

end