function cplg = cplgFunPC(numRepTM,numRepGM)

%% initialization of couplings cell-array
cplg = {};

%% parts couplings
for i = 1:numRepTM % couplings for TurningMachines
    cplg(end+1,:) = {'FIFO1',['OUT',num2str(i)],'TurningMachines',['IN',num2str(i)]};
    cplg(end+1,:) = {'TurningMachines',['OUT',num2str(i)], 'FIFO2',['IN',num2str(i)]};
end

for i = 1:numRepGM % couplings for GrindingMachines
    cplg(end+1,:) = {'FIFO4',['OUT',num2str(i)], 'GrindingMachines',['IN',num2str(i)]};
    cplg(end+1,:) = {'GrindingMachines',['OUT',num2str(i)], 'PathCombiner',['IN',num2str(i)]};
end

cplg(end+1,:) = {'FIFO2','OUT1','HardeningFurnace','IN'};
cplg(end+1,:) = {'HardeningFurnace','OUT','FIFO3','IN1'};
cplg(end+1,:) = {'FIFO3','OUT1','TemperingFurnace','IN'};
cplg(end+1,:) = {'TemperingFurnace','OUT','FIFO4','IN1'};
cplg(end+1,:) = {'PathCombiner','OUT','ProcessChain','OUT'};

%% gCode couplings

cplg(end+1,:) = {'ProcessChain','gCodeT','TurningMachines','gCode'};
cplg(end+1,:) = {'ProcessChain','gCodeG','GrindingMachines','gCode'};
cplg(end+1,:) = {'ProcessChain','IN','FIFO1','IN1'};

%% stock couplings
for i = 1:4
    cplg(end+1,:) = {['FIFO',num2str(i)],'stock','MuxStock',['In',num2str(i)]};
end
cplg(end+1,:) = {'MuxStock','Out','ProcessChain','stock'};

%% load couplings
for i = 1:numRepTM % couplings for TurningMachines
    cplg(end+1,:) = {'TurningMachines',['load',num2str(i)],'MuxLoad',['In',num2str(i)]};
end

for i = 1:numRepGM % couplings for GrindingMachines
    cplg(end+1,:) = {'GrindingMachines',['load',num2str(i)],'MuxLoad',['In',num2str(i+numRepTM)]};
end

cplg(end+1,:) = {'HardeningFurnace','load','MuxLoad',['In',num2str(numRepTM+numRepGM+1)]};
cplg(end+1,:) = {'TemperingFurnace','load','MuxLoad',['In',num2str(numRepTM+numRepGM+2)]};
cplg(end+1,:) = {'MuxLoad','Out','ProcessChain','load'};

%% utilization couplings
for i = 1:numRepTM % couplings for TurningMachines
    cplg(end+1,:) = {'TurningMachines',['util',num2str(i)],'MuxUtilization',['In',num2str(i)]};
end

for i = 1:numRepGM % couplings for GrindingMachines
    cplg(end+1,:) = {'GrindingMachines',['util',num2str(i)],'MuxUtilization',['In',num2str(i+numRepTM)]};
end

cplg(end+1,:) = {'HardeningFurnace','util','MuxUtilization',['In',num2str(numRepTM+numRepGM+1)]};
cplg(end+1,:) = {'TemperingFurnace','util','MuxUtilization',['In',num2str(numRepTM+numRepGM+2)]};
cplg(end+1,:) = {'MuxUtilization','Out','ProcessChain','util'};







