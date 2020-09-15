INTRODUCTION

The software "GUI SES tbx", called "SES_Tbx_Matlab" for the sake of simplicity, has
been developed by the research group Computational Engineering and Automation (CEA)
at Wismar University of Applied Sciences. Purpose of the software is ontology based
modeling of system variants (system structures and parameter configurations) using
the System Entity Structure (SES). It provides transformation methods for deriving
unique system variants.
Furthermore this toolbox allows to build simulation models using the System Entity
Structure / Model Base (SES/MB) approach.

Information on the SES and this toolbox is available on the website:  
https://www.cea-wismar.de/tbx/SES_Tbx/sesToolboxMain.html  
The software is a Matlab Toolbox and also available as Matlab APP. The current version was tested with
Matlab R2018a and Matlab R2020a.

EXECUTE

In a started Matlab change the current folder to the SES_Toolbox directory.
Enter "ses_tbx" in the command window.

KNOWN BUGS, NOTES, TODO

- All node information in the program need to be set by clicking the respective
confirm button. If you forget to click it, the information stay visible in the
field, until a different node is selected.

- When a PES or an FPES is derived, first a target file for saving the derived
structure needs to be set. Choosing an existing PES or FPES file sometimes blocks
the pruning or flattening process and the PES or FPES in the file is displayed.

- SES functions e.g. for couplings only take one argument. If several arguments
are passed, there is no warning and the inserted information is not removed.
However, it is not saved. Clicking another node and clicking the node for which
the information is applied again, makes the insert field be empty.

- The SES can be displayed as tree with the program SESViewEl. For communication
with SESViewEl the Matlab Instrument Control Toolbox needs to be installed and
licensed. If the SES is not displayed completely, the SES needs to be sent again
from the SES Toolbox. A step by step guide is in this directory in the file 
"SES_Toolbox_SESViewEl_Steps.pdf".

- Next to the built-in examples more examples are in the directory
"more_examples". In this directory a documentation for some of these
examples is placed.

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
