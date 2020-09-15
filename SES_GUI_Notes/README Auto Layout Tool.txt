The Auto Layout Tool
by McMaster Centre for Software Certification

OVERVIEW
========

The Auto Layout Tool automatically formats a Simulink model to improve its layout visually. Packaged with this tool are two additional tools: Flatten Subsystem and Line - Goto/From. The Flatten Subsystem tool brings all blocks from a subsystem up to the current level, while Line - Goto/From convert signals lines to Goto/From connections, and vice versa.

INSTALLATION FROM THE ZIP
=========================

1. Unzip the "AutoLayout" folder.

2. Move the unzipped folder to wherever you want it.

3. Add the same folder to your MATLAB Search Path using Set Path. For more information see: http://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html

4. AutoLayout can be used from the context menu in a Simulink model, but for this option to appear, MATLAB must be restarted after setting the search path.

5. Install the 3rd party software, Graphviz (See "Graphviz" section below).

6. To quickly test that the Auto Layout Tool is working, execute the following commands from the MATLAB command line:
	open('AutoLayoutDemo')
	AutoLayout('AutoLayoutDemo')
The system should start out messy and get cleaned up!

INSTALLATION FROM THE TOOLBOX
=============================

1) Execute the .mltbx with MATLAB and follow the installation procedure.

2) AutoLayout can be used from the context menu in a Simulink model, but for this option to appear, MATLAB must be restarted after setting the search path.

3) Install the 3rd party software, Graphviz (See "Graphviz" section below).

4) To quickly test that the Auto Layout Tool is working, execute the following commands from the MATLAB command line:
	open('AutoLayoutDemo')
	AutoLayout('AutoLayoutDemo')
The system should start out messy and get cleaned up!

GRAPHVIZ
========
The Auto Layout Tool requires 3rd party software, specifically, the Graphviz software, which is a set of open-source graph-drawing tools. The user will need to install Graphviz for the Auto Layout tool to function. 

1. The Graphviz files can be downloaded on the official web site: http://www.graphviz.org. Please follow their instructions on installation.

2. After installation:
	2a. for Windows, newer versions of the Graphviz software do not automatically put Graphvizâ€™s dot command (which is used in the Auto Layout Tool) on the system path. Therefore, for the tool to function, the user must manually set the system path such that the dot command in the batch file works correctly. This means appending the Graphviz bin directory (C:\Program Files (x86)\Graphviz2.xx\bin, for example) to the PATH environment variable.

	To learn how to set the system path appropriately, refer to: http://www.computerhope.com/issues/ch000549.htm.
	The path that needs to be added is "C:\Program Files (x86)\Graphviz2.xx\bin" where 2.xx is the Graphviz version that was installed.

	2b. For Linux and Mac OS X, if after installation the dot command is not on the system path visible to MATLAB, the system path visible to MATLAB should be changed to include the folder that contains the command. For detailed instructions on running external programs from MATLAB, see: http://www.mathworks.com/help/matlab/matlab_env/run-external-commands-scripts-and-programs.html 

HOW TO USE THE TOOL
===================

From the Context Menu....
1. The Auto Layout Tool is usable from the right-click Context Menu on a Simulink model window. Just right-click on the block diagram that you wishe to run the tool on, and select "AutoLayout".

2. Upon selecting AutoLayout, a dialog box will appear prompting you to save the original model before running the tool, since the operation cannot be undone. Choose one of the options:
	1. Click Yes to save and continue
	2. Click No to continue without saving 
	3. Click X to cancel the operation

From the Command Line...
1. Simply call the function:
	AutoLayout(system)
where system is the string representing the full name of the subsystem you wish to run the tool on.

WARNING: Please use caution when saving your model after using the Auto Layout Tool because there is no functionality to undo.
NOTE: The tool runs on one diagram at a time. It does not recusively run on all the layers of the Simulink model.

Also packaged with the Auto Layout tool are the Line to Goto/Froms and Goto/Froms to Line functions, and the Flatten Subsystem function. From the Context Menu, these tools are run in the same way as the Auto Layout Tool, either via the Context Menu or the command line. The Line to Goto/Froms option will appear when right-clicking on a signal line, the Goto/Froms to Line option will appear when right-clicking on a Goto or From block, and the Flatten Subsystem option will appear when right-clicking on a Subsystem.

CONTACT INFO
============

All code copyright: 
Steven Postma, McMaster Centre for Software Certification, 2013.
Jeff Ong, McMaster Centre for Software Certification, 2013-2014.
Monika Bialy, McMaster Centre for Software Certification, 2016.
Gordon Marks, McMaster Centre for Software Certification, 2015-2016.
Bennett Mackenzie, McMaster Centre for Software Certification, 2014-2016.

For more information or questions about the Auto Layout Tool, contact us via Matlab Central:
https://www.mathworks.com/matlabcentral/profile/authors/6052287-mark-lawford

or contact:
Professor Mark Lawford
Associate Director
McMaster Centre for Software Certification
lawford (at) mcmaster.ca