% Peter.Trinkt.Pinke(1).Getraenk = 'Cola' ; 
% Peter.Trinkt.Pinke(2).Getraenk = 'Fanta'; 
% Peter.Trinkt.Nicht(1).Getraenk = 'Cola' ; 
% Peter.Trinkt.Nicht(2).Getraenk = 'Fanta'; 

function create_struct_tree(S) 
var_name = inputname(1); 
assignin('base',var_name,S); 
root = uitreenode('v0', var_name, var_name, [], false); 
uitree('v0', 'Root', root, 'ExpandFcn', @myExpfcn, ... 
   'SelectionChangeFcn', 'disp(''Selection Changed'')'); 



function nodes = myExpfcn(tree, value) 

if evalin('base',sprintf('isstruct([%s])',value)) 
   fnames = evalin('base',sprintf('fieldnames(%s)',value)); 
   for count=1:length(fnames) 
      nodes(count) = uitreenode('v0',[value,'.', fnames{count}], ... 
         fnames{count}, [], false); 
   end 
else 
   nodes = []; 
end 

 
