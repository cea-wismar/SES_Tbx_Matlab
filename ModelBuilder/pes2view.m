%% PES2VIEW(PES_NAME)
%  author:  Birger Freymann
%  version: 12.10.2015 Germany | Wismar University

%% Release Notes
%  + 

%% ToDo
%  - 

function pes2view(PES_Name)

    if ~nargin
        PES_Name = 'AS_Line_DEVS_PES.mat';
    end

    pes = load(PES_Name);           %load PES or FPES
    pes = pes.new;                  %save back data to variable 'pes' 

    keys  = pes.nodes.keys;         %find all key of current container map
    PNode = pes.nodes(keys{1});     %find key node - root model


    
    PPath = ['PES2VIEW__',PNode.name];
    % {
    load_system('Simulink');
    ns = new_system(PPath);
    open_system(ns); %% vlt. zum Schluss
    %}
    
    %{
    %Collect DATA first ???
    RM = [];
    for key = pes.nodes.keys
        node = pes.nodes(key{:});    

        path = regexp(key{:},'/','split');    
        RM = setfield(RM , path{2:end},'cmp', node);
    end
    %}
    
    recSubSysAdd(pes,PNode,PPath)
end

% PNode - Parent Node
% CNode - Child Node


function recSubSysAdd(pes,PNode,PPath)
Pos = 0;
iniPos = [100   000   300   150];
chcPos = [000   001   000   001] * 200;    

    for i = PNode.children 
        CNode = pes.nodes([PNode.treepath,'/',i{:}]);
                       
        if isa(CNode,'entity')
            CPath = [PPath,'/',i{:}];
            
            SubsHnd = add_block('built-in/Subsystem', CPath);
            Pos = Pos + 1;

            set(SubsHnd,'Position', iniPos + chcPos*Pos)           
        else            
            CPath = PPath;
            disp(CNode.treepath)
            
        end
        recSubSysAdd(pes,CNode,CPath)
    end    
end


%% Example Data - TreePath

% AssemblyLine
% AssemblyLine/ASDec
% AssemblyLine/ASDec/aTra
% AssemblyLine/ASDec/cGen
% AssemblyLine/ASDec/cGen/GenMAs
% AssemblyLine/ASDec/cGen/GenMAs/aGen_1
% AssemblyLine/ASDec/cGen/GenMAs/aGen_2
% AssemblyLine/ASDec/cGen/GenMAs/aGen_3
% AssemblyLine/ASDec/cGen/GenMAs/aGen_4
% AssemblyLine/ASDec/cGen/GenMAs/aGen_5
% AssemblyLine/ASDec/cGen/GenMAs/aGen_6
% AssemblyLine/ASDec/cGen/GenMAs/aGen_7
% AssemblyLine/ASDec/cSR1
% AssemblyLine/ASDec/cSR1/cSR1Dec
% AssemblyLine/ASDec/cSR1/cSR1Dec/aPB1
% AssemblyLine/ASDec/cSR1/cSR1Dec/aPB2
% AssemblyLine/ASDec/cSR2
% AssemblyLine/ASDec/cSR2/cSR2Dec
% AssemblyLine/ASDec/cSR2/cSR2Dec/aPB1
% AssemblyLine/ASDec/cSR2/cSR2Dec/aPB2
% AssemblyLine/ASDec/cSR3
% AssemblyLine/ASDec/cSR3/cSR3Dec
% AssemblyLine/ASDec/cSR3/cSR3Dec/aPB1
% AssemblyLine/ASDec/cSR3/cSR3Dec/aPB2