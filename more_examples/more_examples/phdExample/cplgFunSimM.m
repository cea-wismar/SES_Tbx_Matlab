function cplg = cplgFunSimM(EM)

%% initialization of couplings cell-array
cplg = {'SimulationModel'  ,'ap'    ,'ExperimentalFrame','ap';
        'SimulationModel'  ,'f'     ,'ExperimentalFrame','f';
        'SimulationModel'  ,'vct'   ,'ExperimentalFrame','vct';
        'SimulationModel'  ,'vfr1'  ,'ExperimentalFrame','vfr1';
        'SimulationModel'  ,'vfr2'  ,'ExperimentalFrame','vfr2';
        'SimulationModel'  ,'vfr3'  ,'ExperimentalFrame','vfr3';
        'SimulationModel'  ,'vcg'   ,'ExperimentalFrame','vcg';
        'ProcessChain'     ,'OUT'   ,'ExperimentalFrame','IN';
        'ProcessChain'     ,'stock' ,'ExperimentalFrame','stock';
        'ProcessChain'     ,'load'  ,'ExperimentalFrame','load';
        'ProcessChain'     ,'util'  ,'ExperimentalFrame','util';
        'ExperimentalFrame','gCodeT','ProcessChain'     ,'gCodeT';
        'ExperimentalFrame','gCodeG','ProcessChain'     ,'gCodeG';
        'ExperimentalFrame','OUT'   ,'ProcessChain'     ,'IN'};

%% additional couplings
if strcmp(EM,'sc') || strcmp(EM,'sa') 
    % couplings for screening and sensitivity analysis ExperimentalFrame
    cplg(end+1:end+6,:) = {'ExperimentalFrame','procTime','SimulationModel','procTime';
                           'ExperimentalFrame','thrput'  ,'SimulationModel','thrput';
                           'ExperimentalFrame','Espec'   ,'SimulationModel','Espec';
                           'ExperimentalFrame','loadPeak','SimulationModel','loadPeak';
                           'ExperimentalFrame','pcUtil'  ,'SimulationModel','pcUtil';
                           'ExperimentalFrame','pcStock' ,'SimulationModel','pcStock'};
   
elseif strcmp(EM,'opt') 
    % couplings for optimization ExperimentalFrame 
    cplg(end+1,:) = {'ExperimentalFrame','targFV','SimulationModel','targFV'};
    
end
