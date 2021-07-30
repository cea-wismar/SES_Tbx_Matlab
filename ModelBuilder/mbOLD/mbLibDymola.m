function funcs = mbLibDymola()
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
% Dymola version

h = opts.hSystem;
fprintf(h, 'model %s\n', opts.systemName);

for k=1:length(objects)
  type = objects(k).mb;
  type = strrep(type, '/', '.');  % change separator from '/' to '.'
  blockname = objects(k).name;
  fprintf(h, '  %s %s(', type, blockname);

  % set block parameters          
  parnames = fieldnames(objects(k).parameters);
  parvalues = struct2cell(objects(k).parameters);
  for i = 1:length(parnames)
    value = parvalues{i};
    if value(1) == '['    % change definition of array constant
      value(1) = '{';
      value(end) = '}';
    end
    fprintf(h, '%s=%s', parnames{i}, value);
    if i ~= length(parnames)
      fprintf(h, ','); 
    end
  end

  % close component
  fprintf(h, ');\n');
end
end

function addConnections(opts, conns)
% creates the connections between the model components
% Dymola version

h = opts.hSystem;
systemName = opts.systemName;
fprintf(h, 'equation\n');

for k=1:size(conns,1)
  block1 = conns{k,1};
  port1 = conns{k,2};
  block2 = conns{k,3};
  port2 = conns{k,4};
  
  % change to Dymola port names Inn, Onn
  port1 = strrep(port1, 'P', 'O');
  port2 = strrep(port2, 'P', 'I');
  
  fprintf(h, '  connect(%s.%s, %s.%s);\n', block1, port1, block2, port2);
end

fprintf(h, 'end %s;\n', systemName);
fclose(h);
end

function [t, s] = getPlotData(simOut, opts)
% get time and signal values from simulation output
% Dymola version

% could be done with Dymola's Matlab support, e.g.
% d = dymload('ttt1');
% t1 = dymget(d, 'Time');
% d1 = dymget(d, 'Sig1.y');

name = simOut;
simData = load([name, '.mat']);
names = cellstr(simData.name');

% Zeitwerte
idxT = strncmpi('Time', names, 1000);  % OpenModelica uses 'time'
t = simData.data_2(idxT,:);

% Signal-Werte
for I=1:opts.nPlots
  idxS = strncmp(opts.signals{I}, names, 1000);
  dataInfo = simData.dataInfo(:,idxS);
  datacol=abs(dataInfo(2));
  datasign=sign(dataInfo(2));
  s(I).values = datasign*simData.data_2(datacol,:);
end
end

function [h, systemName] = initModel(opts)
% initializes the model
% returns the pointer to the model and the (maybe new) system name
% Dymola version
%   creates system as Modelica text file

% change system name, if such a system already exists
systemName = opts.systemName;
fileName = strcat(systemName, '.mo');
number = 1;
while exist(fileName, 'file')
  number = number+1;
  fileName = strcat(opts.systemName, num2str(number), '.mo');
  systemName = strcat(opts.systemName, num2str(number));
end

% open file
h = fopen(fileName, 'w');
end

function results = runSystem(name, opts)
% runs the system and returns the simulation results
% Dymola version
sOpts = opts.sim;

% use number of steps instead of max step size
nSteps = ceil(sOpts.stopTime/sOpts.maxStep);

% write Dymola batch file
fid = fopen(strcat(name,'.mos'), 'w');
fprintf(fid, 'cd("%s");\n', pwd);
for I=1:length(sOpts.modelBase)
  fprintf(fid, 'openModel("%s");\n', sOpts.modelBase{I});
end
fprintf(fid, 'openModel("%s.mo");\n', name);
fprintf(fid, 'simulateModel(problem="%s", startTime=0.0, ', name);
fprintf(fid, 'method="%s", numberOfIntervals=%d, ', sOpts.solver, nSteps);
fprintf(fid, 'stopTime=%f, resultFile="%s");\n', sOpts.stopTime, name);
fprintf(fid, 'Modelica.Utilities.System.exit();\n');
fclose(fid);

% run Dymola with script
system(['dymola -nowindow ', name, '.mos']);

% clean up
delete('dsfinal.txt', 'dsin.txt', 'dslog.txt', 'dsmodel.c', 'dymosim');
results = name;    % pointer to data file
end

function tidyUp(opts)
% delete the model
% Dymola/OpenModelica version
system = opts.systemName;
delete(sprintf('%s.mo', system));
delete(sprintf('%s.mos', system));

if strcmp(opts.backend, 'Dymola')
  delete(sprintf('%s.mat', system));
else
  delete(sprintf('%s_res.mat', system));
end
end
