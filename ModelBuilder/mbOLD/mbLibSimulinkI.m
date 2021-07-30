function funcs = mbLibSimulinkI()
% provides pointers to the backend depending functions
% Simulink internal version (using Matlab calls directly)

funcs.addComponents = @addComponents;
funcs.addConnections = @addConnections;
funcs.getPlotData = @getPlotData;
funcs.initModel = @initModel;
funcs.runSystem = @runSystem;
funcs.tidyUp = @tidyUp;
end

%-----------------------------------------------------------------------
function addComponents(opts, objects)
% adds components with their parameters to the model
% Simulink version

for k=1:length(objects)
  type = objects(k).mb;
  blockname = objects(k).name;
  h = add_block(type, sprintf('%s/%s', opts.systemName, blockname));
  
  % set block parameters          
  parnames = fieldnames(objects(k).parameters);
  parvalues = struct2cell(objects(k).parameters);
  for i = 1:length(parnames)
    set(h, parnames{i}, parvalues{i});
  end
end
end

function addConnections(opts, conns)
% creates the connections between the model components
% Simulink version

% Problem: ports are given as numbers in SES, but Simulink hast two lists
%   of numbers for normal ports and entity ports.
% Simple solution: SES names have the form 'PNNN' for normal ports
%   and 'CNNN' for entity ports.

systemName = opts.systemName;

for k=1:size(conns,1)
  block1 = conns{k,1};
  port1 = conns{k,2};
  block2 = conns{k,3};
  port2 = conns{k,4};
  
  fromBlock = [systemName, '/', block1];
  toBlock = [systemName, '/', block2];
  phFrom = get_param(fromBlock,'PortHandles');
  phTo = get_param(toBlock,'PortHandles');
  nameFrom = port1;
  nameTo = port2;

  if nameFrom(1) ~= 'P' && nameFrom(1) ~= 'C'
      nrFrom = str2double(nameFrom(1:end)); %numerical Ports e.g. '1')
      nrTo = str2double(nameTo(1:end));
  else
      nrFrom = str2double(nameFrom(2:end)); %name conventation 'P1'|'C1'
      nrTo = str2double(nameTo(2:end));
  end
  if nameFrom(1) == 'C'
      add_line(systemName, phFrom.RConn(nrFrom), phTo.LConn(nrTo));
  else %for Signal Ports
      add_line(systemName, phFrom.Outport(nrFrom), phTo.Inport(nrTo));
  end
end
end

function [t, s] = getPlotData(simOut, opts)
% get time and signal values from simulation output
% Simulink version

yout = simOut.get('yout');
t = yout.time;
s = yout.signals();
end

function [h, systemName] = initModel(opts)
% initializes the model
% returns the pointer to the model and the (maybe new) system name
% Simulink version
%   creates system directly in a running Simulink process
%   this is simple, since the ModelBuilder is itself running in Matlab
%   in a Python version this will change!

% change system name, if such a system already exists
systemName = opts.systemName;
openPaths = find_system('Type', 'block_diagram');
number = 1;
while ismember(systemName, openPaths)
  number = number+1;
  systemName = strcat(opts.systemName, num2str(number));
end

% start Simulink
load_system('simulink');

% initialize model
h = new_system(systemName);
open_system(h);
end

function results = runSystem(name, opts)
% runs the system and returns the simulation results
% Simulink version
sOpts = opts.sim;
results = sim(name, ...
    'Solver',       sOpts.solver, ...
    'StopTime',     num2str(sOpts.stopTime), ...
    'MaxStep',      num2str(sOpts.maxStep), ...
    'SaveFormat',   'StructureWithTime');
end

function tidyUp(opts)
% delete the model
system = opts.systemName;
close_system(system, 1);
delete(sprintf('%s.slx', system));
end