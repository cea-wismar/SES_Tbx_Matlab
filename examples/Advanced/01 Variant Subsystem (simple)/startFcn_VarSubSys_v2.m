function startFcn_VarSubSys_v2(VSS_MODE)
%% This example shows, how to generate an executable model automatically,
% which is derived by a certain variant in the SES. The basic idea of this
% example is taken from the Simulink examples. You can find further 
% information about it (link from 2015(Feb)02):
% http://de.mathworks.com/help/simulink/examples/variant-subsystems.html
% Input Arg:
%   VSS_MODE = 1 | 2


if nargin() ~= 1 || (VSS_MODE ~= 1 && VSS_MODE ~= 2)
    format compact, disp('Unvalid input arg. Use default VSS_MODE.') 
    VSS_MODE = 1, format loose
end

% set experiment data, start modelbuilder & execute 
experiment_v2_SL(VSS_MODE);

return
