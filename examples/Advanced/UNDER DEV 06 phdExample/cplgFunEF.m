function cplg = cplgFunEF(EM)

%% initialization of couplings cell-array
cplg = {'ExperimentalFrame','ap','Generator','ap';
        'ExperimentalFrame','f','Generator','f';
        'ExperimentalFrame','vct','Generator','vct';
        'ExperimentalFrame','vfr1','Generator','vfr1';
        'ExperimentalFrame','vfr2','Generator','vfr2';
        'ExperimentalFrame','vfr3','Generator','vfr3';
        'ExperimentalFrame','vcg','Generator','vcg';
        'Generator','gCodeT','ExperimentalFrame','gCodeT';
        'Generator','gCodeG','ExperimentalFrame','gCodeG';
        'Generator','OUT','ExperimentalFrame','OUT';
        'ExperimentalFrame','stock','Transducer','stock';
        'ExperimentalFrame','load','Transducer','load';
        'ExperimentalFrame','util','Transducer','util';
        'ExperimentalFrame','IN','Transducer','IN'};

%% additional couplings
if strcmp(EM,'sc') || strcmp(EM,'sa') 
    % couplings for screening and sensitivity analysis ExperimentalFrame
    cplg(end+1:end+6,:) = {'Transducer','procTime','ExperimentalFrame','procTime';
                           'Transducer','thrput','ExperimentalFrame','thrput';
                           'Transducer','Espec','ExperimentalFrame','Espec';
                           'Transducer','loadPeak','ExperimentalFrame','loadPeak';
                           'Transducer','pcUtil','ExperimentalFrame','pcUtil';
                           'Transducer','pcStock','ExperimentalFrame','pcStock'};
   
elseif strcmp(EM,'opt') 
    % couplings for optimization ExperimentalFrame 
    cplg(end+1,:) = {'Transducer','targFV','ExperimentalFrame','targFV'};
    
end
