Probleme:

* in MB hießt der Outport vom sourceSys (Constant) out, die Kopplungsfunktion nutzt aber y.

* in constant war als Callback eine init function eingetragen:
Error evaluating 'InitFcn' callback of SubSystem block (mask) 'ctrlSys4/sourceSys'.
Callback string is 'setParameters'

Transferfunction: parameters must be set as [1] or [1 2] instead of  {1} or {1 2}
* % Problem: ports need to be given as numbers in SES, but Simulink has two lists
%   of numbers for normal ports and entity ports.
% Simple solution: SES names have the form 'PNNN' for normal ports
%   and 'CNNN' for entity ports.
% furthermore in-ports and out-ports are numbered separately


Port names and labels are not accessible in Simulink

Convention for Portnames used in SES cplgs: PNNN or CNN


Plot data: Fehler

simOut = 

  Simulink.SimulationOutput:

                   tout: [104x1 double] 

     SimulationMetadata: [1x1 Simulink.SimulationMetadata] 
           ErrorMessage: [0x0 char] 
           
           
*******
general:
- start of tbx from app or with command 'ses_tbx' at Matlab prompt
- warnings can be ignored for now - Java will be removed from Matlab in future, but is ok for now
- load or create an SES
- model builder is able to create models for Simulink (internal or via script), Dymola and Open Modelica
- still some problems to keep the SES independent from simulator


how to build a model from the SES and simulate it:
- shown for Simulink with script
- write a script where options for model and simulation are set (example: build_simulate_feedback.m)
- script defines options for model builder (modelBuilder.m) and calls model builder
- model builder is rather a builder AND execution unit.

known problems of model builder:
- convention for port names used in SES cplgs: PNNN ('normal' ports) or CNN (entity ports) (to be improved)
- port names are therefore often NOT the same as in model base
- solution: port names and labels are not accessible in Simulink, but if one creates sbsystem using ports, it is possible.
- model builder will support custom port names with next release

- parameters of Simulink blocks need to be set via masks
- variables and data types defined in SES need to match mask variables exactly

- to gain simulation results, there is a need for out blocks in Simulink
- until now, they have to be added to the SES although not part of the 'original' system




