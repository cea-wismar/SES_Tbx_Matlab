function [O_SM]=SimMeth_eval(I_SM)

%% variable Parameter
% rlsimoptions

agent = I_SM{1}; 
slEnv = I_SM{2};

%% Evaluate the agent
%Run multiple simulations.
rlsimoptions = rlSimulationOptions("MaxSteps",20,"NumSimulations",100);

% Achtung dieser sim-Befehl ist in der RL-Tbx anders als klassisch.
simout = sim(agent,slEnv,rlsimoptions);

% avoid shadowing Simulink models
loadedModels = Simulink.allBlockDiagrams('model');
modelNames = get_param(loadedModels,'Name');
close_system(modelNames);

O_SM=simout;
