function [O_SM]=SimMeth_train(I_SM)

%% variable Parameter
% train_opts

agent = I_SM{1}; 
slEnv = I_SM{2};

train_opts = rlTrainingOptions("MaxStepsPerEpisode",20, ...
    "ScoreAveragingWindowLength",100, ...
    "MaxEpisodes",100, ...
    "StopTrainingCriteria","AverageReward", ...
    "StopTrainingValue",-3);

info = train(agent,slEnv,train_opts);

% avoid shadowing Simulink models
loadedModels = Simulink.allBlockDiagrams('model');
modelNames = get_param(loadedModels,'Name');
close_system(modelNames);

O_SM=[];
