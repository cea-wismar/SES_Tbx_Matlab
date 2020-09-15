function cplg = cplgFunGMs(numRepGM)

%% initialization of couplings cell-array
cplg = {};

for i = 1:numRepGM
    %% parts couplings
    cplg(end+1,:) = {'GrindingMachines',['IN',num2str(i)],['GrindingMachine_',num2str(i)],'IN'};
    cplg(end+1,:) = {['GrindingMachine_',num2str(i)],'OUT','GrindingMachines',['OUT',num2str(i)]};
    
    %% gCode couplings
    cplg(end+1,:) = {'GrindingMachines','gCode',['GrindingMachine_',num2str(i)],'gCode'};
    
    %% load couplings
    cplg(end+1,:) = {['GrindingMachine_',num2str(i)],'load','GrindingMachines',['load',num2str(i)]};
    
    %% utilization couplings
    cplg(end+1,:) = {['GrindingMachine_',num2str(i)],'util','GrindingMachines',['util',num2str(i)]};
end

