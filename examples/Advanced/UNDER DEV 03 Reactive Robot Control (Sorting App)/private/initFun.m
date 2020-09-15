%Initializing of simulink Model
nameSystem = 'mySM1';
openPathes = find_system('Type','block_diagram');
number = 1;
while ismember(nameSystem,openPathes)
    number = number+1;
    nameSystem = ['mySM',num2str(number)];
end
load_system('simulink');
h = new_system(nameSystem);
open_system(h);
set(h,'Solver','VariableStepDiscrete','StopTime','inf');