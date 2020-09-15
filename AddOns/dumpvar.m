function varargout = dumpvar(varargin)
% This function defines a universal interface (number of input and output 
% accepted) and can therefore be used for dummy or debug purposes for e.g.
% as PLACEHOLDER for any kind of CALLBACK FUNCTION

% Birger Freymann | Wismar University | 2016.08.24

    
    %show some helpfull information
    fprintf(2,'\tCALL SUMMARY:\n');
    fprintf(1,'\t[NARGOUT:%2d] = %s(NARGIN:%d)   \n',...
        nargout,upper(mfilename),nargin);
   
    %find Caller history    
    fprintf(2,'\n\tCALLER HISTORY: \n');
    db_info = dbstack('-completenames');
    for i = 2:numel(db_info)            
        disp(db_info(i))
    end
    if isempty(i)
        fprintf(1,'\tcalled directly\n');
    end
     
    %show Input Data 
    if nargin
        %
        fprintf(2,'\n\tINPUT VARIABLE NAMES:\n');
        c = cell(nargin,2);
        for j = 1:nargin
            c{j,1} = sprintf('VarName%d:',j);
            c{j,2} = inputname(j);
        end
        disp(c)
        
        fprintf(2,'\tINPUT VALUES:\n');       
        celldisp(varargin,'InArgVal')
    end
    
    %define output interface
    varargout = cell(1,nargout);    
end