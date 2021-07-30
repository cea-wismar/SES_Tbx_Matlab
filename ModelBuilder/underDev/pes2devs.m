%% ROOTMODEL = PES2DEVS(PES_NAME)
%  author:  Birger Freymann
%  version: 19.11.2015 Germany | Wismar University

% needs MATLAB DEVS Toolbox in order to work

function RM = pes2devs(pes)

% pes = load(PES_Name);           %load PES or FPES
% pes = pes.new;                  %save data to variable 'pes'

keys  = pes.nodes.keys;         %find all key of current container map
cNode = pes.nodes(keys{1});     %find key node - root model

RM = coupled(cNode.name);       %set internal name for root model
recuModelTrans(RM,pes,cNode);   %start recusive model translation
end

function recuModelTrans(RM,pes,cNode)
%RM    - RootModel
%nRM   - next RootModel
%PES   - PrunedEntityStructure
%cNode - current Node
%nNode - next Node

for i = cNode.children
    
    nNode = pes.nodes([cNode.treepath,'/',i{1}]);
    
    if isa(nNode,'aspect')
        
        %Find In- and Output names of Coupled Model using Zid's
        num = sum(strcmp(nNode.coupling,RM.name));
        x = cell(1,num(1));
        y = cell(1,num(3));
        k = 1;
        l = 1;
        
        for j = nNode.coupling'
            if strcmp(j{1},RM.name)
                x(k) = j(2);
                k = k+1;
            end
            if strcmp(j{3},RM.name)
                y(l) = j(4);
                l = l+1;
            end
        end
        
        %replace 'root model name' in coupling(s) with keyword 'parent'
        Zid = nNode.coupling;
        Zid(strcmp(Zid,RM.name)) = {'parent'};        
        
        %use DEVS API to set prepared (extracted) data
        RM.set_x_ports(x); 
        RM.set_y_ports(y);
        RM.set_Zid(Zid);
        
        %continue with: 
        % nNode -> cNode             
        recuModelTrans(RM,pes,nNode)
    else %node is entity
        
        isBM = strcmpi(nNode.attributes(:,1),'mb'); %search for keyword 'mb'
        
        if any(isBM(:)) %true if any attribute is keyword 'mb'            
            tmp_attbs = strrep(nNode.attributes','''',''); %rm all "'"
                        
            ClassName  = tmp_attbs{2,isBM};
            ObjName    = nNode.name;          
            
            for j = 1:size(tmp_attbs,2)
                if strcmpi(tmp_attbs{1,j},'mb')
                    continue %donot try to eval mb value - skip
                else
                    try   %try to eval string
                        tmp_attbs{2,j} = eval(tmp_attbs{2,j}); 
                    catch %me
                        %warning(me.message)
                    end
                end                
            end
            
            %collect all Attributes but remove all {mb,MB} fields
            attributes = struct(tmp_attbs{:});
            FiNms = fieldnames(attributes);
            MBNameCombinationFound = FiNms(strcmpi(FiNms,'mb'));
            attributes = rmfield(attributes,MBNameCombinationFound);
            
            %call Constuctor and add to Parent-Coupled-Devs
            DevsModel = feval(ClassName,ObjName,attributes);
            RM.addcomponents({DevsModel});
            
        else %entity defines no 'mb attribute' 
            nRM = coupled(nNode.name); %interpret entity as coupled model
            RM.addcomponents({nRM})       %add coupled model to parent
            
            %continue with: 
            % nNode -> cNode 
            % nRM   -> RM
            recuModelTrans(nRM,pes,nNode)
        end
    end
end
end