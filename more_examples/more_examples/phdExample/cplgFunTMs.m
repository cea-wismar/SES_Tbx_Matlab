function cplg = cplgFunTMs(numRepTM)

%% initialization of couplings cell-array
cplg = {};

for i = 1:numRepTM
    %% parts couplings
    cplg(end+1,:) = {'TurningMachines',['IN',num2str(i)],['TurningMachine_',num2str(i)],'IN'};
    cplg(end+1,:) = {['TurningMachine_',num2str(i)],'OUT','TurningMachines',['OUT',num2str(i)]};
    
    %% gCode couplings
    cplg(end+1,:) = {'TurningMachines','gCode',['TurningMachine_',num2str(i)],'gCode'};
    
    %% load couplings
    cplg(end+1,:) = {['TurningMachine_',num2str(i)],'load','TurningMachines',['load',num2str(i)]};
    
    %% utilization couplings
    cplg(end+1,:) = {['TurningMachine_',num2str(i)],'util','TurningMachines',['util',num2str(i)]};
end
