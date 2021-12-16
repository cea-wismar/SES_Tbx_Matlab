function [results]=EM_train(lr)

%% variable Groessen
% Env_Modelname
% Agent_path
% optsQT
% opts
%LearnRate 0.005
LearnRate = lr;
%% Define Environment
obsInfo = rlFiniteSetSpec(0:20);
actInfo = rlFiniteSetSpec(1:5);
Env_Modelname = "SimMod";
Agent_path = "SimMod/EF/Generator/Gen_Agent/RL die chooser";

slEnv = rlSimulinkEnv(Env_Modelname,Agent_path,obsInfo,actInfo);
slEnv.ResetFcn = @randomizeseed;


%% Define Agent
T = rlTable(obsInfo,actInfo);
optsQT = rlRepresentationOptions("LearnRate",LearnRate,"GradientThreshold",10);
QT = rlQValueRepresentation(T,obsInfo,actInfo,optsQT);

opts = rlQAgentOptions("DiscountFactor",1);
agent = rlQAgent(QT,opts);

I_SM={agent, slEnv};


[O_SM]=SimMeth_train(I_SM);

results = {agent, slEnv, O_SM};

end

function simin = randomizeseed(simin)
simin = setVariable(simin,"seed",randi(1e5),"Workspace","targetDice");
end

