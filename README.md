[![View MATLAB / Simulink Tbx for Variant Modeling & Simulation on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://de.mathworks.com/matlabcentral/fileexchange/68531-matlab-simulink-tbx-for-variant-modeling-simulation)

INTRODUCTION

The software "SES_Tbx_Matlab" has been developed by the research group
Computational Engineering and Automation (CEA) at Wismar University of Applied Sciences.
Purpose of the software is ontology based modeling of system variants
(system structures and parameter configurations) using
the System Entity Structure (SES). It provides transformation methods for deriving
unique system variants.
Furthermore this toolbox allows to build simulation models using the System Entity
Structure / Model Base (SES/MB) approach.

Information on the SES and this toolbox is available on the website:  
https://www.cea-wismar.de/tbx/SES_Tbx/sesToolboxMain.html  
The file Tutorial.pdf in the main directory of this tool is a presentation introducing the
SES and available software.

The software is a Matlab Toolbox and also available as Matlab App. The current version is tested with
Matlab R2018a and Matlab R2020a.

EXECUTE

In a running Matlab set the SES_Toolbox directory as current folder.
Enter "ses_tbx" in the command window.
Alternatively install the app from releases and start it.

ADD ON TOOL: TREEVIEWER

- The SES can be displayed as tree with the program SESViewEl. For communication
with SESViewEl the Matlab Instrument Control Toolbox needs to be installed and
licensed. If the SES is not displayed completely, the SES needs to be sent again
from the SES Toolbox. A step by step guide is in this directory in the file 
"SES_Toolbox_SESViewEl_Steps.pdf". This tool is available on the website:
https://github.com/cea-wismar/sesviewel

MODEL BUILDING

- The SES_Tbx_Matlab supports a script based model building. This process cannot
be started from the app GUI. In the directory ./more_examples/FeedbackControl a
case study for model building is delivered. Using the app installation, it is
necessary to change manually into the app directory of SES_Tbx_Matlab.


KNOWN BUGS, NOTES, TODO

- All node information in the program need to be set by clicking the respective
confirm button. If you forget to click it, information stays visible in the
field, until a different node is selected.

- When a PES or an FPES is derived, first a target file for saving the derived
structure needs to be set. Choosing an existing PES or FPES file sometimes blocks
the pruning or flattening process and the PES or FPES in the file is displayed.

- Siblings of multi-aspect nodes and siblings of aspect and multi-aspect nodes on
the second layer of the SES cannot be pruned.

- Next to the built-in examples more examples are in the directory "more_examples".
In this directory a documentation for some of these examples is placed.

- Different from older versions, current release allows to define subtrees under multi-aspect nodes.

LICENSE

This application is licensed under GNU GPLv3.

HOW TO CITE

Pawletta, T., Pascheka, D., Schmidt, A. and Pawletta, S. (2014). Ontology-Assisted
System Modeling and Simulation within MATLAB/Simulink. SNE Simulation Notes Europe,
ARGESIM/ASIM Pub. TU Vienna, Austria, 24(2)-8/2014, 59-68
(DOI: 10.11128/sne.24.tn.102241) 

Pawletta, T., Pascheka, D. and Schmidt, A. (2015). System Entity Structure Ontology
Toolbox for MATLAB/Simulink: Used for Variant Modelling. Proc. of MATHMOD 2015 - 8th
Vienna Int. Conf. on Mathematical Modelling, Breitenecker, F., Kugi, A. and Troch, I.
(Eds.), February 18 - 20, ARGESIM Report No. 44 (ISBN: 978-3-901608-46-9), ARGESIM,
Vienna/Austria UT, 2015, 369-370. 
