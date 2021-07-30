function funcs = mbLibOpenModelica()
% provides pointers to the backend depending functions
% OpenModelica version

% use Dymola versions
funcsDym = mbLibDymola();
funcs.addComponents = funcsDym.addComponents;
funcs.addConnections = funcsDym.addConnections;
funcs.initModel = funcsDym.initModel;
funcs.tidyUp = funcsDym.tidyUp;
funcs.getPlotData = funcsDym.getPlotData;

% use own versions
funcs.runSystem = @runSystem;
end

%-----------------------------------------------------------------------
function results = runSystem(name, opts)
% runs the system and returns the simulation results
% OpenModelica version
sOpts = opts.sim;

% use number of steps instead of max step size
nSteps = ceil(sOpts.stopTime/sOpts.maxStep);

% write OpenModelica batch file
fid = fopen(strcat(name,'.mos'), 'w');
fprintf(fid, 'cd("%s");\n', pwd);
fprintf(fid, 'loadModel(Modelica);\n');
for I=1:length(sOpts.modelBase)
  fprintf(fid, 'loadFile("%s");\n', sOpts.modelBase{I});
end
fprintf(fid, 'loadFile("%s.mo");\n', name);
fprintf(fid, 'simulate(%s, startTime=0.0, ', name);
fprintf(fid, 'method="%s", numberOfIntervals=%d, ', sOpts.solver, nSteps);
fprintf(fid, 'stopTime=%f, fileNamePrefix="%s");\n', sOpts.stopTime, name);
fclose(fid);

% run OpenModelica with script
system(['omc ', name, '.mos']);

% clean up
delete(name, [name, '*.c'],[name, '*.o'], [name, '*.h'], [name, '*.json']);
delete([name, '*.xml'],[name, '*.libs'], [name, '*.makefile']);
delete([name, '*.log']);

results = [name, '_res'];    % pointer to data file
end