function simresults = modelBuilder(mbOpts)
% generic modelbuilder
% OUTPUT ARG:
%   struct  simresults.tout ...time values
%           simresults.yout ...signal values


% get backend functions
switch mbOpts.backend
  case 'Dymola'
    mbOpts.f = mbLibDymola();
  case 'Simulink'       % creating Matlab script files
    mbOpts.f = mbLibSimulink();
  case 'SimulinkI'      % using Matlab calls directly
    mbOpts.f = mbLibSimulinkI();
  case 'OpenModelica'
    mbOpts.f = mbLibOpenModelica();
  otherwise
    fprintf('\nError: wrong architecture %s\n', mbOpts.backend);
    return;
end

[hSystem, systemName] = mbOpts.f.initModel(mbOpts);
mbOpts.systemName = systemName;
mbOpts.hSystem = hSystem;

[objects, couplings] = readSES(mbOpts.ses);

% creates a model with name system from list of objects and connections
mbOpts.f.addComponents(mbOpts, objects);
mbOpts.f.addConnections(mbOpts, couplings);

% run model
simOut = mbOpts.f.runSystem(systemName, mbOpts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%try to find readable layout
if strcmp(mbOpts.backend,{'SimulinkI'}) && ~mbOpts.cleanModel && isGraphviz()
    AutoLayout(systemName);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% show simulation results as plot
if ~isfield(mbOpts.plot,'showResults')
    mbOpts.plot.showResults = true;     % set default
end
if mbOpts.plot.showResults
  plotResults(simOut, mbOpts);
  % case false for using Simulink Scopes 
end

% return simulation results 
if ~isfield(mbOpts,'returnResults')
    mbOpts.returnResults = false;    % set default
    simresults = [];
end
if mbOpts.returnResults
    [tout, yout] = mbOpts.f.getPlotData(simOut, []);
    simresults.tout    = tout;             % time values
    simresults.yvalues = yout.values;      % signal values
end

% tidy up
if mbOpts.cleanModel
  mbOpts.f.tidyUp(mbOpts);
end
end

%------------------------------------------------------------------------
function plotResults(simOut, mbOpts)
% shows simulation results

opts = mbOpts.plot;
[t, s] = mbOpts.f.getPlotData(simOut, opts);
 
N = opts.nPlots;
figure('Position', [1, 1, opts.sizeX, opts.sizeY])

for I=1:N
  subplot(N,1,I)
  plot(t, s(I).values)
  if I==1
    title(opts.title)
  end
  xlabel(opts.xLabel{I})
  ylabel(opts.yLabel{I})
  grid on
end
end

%------------------------------------------------------------------------
function [objects, couplings] = readSES(sesOpts)
% reads components, their parameters and connections from SES

% load SES -> pruning -> flattening
load(sesOpts.file);
newSES = new;
newFPES = fpes(newSES);

% splice cell arrays together
% there must be a simpler solution ...
N = length(sesOpts.opts);
pruneOpts = cell(1,N);
for I=1:N
  pruneOpts{I} = {sesOpts.opts{I}, sesOpts.vals{I}};
end
% end splice

newFPES.prune(pruneOpts)
newFPES.flatten

% get model data from SES
[leafNodes, couplings, parameters, isValid] = newFPES.getResults;
if ~isValid
  disp('FPES is not valid!')
  return
end

% collect each element of Da and Parameters in object
objects = struct('name', [ ], 'mb', [ ], 'parameters', [ ]);
for k=1:length(leafNodes)
  % store name
  objects(k).name = leafNodes{k};
  fieldTemp={ };
  contentTemp={ };
  for l = 1:size(parameters,1)
    if strcmp(parameters{l,1},leafNodes{k})
      switch parameters{l,2}
        % store type
        case 'mb'
          objects(k).mb = eval(parameters{l,3});
        % store parameters
        otherwise
          fieldTemp(end+1) = parameters(l,2);
          val = parameters(l,3);
          % strip extra ''
          if val{1}(1) == ''''        
            val{1} = val{1}(2:end-1);
          end
          contentTemp(end+1) = val;
      end
    end
  end
  objects(k).parameters = cell2struct(contentTemp,fieldTemp,2);
end
end
