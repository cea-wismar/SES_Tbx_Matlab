function cplg = cplgFunCtrlSys(feedforward)

%% initialization of couplings cell-array
cplg = {};

%% fixed couplings
cplg(end+1,:) = {'sourceSys','y','feedbackSys','u1'};
cplg(end+1,:) = {'feedbackSys','y','ctrlPIDSys','u'};
cplg(end+1,:) = {'procUnitSys','y','addDist','u2'};
cplg(end+1,:) = {'addDist','y','feedbackSys','u2'};
cplg(end+1,:) = {'sourceDist','y','tfDist','u'};
cplg(end+1,:) = {'tfDist','y','addDist','u1'};

%% variable couplings
if feedforward == 0
    cplg(end+1,:) = {'ctrlPIDSys','y','procUnitSys','u'};
elseif feedforward == 1
    cplg(end+1,:) = {'sourceDist','y','feedforwardCtrl','u1'};
    cplg(end+1,:) = {'ctrlPIDSys','y','feedforwardCtrl','u2'};
    cplg(end+1,:) = {'feedforwardCtrl','y','procUnitSys','u'};
end
