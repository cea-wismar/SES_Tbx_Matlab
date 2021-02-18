%% Run this script before starting the toolbox to suppress all Java warnings.

% C. D. 29.01.2021

% find out which warning identifier causes each warning that is displayed
% warning('on','verbose');

warning('off','MATLAB:ui:javacomponent:FunctionToBeRemoved');
warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved');