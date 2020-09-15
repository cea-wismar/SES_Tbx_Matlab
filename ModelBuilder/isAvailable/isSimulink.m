function [gv_inst, version] = isSimulink()
%check if Simulink is installed and return version

sim_ver = ver('simulink');

gv_inst = size(sim_ver,1) > 0;
version = sim_ver.Version;

end
