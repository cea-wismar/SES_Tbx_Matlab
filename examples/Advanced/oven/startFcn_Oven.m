function startFcn_Oven(mf, pc, pp)
%% workaround start function for the example
% Input Arg for oven:
%   mf = 1 | 2      material flow 
%   pc = 1 | 2 | 3  process control
%   pp = 1 | 2 | 3  process physics

if nargin() ~= 3
    format compact, disp('Unvalid input arg. Use defaults:  2 3 3.') 
    mf=2, pc=3, pp=3, format loose
end

% set experiment data, start modelbuilder & execute 
modelBuilderGUI_SL_Oven(mf, pc, pp);

return
