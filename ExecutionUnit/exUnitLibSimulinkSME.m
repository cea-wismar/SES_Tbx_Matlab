function funcs = exUnitLibSimulinkSME()
% provides pointers to the backend depending functions
funcs.confSystem = @confSystem;
funcs.runSystem = @runSystem;
funcs.tidyUp = @tidyUp;
end

function confSystem(simOpts)
name = simOpts.systemName; % name of an .slx
h=load_system(name);
ConfigObj = getActiveConfigSet(h);
set_param(ConfigObj,'StopTime', num2str(simOpts.stopTime));
set_param(ConfigObj,'Solver',simOpts.solver);
set_param(ConfigObj,'MaxStep',num2str(simOpts.maxStep));
set_param(ConfigObj,'SaveFormat','StructureWithTime');
save_system(name);
end



function results = runSystem(simOpts)
% runs the system and returns the simulation results
% Simulink version
%h = simOpts.hSystem; 
name = simOpts.systemName; % name of an .slx
results = sim(name);
% results = sim(name, ...
%     'Solver',       simOpts.solver, ...
%     'StopTime',     num2str(simOpts.stopTime), ...
%     'MaxStep',      num2str(simOpts.maxStep), ...
%     'SaveFormat',   'StructureWithTime');
close_system(name);
end


function tidyUp(simOpts)
% delete the model
system = simOpts.systemName;
delete([system,'.slx']);
%delete(sprintf('%s.mat', system));
end