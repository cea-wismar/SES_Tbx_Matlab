function [gv_inst, version] = isOpenModelica()
%check if OpenModelica is installed and return version

cmd = 'omc -v'; %use dot command to check for graphiz

[status,cmdout] = system(cmd);

if status %in case of any error (e.g. command not found)
    gv_inst = false;
    version = [];
else %command is successful
    gv_inst = true;
    version = cmdout;
end

end
