function funcs = exUnitLibSimulinkSMR()
% provides pointers to the backend depending functions
funcs.confSystem = @confSystem;
funcs.runSystem = @runSystem;
funcs.tidyUp = @tidyUp;
end


function confSystem(simOpts)
name = simOpts.systemName; % name of a .m
fileName = sprintf('Make%s.m', name);
% open file to append simulation configuration
h = fopen(fileName, 'a');
% write commands
fprintf(h, 'ConfigObj = getActiveConfigSet(''%s'');\n',name);
fprintf(h, 'set_param(ConfigObj,''StopTime'', ''%s'');\n',num2str(simOpts.stopTime));
fprintf(h, 'set_param(ConfigObj,''Solver'', ''%s'');\n',simOpts.solver);
fprintf(h, 'set_param(ConfigObj,''MaxStep'',''%s'');\n',num2str(simOpts.maxStep));
fprintf(h, 'set_param(ConfigObj,''SaveFormat'',''StructureWithTime'');\n');
% close file
fclose(h);
end


function results = runSystem(simOpts)
% runs the system and returns the simulation results
% Simulink SMR version
%h = simOpts.hSystem; 
name = simOpts.systemName; % name of a system coded in a Make-file
cmd = sprintf('Make%s', name);
eval(cmd); % execute m-file to build model --> .slx generated
%simulate the system
results = sim(name);
save_system(name);
close_system(name);
delete([name,'.slx']);
end

function tidyUp(simOpts)
% delete the model
system = simOpts.systemName;
delete(sprintf('Make%s.m', system));
%delete(sprintf('%s.mat', system));
end