function startFcn_VarSubSysDynCoup_v3_Ctrl()
%% This is a PROTYPE(!) extension of the example "2 Variant Subsystem".
% It shows the model generation in combination with dynamic couplings. 
% The basic information of this example you can find in example
% "1 Variant Subsystem (simple)" and
% you can find further information about it (link from 2015(Feb)02):
% http://de.mathworks.com/help/simulink/examples/variant-subsystems.html
%
% This startFcn..._Ctrl() demonstrates the basic idea of an Reactive
% Experiment Control (EC) using the "Closed Loop  EC-SES/MB-EC Approach"
% The output of each generated system variant is compared with a
% pre-defined ref. signal. The study starts with the simplest system
% structure. If a controler mode (VSS_MODE) overshoots the ref. amplitude,
% the mode is blocked (skipping more complicated designs using this mode).
% Finally, mark best system variant in output figure.   

% date 2017/04/07


% DEFINITION OF REFERENCE AMPLITUDE
amp_ref = 1.2;          %amplitude of reference sine signal

% COLUMN BASED DEFINITION OF ALL 6 SYSTEM VARIANTS
% (order from simple to complex) 
vars =   [1 2 1 2 1 2;  % VSS_Mode
          1 1 2 2 3 3;  % NumSignals
          0 0 0 0 0 0]; % save variance

% Output figure
figure('Name',          'VarSubDynamicCoupling and Control',...
       'MenuBar',       'none',...
       'numberTitle',   'off',...
       'Units',         'normalized',...
       'Position',      [.05 .05 .85 .85],...
       'ToolBar',       'none')

pos = [1 4 2 5 3 6];    %position of variant result in subplot figure

blocked = [0 0];        %vec. for saving a blocked VSS_MODE 1|2 

for k = 1:size(vars,2)  %loop over all variants		 
    
    if ismember(vars(1,k),blocked)  %is VSS_MODE blocked 
        vars(3,k) = inf;	          %then set this var's variance to inf
    else                            %else compute variant
        subplot(2,3,pos(k))     
        VSS_MODE   = vars(1,k);
        NumSignals = vars(2,k);
        
        %built a model & execute it
        simresults = experiment_v3_SL(VSS_MODE, NumSignals);
        
        %get results
        nameSystem  = gcs;                    %get current Simulink system
        is_times    = simresults.tout;        
        is_amp      = simresults.yvalues;  
        is_amp_max  = max(is_amp);              %get max. amplitude
        ref_amp_sig = amp_ref * sin(is_times);  %ref signal(t) 
        vars(3,k)   = var(ref_amp_sig - is_amp);%variance of this variant
                     
        if is_amp_max > amp_ref           %BLOCKING condition 
            blocked(VSS_MODE) = VSS_MODE; %set this VSS_Mode blocked
        end
        
        % PLOT RESULTS
        hold on        
        plot(is_times, is_amp, 'LineWidth' ,2);
        plot(is_times, ref_amp_sig, 'r--', 'LineWidth', 2)
        hndls(k) = gca;
        ylim([-2.5 2.5]) 
        hold off  
        if VSS_MODE == 1
            title(['Linear Control (',num2str(NumSignals),')'])
        else
            title(['NonLinear Control (',num2str(NumSignals),')'])            
        end
        xlabel('Time is sec')
        ylabel('Signal Value')
        grid on    
        
        disp('--- Strike any key to continue ---')
        pause()
        close_system(nameSystem,0) % close generated Simulink model
    end    
end

% determine best variant
[~, idx] = min(vars(3,:));
set(hndls(idx),'Color',[0.9 .8 .9]) %mark figure of best variant
         
%end
