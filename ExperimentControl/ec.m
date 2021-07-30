function [mode, k, Ti] = ec(percent_overshoot,max_settl_time)

% CALL [mode,k, Ti] = ec(5,15)

% Template for Experiment Control (EC)
% input: experiment goals
% output: overall experiment results

% * sets values (SES source file, SES variables, target simulator, solver, ...) 
% * controls pruning, model building and execution,
% * evaluates simulation results.


% Try without a feedforward control:
% feedforward=0 simulate with PID: k=1, Ti=1, Td=0
% feedforward=0 simulate with PID: k=5, Ti=0.5, Td=0
% If the goals are reached with one of these configurations:
% Return PID configuration as overall result
% Else try with a feedforward control:
% feedforward=1 simulate with both PID configurations
% If the goals are reached with one of these configurations:
% Return PID configuration as overall result
% Else return: Goals cannot be reached with these configurations / parameters

% experiment variables
overshoot = percent_overshoot; %  (5 percent) overshoot of controlled variable after disturbance should be smaller than that [percent]
settling_time = max_settl_time; % (15 s) settling time should be shorter than that [s]

modes = [0,1]; % model structure without/with feedforward
ks = [1,5];    % parameters for PID
Tis = [1,0.5];


% SES options
sesOpts.file = 'Feedback_with_outputs_var.mat';
sesOpts.opts = {'feedforward','k_conf','Ti_conf'}; % names of SES vars
% sesOpts.vals = {mode,k,Ti};                      % values of SES vars


%%% Options for model builder %%%
mbOpts.backend = 'SimulinkSME';     % or 'SimulinkSME'
mbOpts.systemName = 'ctrlSys';
%%% END options for model builder %%%


%%% Options for execution unit %%%
simOpts.backend = mbOpts.backend; % could this be something else???
simOpts.systemName = '';
simOpts.cleanModel = false; % keep or delete models after execution false | true
simOpts.solver = 'ode45';
simOpts.stopTime = 50;
simOpts.maxStep = 0.1;
%%% END options for execution unit %%%



%%%%%%%%%%%%%%%%%%%% Start experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%
exp_success=0;

% Vary values of SES variables until success
for st = 1:length(modes)          % for both structure variants
    mode = modes(st);
    for pid = 1 : length(ks)   % for both PID configurations
        k = ks(pid);
        Ti = Tis(pid);
        sesOpts.vals = {mode,k,Ti};
        
        PES = ecGeneralprune(sesOpts);
        
        FPES = ecGeneralflatten(PES);        
        
        [components,couplings] = ecGeneralprepare(FPES);        
       
        
        % call model builder
        [Sim_modelName] = moBuild(mbOpts,components,couplings);
        
        % call model builder
        %[Sim_modelName] = moBuild(mbOpts);
        % for Simulink backend this is just the name

        % transfer model name
        simOpts.systemName = Sim_modelName;
        % call execution unit and get results
        simresults = exUnit(simOpts); % simresults SimulationOutput

        % analyze results
        disp(['analyzing output of mode ', num2str(mode),...
       ' with PID configuration k=', num2str(k),...
        ', Ti=', num2str(Ti), ' , Td=0.']);
        % check for overshoot
        if max(simresults.yout.signals(1).values) >= (max(simresults.yout.signals(2).values)/100*overshoot)  
            disp(['Overshoot! ', num2str(max(simresults.yout.signals(1).values))]);
            ovs = 0;
        else
            ovs = 1; 
        end
        % check for time
        sttl = 0;
        index = find(simresults.yout.time > settling_time);
        % get according values
        settl_values = simresults.yout.signals(1).values(index);
        if max(abs(settl_values)) > 0.001
            disp(['settling time is > than ', num2str(settling_time),' s.']);
            sttl = 0;
        else
        sttl = 1;
        end
        if ovs && sttl
            exp_success = 1;
        end

        disp(['sttl ', num2str(sttl)])
        disp(['ovs ', num2str(ovs)])
        disp(['SUCCESS ', num2str(exp_success)])
        disp(' ')
    
        if exp_success
            return;
        end
    end
end
if ~exp_success
    mode = NaN;
    k = NaN;
    Ti = NaN;
end

end

%%***********************************************************************%%
%%           General functions for EC - DO NOT EDIT                      %%
%%***********************************************************************%%

function newPES = ecGeneralprune(sesOpts)
        % prune with current settings of SES vars
        % load SES -> pruning
        load(sesOpts.file); % results in an SES object in variable 'new'
        newSES = new;       % copy to local variable
        newPES = fpes(newSES); % incarnate (F)PES object; not perfect, but..
        % ... caused by flattening being a class-method of class fpes
        
        % splice cell arrays together
        % there must be a simpler solution ...
        N = length(sesOpts.opts);
        pruneOpts = cell(1,N);
        for I=1:N
            pruneOpts{I} = {sesOpts.opts{I}, sesOpts.vals{I}};
        end
        % end splice
        newPES.prune(pruneOpts);
end
    
function newFPES = ecGeneralflatten(PES)
    newFPES = PES;
    newFPES.flatten;
end

function [objects, couplings] = ecGeneralprepare(FPES)
        % do preprocessing of FPES so moBuild can directly build
        % get model data from FPES
        [leafNodes, couplings, parameters, isValid] = FPES.getResults;
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
       
        % remove NONE elements from list; C.D. 23.09.2020
        valid_objects= struct('name','','mb','','parameters',''); % create the structure to allow concatening
        for k = 1 : length(objects)
            object_name = objects(k).name;
            if ~strcmp(object_name(1:4), 'NONE')                  % just add valid objects
                valid_objects = [valid_objects,objects(k)];
            end
        end  
        
        objects=valid_objects(2:end);                             % remove the first dummy entry
        %%%%%%%%%%%%%% end remove NONE elements from list
end
       
  

