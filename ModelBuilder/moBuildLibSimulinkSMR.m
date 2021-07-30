function funcs = moBuildLibSimulinkSMR()
% provides pointers to the backend depending functions
% Dymola version

funcs.addComponents = @addComponents;
funcs.addConnections = @addConnections;
funcs.initModel = @initModel;
funcs.saveModel = @saveModel;

end

%-----------------------------------------------------------------------
function [h, systemName] = initModel(opts)
% initializes the model
% returns the pointer to the model m-file and the (maybe new) system name
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

% open file and write commands to initialize model
h = fopen(fileName, 'w');
fprintf(h, 'load_system(''simulink'');\n');
fprintf(h, 'h = new_system(''%s'');\n', systemName);
fprintf(h, 'open_system(h);\n');
end

function [systemName] = saveModel(opts)
% builds a Simulink model and saves it as .slx
hSystem = opts.hSystem;
%systemName = opts.systemName;
%fileName = sprintf('Make%s.m', systemName);
fclose(hSystem); % close the m-file
end


function addComponents(opts, objects)
% adds components with their parameters to the model
% Simulink SMR version
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


