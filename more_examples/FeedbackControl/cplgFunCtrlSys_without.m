function cplg = cplgFunCtrlSys_without(feedforward)

%% initialization of couplings cell-array
cplg = {};

%% fixed couplings 
cplg(end+1,:) = {'sourceSys','P1','feedbackSys','P1'};  % block types Constant (out: y --> P1) and Feedback (in: [u1,u2] --> [P1,P2], out: y --> P1)
cplg(end+1,:) = {'feedbackSys','P1','ctrlPIDSys','P1'};  % block types Feedback and PID (in: u --> P1, out: y --> P1)
cplg(end+1,:) = {'procUnitSys','P1','addDist','P2'};    % block types TransferFunction (in: u --> P1, out: y --> P1) and Add (in: [u1,u2] --> [P1,P2], out: y --> P1)
cplg(end+1,:) = {'addDist','P1','feedbackSys','P2'};    % block types Add and Feedback
cplg(end+1,:) = {'sourceDist','P1','tfDist','P1'};       % block types Step (out: y --> P1) and TransferFunction
cplg(end+1,:) = {'tfDist','P1','addDist','P1'};         % block types TransferFunction and Add

%% fixed couplings for simulation output
%cplg(end+1,:) = {'addDist','P1','addDist_out','P1'}; 
%cplg(end+1,:) = {'sourceSys','P1','sourceSys_out','P1'};
%cplg(end+1,:) = {'sourceDist','P1','sourceDist_out','P1'};

%% variable couplings
if feedforward == 0
    cplg(end+1,:) = {'ctrlPIDSys','P1','procUnitSys','P1'};      % block types PID and TransferFunction
elseif feedforward == 1
    cplg(end+1,:) = {'sourceDist','P1','feedforwardCtrl','P1'}; % block types Constant and 'parent'
    cplg(end+1,:) = {'ctrlPIDSys','P1','feedforwardCtrl','P2'}; % block types PID and 'parent'
    cplg(end+1,:) = {'feedforwardCtrl','P1','procUnitSys','P1'}; % block types 'parent' and TransferFunction
end
