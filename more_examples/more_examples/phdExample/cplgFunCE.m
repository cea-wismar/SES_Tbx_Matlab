function cplg = cplgFunCE(EM)

%% initialization of couplings cell-array
cplg = {'ExperimentMethod', 'paramConf', 'SimulationMethod', 'paramConf';
        'SimulationMethod', 'curResults','ExperimentMethod', 'curResults';
        'ExperimentMethod','results',    'ComplexExperiment','results';    
        'SimulationMethod', 'ap',        'SimulationModel',  'ap';
        'SimulationMethod', 'f',         'SimulationModel',  'f';
        'SimulationMethod', 'vct',       'SimulationModel',  'vct';
        'SimulationMethod', 'vfr1',      'SimulationModel',  'vfr1';
        'SimulationMethod', 'vfr2',      'SimulationModel',  'vfr2';
        'SimulationMethod', 'vfr3',      'SimulationModel',  'vfr3';
        'SimulationMethod', 'vcg',       'SimulationModel',  'vcg'};

%% additional couplings
if strcmp(EM,'sc') || strcmp(EM,'sa') 
    % couplings for screening and sensitivity analysis EF
    cplg(end+1:end+6,:) = {'SimulationModel','procTime','SimulationMethod','procTime';
                           'SimulationModel','thrput',  'SimulationMethod','thrput';
                           'SimulationModel','Espec',   'SimulationMethod','Espec';
                           'SimulationModel','loadPeak','SimulationMethod','loadPeak';
                           'SimulationModel','pcUtil',  'SimulationMethod','pcUtil';
                           'SimulationModel','pcStock', 'SimulationMethod','pcStock'};
   
elseif strcmp(EM,'opt') 
    % couplings for optimization EF 
    cplg(end+1,:) = {'SimulationModel','targFV','SimulationMethod','targFV'};
    
end
