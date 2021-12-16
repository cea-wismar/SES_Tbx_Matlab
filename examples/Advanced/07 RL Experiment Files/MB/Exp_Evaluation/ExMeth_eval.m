function [results]=ExMeth_eval(P_SM)

%% keine variablen Parameter

agent=P_SM{1};
slEnv=P_SM{2};


%% Visualize the trained agent's policy
trainedcritic = getCritic(agent);
visualizeQ(trainedcritic)

I_SM{1} = agent; 
I_SM{2} = slEnv;

[O_SM]=SimMeth_eval(I_SM);

simErg = O_SM;
%Extract the reward/number of steps. Visualize the distribution.

steps = arrayfun(@(x) -sum(x.Reward.Data),simErg);

figure(2)
histogram(steps)
meansteps = mean(steps);
medsteps = median(steps);



results = {meansteps, medsteps};

end


function visualizeQ(critic)
% Get possible observations and actions
o = critic.ObservationInfo.Elements;
a = critic.ActionInfo.Elements;
no = numel(o);
na = numel(a);
% Get Q value for each obs/action
Q = zeros(no,na);
for k = 1:na
    for j = 1:no
        Q(j,k) = getValue(critic,o(j),a(k));
    end
end
% Visualize result
imagesc(Q)
colorbar
xticks(1:na)
xticklabels(a)
yticks(1:no)
yticklabels(o)
xlabel("Action (choice of die)")
ylabel("Observation (target value)")
% Add policy to the plot
[~,idx] = max(Q,[],2);
hold on
plot(idx,1:no,"kx")
hold off
end