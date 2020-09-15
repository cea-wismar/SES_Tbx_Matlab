function startFcn_VarSubSysDynCoup_v1(VSS_MODE, NUM_SIGNALS)
%% This example shows, how to generate an executable model automatically,
% which is derived by a certain variant in the SES. The basic idea of this
% example is taken from the Simulink examples. You can find further 
% information about it (link from 2015(Feb)02):
% http://de.mathworks.com/help/simulink/examples/variant-subsystems.html
%
% USES SIMULINK SCOPE BLOCK
% Input Arg:
%   VSS_MODE = 1 | 2
%   NUM_SIGNALS = 1 | 2 | 3


if nargin() ~= 2 || (VSS_MODE ~= 1 && VSS_MODE ~= 2) || ...
(NUM_SIGNALS ~= 1 && NUM_SIGNALS ~= 2 && NUM_SIGNALS ~= 3)   
    format compact, disp('Unvalid input arg. Use defaults.') 
    VSS_MODE = 1,
    NUM_SIGNALS = 1, format loose
end

% set experiment data, start modelbuilder & execute 
experiment_v1_SL(VSS_MODE, NUM_SIGNALS);

return
