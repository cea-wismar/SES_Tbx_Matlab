function funcs = mbLibSimulink()
% provides pointers to the backend depending functions
% Dymola version

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
h = opts.hSystem;
for k=1:length(objects)
  type = objects(k).mb;
  blockname = objects(k).name;
  fprintf(h, 'h = add_block(''%s'', ''%s/%s'');\n', ...
                  type, opts.systemName, blockname);
  
  % set block parameters          
  parnames = fieldnames(objects(k).parameters);
  parvalues = struct2cell(objects(k).parameters);
  for i = 1:length(parnames)
    fprintf(h, 'set(h, ''%s'', ''%s'');\n', parnames{i}, parvalues{i});
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
h = opts.hSystem;
systemName = opts.systemName;

for k=1:size(conns,1)
  block1 = conns{k,1};
  port1 = conns{k,2};
  block2 = conns{k,3};
  port2 = conns{k,4};
  
  fromBlock = [systemName, '/', block1];
  toBlock = [systemName, '/', block2];
  fprintf(h, 'phFrom = get_param(''%s'',''PortHandles'');\n', fromBlock);
  fprintf(h, 'phTo = get_param(''%s'',''PortHandles'');\n', toBlock);
  nameFrom = port1;
  nameTo = port2;
  nrFrom = str2double(nameFrom(2:end));
  nrTo = str2double(nameTo(2:end));
  if nameFrom(1) == 'C'
    fprintf(h, 'add_line(''%s'', phFrom.RConn(%d), phTo.LConn(%d));\n', ...
        systemName, nrFrom, nrTo); 
  else
    fprintf(h, 'add_line(''%s'', phFrom.Outport(%d), phTo.Inport(%d));\n', ...
        systemName, nrFrom, nrTo); 
  end
end
end

function [t, s] = getPlotData(simOut, opts)
% get time and signal values from simulation output
% Simulink version
name = simOut;
simData = load([name, '.mat']);
simOut = simData.simOut;
yout = simOut.get('yout');
t = yout.time;
s = yout.signals();
end

function [h, systemName] = initModel(opts)
% initializes the model
% returns the pointer to the model and the (maybe new) system name
% Simulink version
%   creates Matlab script for constructing the Simulink model

% change system name, if such a system already exists
systemName = opts.systemName;
fileName = sprintf('Make%s.m', systemName);
number = 1;
while exist(fileName, 'file')
  number = number+1;
  systemName = sprintf('%s%d', opts.systemName, number);
  fileName = sprintf('Make%s.m', systemName);
end

% open file and initialize model
h = fopen(fileName, 'w');
fprintf(h, 'load_system(''simulink'');\n');
fprintf(h, 'h = new_system(''%s'');\n', systemName);
fprintf(h, 'open_system(h);\n');
end

function results = runSystem(name, opts)
% runs the system and returns the simulation results
% Simulink version
h = opts.hSystem; 
sOpts = opts.sim;

fprintf(h, 'simOut = sim(''%s'',',  name);
fprintf(h, ' ''Solver'', ''%s'',...\n',  sOpts.solver);
fprintf(h, ' ''StopTime'', ''%s'',...\n', num2str(sOpts.stopTime));
fprintf(h, ' ''MaxStep'', ''%s'',...\n', num2str(sOpts.maxStep));
fprintf(h, ' ''SaveFormat'', ''StructureWithTime'');\n');
fprintf(h, 'save(''%s.mat'', ''simOut'')\n', name);
%fprintf(h, 'bdclose\n');                                                  %Birger 05.05.2017
fprintf(h, 'return\n');  % in external version: fprintf(h, 'quit\n');
fclose(h);

% run Matlab with script
% external version ("Python"):
%   cmd = sprintf('matlab -r Make%s', name);
%   system(cmd);
% works here, but is nonsense, since we are in Matlab anyhow. Therefore:
cmd = sprintf('Make%s', name);
eval(cmd);

results = name;    % pointer to data file
end

function tidyUp(opts)
% delete the model
system = opts.systemName;
close_system(system,0)
delete(sprintf('Make%s.m', system));
delete(sprintf('%s.mat', system));
end