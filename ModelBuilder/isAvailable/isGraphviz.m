function [gv_inst, version] = isGraphviz()
%check if graphviz is installed and return version
%the graphviz package is needed for using the Auto Layout Tool
%by McMaster Centre for Software Certification
%(see ~/SES_Toolbox/ExtToolboxes/AutoLayout/)   

cmd = 'dot -V'; %use dot command to check for graphiz

[status,cmdout] = system(cmd);

if status %in case of any error (e.g. command not found)
    gv_inst = false;
    version = [];
else %command is successful
    gv_inst = true;
    version = cmdout;
end

end
