function modelTranslator(nameSystem,LeafNodes,Coupling,Parameters)

%% collect each element of Da and Parameters in object
object = struct('name', [ ], 'mb', [ ], 'parameters', [ ]);
for k=1:length(LeafNodes)
    % store name
    object(k).name = LeafNodes{k};
    fieldTemp={ };
    contentTemp={ };
    for l = 1:size(Parameters,1)
        if strcmp(Parameters{l,1},LeafNodes{k})
            switch Parameters{l,2}
                % store type
                case 'mb'
                    object(k).mb = eval(Parameters{l,3});
                % store parameters
                otherwise
                    fieldTemp(end+1) = Parameters(l,2);
                    contentTemp(end+1) = Parameters(l,3);
            end
        end
    end
    object(k).parameters = cell2struct(contentTemp,fieldTemp,2);
end

%% create blocks and transform couplings
for k=1:length(LeafNodes)
    nameBlock=object(k).name;
    % build each model from Simulink model base
    switch object(k).mb 
        
        case 'identification'
             add_block('MB/identification',sprintf('%s/%s',nameSystem,nameBlock));
        case 'pickPart'
            add_block('MB/pickPart',sprintf('%s/%s',nameSystem,nameBlock));
            constValue = object(k).parameters.arg1;
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'Constant'),'Value',constValue,'ShowName','on');
        case 'placePart'
            add_block('MB/placePart',sprintf('%s/%s',nameSystem,nameBlock));
            constValue = object(k).parameters.arg1;
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'Constant'),'Value',constValue,'ShowName','on');
        case 'mux'
            %create block
            add_block('simulink/Commonly Used Blocks/Mux',sprintf('%s/%s',nameSystem,nameBlock));      
        case 'robot'
            add_block('MB/robot',sprintf('%s/%s',nameSystem,nameBlock));
            constValue = object(k).parameters.arg1;
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'Constant'),'Value',constValue,'ShowName','on');
        case 'camera'
            add_block('MB/camera',sprintf('%s/%s',nameSystem,nameBlock));
        case 'puffer'
            add_block('MB/puffer',sprintf('%s/%s',nameSystem,nameBlock));
            constValue = object(k).parameters.arg1;
            pufVal1 = object(k).parameters.Puf1;
            pufVal2 = object(k).parameters.Puf2;
            pufVal3 = object(k).parameters.Puf3;
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'Constant'),'Value',constValue,'ShowName','on');
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'PufCon1'),'Value',pufVal1,'ShowName','on');
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'PufCon2'),'Value',pufVal2,'ShowName','on');
            set_param(sprintf('%s/%s/%s',nameSystem,nameBlock,'PufCon3'),'Value',pufVal3,'ShowName','on');
        case 'transducer'
            add_block('MB/transducer',sprintf('%s/%s',nameSystem,nameBlock));
        case 'acc_identify'
            add_block('MB/acc_identify',sprintf('%s/%s',nameSystem,nameBlock));
        case 'acc_sorting'
            add_block('MB/acc_sorting',sprintf('%s/%s',nameSystem,nameBlock));
   
        otherwise
            
    end
end

%% create couplings based on Simulink Syntax
for k=1:size(Coupling,1)
    fromBlock=sprintf('%s/%s', Coupling{k,1}, Coupling{k,2});
    toBlock=sprintf('%s/%s', Coupling{k,3}, Coupling{k,4});
    add_line(nameSystem, fromBlock, toBlock);
end    
    
   
end%function
