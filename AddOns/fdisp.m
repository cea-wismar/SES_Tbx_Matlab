function fdisp(fid,value)

%if no file descriptor is defined
if nargin == 1
    value = fid;
    fid = 1;
end


if isempty(value)
    if ischar(value)
        str = '''''';
    elseif iscell(value)
        str = '{ }';
    else
        str = '[ ]';
    end
    fprintf(fid,str);
    
    
elseif ischar(value)
    str = ['''',value,''''];
    fprintf(fid,str);
    
    
elseif isnumeric(value) && numel(value) == 1
    if numel(value) == 1
        str = num2str(value);
    elseif size(value,1) == 1 && size(value,2) < 10
        str = ['[',sprintf('%0.5f ',value)];
        str(end) = ']';
    else
        %need to to further work here !!! Array !!!
        str = sprintf('%d×', size(value));
        str(end) = [];
        str = sprintf('[%s %s]',str,class(value));
    end
    fprintf(fid,str);
    
    
elseif islogical(value)
    if numel(value) == 1
        str = num2str(value);
    elseif size(value,1) == 1 && size(value,2) < 10
        str = ['[',sprintf('%df ',value)];
        str(end) = ']';
    else
        %need to to further work here !!! Array !!!
        str = sprintf('%d×', size(value));
        str(end) = [];
        str = sprintf('[%s %s]',str,class(value));
    end
    fprintf(fid,str);
    
    
elseif iscellstr(value)
    str = ['{',sprintf('''%s''  ',value{:})];
    str(end-1) = '}';
    fprintf(fid,str);
    
    
elseif isstruct(value)
    f_names = fieldnames(value);
    spacing = max(cellfun(@numel,f_names));
    offset_left_site = 4;
    
    for k = f_names'
        format = sprintf('%%%ds: %%s\\n',spacing + offset_left_site);
        cur_f_name  = k{:};
        cur_f_value = content2str_line( value.(k{:}));
        fprintf(fid,format,cur_f_name,cur_f_value);
    end
    
    
elseif iscell(value)
    %need to to further work here !!!
    
else
    str = sprintf('%d×', size(value));
    str(end) = [];
    str = sprintf('[%s %s]',str,class(value));
    fprintf(fid,str);
end

%end with a new line
fprintf(fid,'\n');
end

function str = content2str_line(value)
if isempty(value)
    if ischar(value)
        str = '''''';
    elseif iscell(value)
        str = '{}';
    else
        str = '[]';
    end
    
    
elseif ischar(value)
    str = ['''',value,''''];
    
    
elseif isnumeric(value)
    if numel(value) == 1
        str = num2str(value);
    elseif size(value,1) == 1 && size(value,2) < 10
        str = ['[',sprintf('%0.5f ',value)];
        str(end) = ']';
    else
        str = sprintf('%d×', size(value));
        str(end) = [];
        str = sprintf('[%s %s]',str,class(value));
    end
    
    
elseif islogical(value)
    if value
        str = '1';
    else
        str = '0';
    end
    
    
else %cellarray | structure | userdefined
    if iscellstr(value)
        str = ['{',sprintf('''%s''  ',value{:})];
        str(end-1) = '}';
    elseif iscell(value)
        %%here is some work to do
        str = sprintf('{%d×%d %s}',size(value),class(value));
    else
        str = sprintf('%d×', size(value));
        str(end) = [];
        str = sprintf('[%s %s]',str,class(value));
    end    
end
end
