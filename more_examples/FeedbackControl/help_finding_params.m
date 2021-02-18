
%find parameters and values




PortParameterNames = fieldnames(get_param(phFrom.Outport,'ObjectParameters'));
PortParameterValue = get_param(phFrom.Outport,'SigGenPortName');

for k= 1: size(PortParameterNames)
%disp([PortParameterNames{k},': '])    
PortParameterValue = get_param(phFrom.Outport,PortParameterNames{k});
end

Parentsys = get_param(phFrom.Outport,'Parent');
disp(Parentsys)
pause
ParNames = fieldnames(get_param(Parentsys,'ObjectParameters'));

for k= 1: size(ParNames)
disp([ParNames{k},': '])    
ParNamesValues = get_param(Parentsys,ParNames{k});
if strcmp(ParNamesValues,'Banane')
    ParNames{k}
    disp(ParNamesValues)
    pause
end
end


value_to_test='++9'
old=get_param(h','Inputs')
try
set_param(h,'Inputs',value_to_test);
accepted=true;
set_param(h,'Inputs',old);
except
accepted=false;
end

dlgParams = get_param(gcbh, 'DialogParameters');
dlgParams.Gain.Validity
%A struct with all accepted data, like: datatype, complexity, sign
dlgParams.Gain.Validity.Sign
%Returns: {'positive'  'negative'  'zero'}