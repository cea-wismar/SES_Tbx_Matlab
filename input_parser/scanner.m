classdef scanner < handle
    %separates the string into symbols and sends always the next
    %Symbol to the parser
    properties
        ch                                      %current char of the string
        Position = 0;                           %Position of the Char in the String
        OriginalStr                             %the string to the beginning of the scan process
        String                                  %rest of the string that shall be inspected 
        %Tokens = tokens;                        %class of all possible symbols
        Variables                               %contains SES-Variables             
        Functions = {'ismember'}                %contains Functions that wont be recognized as builtInFcn 
    end
    methods
        function obj = scanner(string,Variables,Functions)
            obj.Variables = Variables;
            obj.Functions = [obj.Functions,Functions];
            obj.String = string;
            obj.OriginalStr = string;
            obj.ch = obj.nnwChar;
        end
        function [nextSymbol] = GetNextSymbol(obj)
            %check if current char is empty -> than save next not empty char 
            if isspace(obj.ch)
                obj.ch = obj.nnwChar;
            end    
            if isempty(obj.ch)
                nextSymbol = symbol(tokens.NoSy,[],obj.Position);
                return
            end
            %check if current char is a literal in the beginning ->
            %if so, than String-Symbol or Keyword
            if isvarname(obj.ch)
                %collect all following chars, until
                %   1. End of the string
                %   2. WhiteSpace field is reached
                %   3. invalid Variable input
                NoFullSym = true;
                var = obj.ch;
                while NoFullSym
                    obj.ch = obj.nChar; 
                    if isempty(obj.ch) %   1. Ende of the string is reached - Valid
                        if ismember(var,obj.Variables)
                            startPos = obj.Position - length(var);
                            nextSymbol = symbol(tokens.VariableSy,var,[startPos,obj.Position]);
                        elseif ismember(var,obj.Functions) || exist(var,'builtin')
                            startPos = obj.Position - length(var);
                            nextSymbol = symbol(tokens.FunctionSy,var,[startPos,obj.Position]);
                        else
                            %Tokens.UnknownSy
                            startPos = obj.Position - length(var);
                            nextSymbol = symbol(tokens.UnknownSy,var,[startPos,obj.Position]); 
                        end
                        NoFullSym = false;
                    elseif ~isvarname([var,obj.ch]) %   3. invalid new Symbol, but without last char its ok - Valid
                        if (ismember(var,obj.Functions) || exist(var,'builtin') ) && obj.ch=='('
                            startPos = obj.Position - length(var);
                            nextSymbol = symbol(tokens.FunctionSy,var,[startPos,obj.Position-1]);
                        elseif ismember(var,obj.Variables)
                            startPos = obj.Position - length(var);
                            nextSymbol = symbol(tokens.VariableSy,var,[startPos,obj.Position-1]);
                        else
                            %Tokens.UnknownSy
                            startPos = obj.Position - length(var);
                            nextSymbol = symbol(tokens.UnknownSy,var,[startPos,obj.Position-1]); 
                        end
                        NoFullSym = false;
                    else 
                        var = [var,obj.ch]; %not finished yet
                    end  
                end
            elseif ~isnan(str2double(obj.ch)) && isnumeric(str2double(obj.ch))  %isnumber
                %collect all following chars, until
                %   1. End of the string
                %   2. WhiteSpace field is reached
                %   3. invalid Variable input
                NoFullSym = true;
                nummer = obj.ch;
                while NoFullSym
                    obj.ch = obj.nChar; 
                    if isempty(obj.ch) %   1. Endof the string is reached - Valid
                        startPos = obj.Position - length(nummer);
                        nextSymbol = symbol(tokens.NumStrSy,nummer,[startPos,obj.Position-1]);
                        NoFullSym = false;
                    elseif isspace(obj.ch)
                        startPos = obj.Position - length(nummer);
                        nextSymbol = symbol(tokens.NumStrSy,nummer,[startPos,obj.Position-1]); %invalid new Symbol, but without last char its ok - Valid
                        NoFullSym = false;    
                    elseif ~obj.isnumber([nummer,obj.ch])    
                        startPos = obj.Position + 1 - length(nummer);
                        nextSymbol = symbol(tokens.NumStrSy,nummer,[startPos,obj.Position-1]); %invalid new Symbol, but without last char its ok - Valid
                        NoFullSym = false;  
                    else 
                        %noch nicht fertiges symbol
                        nummer = [nummer,obj.ch]; 
                    end  
                end
            else    
                %check sämtliche andere mögliche Sonderzeichen
                switch obj.ch
                    case '''' % start eines Literals Tokens.StrSy
                    %collect all following chars, until
                    %   1. End of the string - Invalid
                    %   2. second char is ' char as well - Invalid
                    %   3. next ' char is reached - Valid
                    NoFullSym = true;
                    CharString = obj.ch;
                    while NoFullSym
                        obj.ch = obj.nChar;                
                        if isempty(obj.ch)   %   1. End of the string - Invalid 
                            %Tokens.UnknownSy
                            startPos = obj.Position - length(CharString);
                            nextSymbol = symbol(tokens.UnknownSy,[],[startPos,obj.Position-1]); 
                            NoFullSym = false;
                        elseif obj.ch == ''''  %   2. second char is ' char as well - Invalid
                            CharString = [CharString,obj.ch];
                            startPos = obj.Position + 1 - length(CharString);
                            nextSymbol = symbol(tokens.StrSy,CharString,[startPos,obj.Position]);
                            NoFullSym = false;
                            obj.ch = obj.nChar;
                        else
                            %CharString not yet ready
                            CharString = [CharString,obj.ch]; 
                        end
                    end
                    case ',' % Tokens.CommaSy
                    nextSymbol = symbol(tokens.CommaSy,[],[obj.Position,obj.Position]);
                    obj.ch = obj.nChar;
                    case '=' % Tokens.EqualSy
                    obj.ch = obj.nChar;
                    if obj.ch == '='
                        nextSymbol = symbol(tokens.EqualSy,[],[obj.Position-1,obj.Position]);
                        obj.ch = obj.nChar;
                    else
                        nextSymbol = symbol(tokens.UnknownSy,[],[obj.Position-1,obj.Position-1]);
                    end
                    case '~' % Tokens.UnequalSy
                    obj.ch = obj.nChar;
                    if obj.ch == '='
                        nextSymbol = symbol(tokens.UnequalSy,[],[obj.Position-1,obj.Position]);
                        obj.ch = obj.nChar;
                    else
                        nextSymbol = symbol(tokens.NotSy,[],[obj.Position-1,obj.Position-1]);
                    end
                    case '>' % eigther Tokens.greaterThanSy or Tokens.GreaterEqualSy
                    obj.ch = obj.nChar;
                    if obj.ch == '='
                        nextSymbol = symbol(tokens.GreaterEqualSy,[],[obj.Position-1,obj.Position]);
                        obj.ch = obj.nChar;
                    else
                        nextSymbol = symbol(tokens.GreaterThanSy,[],[obj.Position-1,obj.Position-1]);
                    end
                    case '<' % eigther Tokens.LessThanSy or Tokens.LessEqualSy
                    obj.ch = obj.nChar;
                    if obj.ch == '='
                        nextSymbol = symbol(tokens.LessEqualSy,[],[obj.Position-1,obj.Position]);
                        obj.ch = obj.nChar;
                    else
                        nextSymbol = symbol(tokens.LessThanSy,[],[obj.Position-1,obj.Position-1]);
                    end
                    case '{' % Start of a Set Tokens.CurlyBraceOpenSy
                        nextSymbol = symbol(tokens.CurlyBraceOpenSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    case '}' % End of a Set Tokens.CurlyBraceCloseSy
                        nextSymbol = symbol(tokens.CurlyBraceCloseSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    case '(' % Tokens.RBracketOpenSy
                        nextSymbol = symbol(tokens.RBracketOpenSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    case ')' % Tokens.RBracketCloseSy
                        nextSymbol = symbol(tokens.RBracketCloseSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;    
                    case '[' % Ende einer Menge Tokens.SqBracketOpenSy
                        nextSymbol = symbol(tokens.SqBracketOpenSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    case ']' % Tokens.SqBracketCloseSy
                        nextSymbol = symbol(tokens.SqBracketCloseSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;   
                    case '&' % Tokens.LogAndSy
                        nextSymbol = symbol(tokens.LogAndSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    case '|' % Tokens.LogOrSy  
                        nextSymbol = symbol(tokens.LogOrSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    case '*' % Tokens.MulSy  
                        nextSymbol = symbol(tokens.MulSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar; 
                    case '/' % Tokens.DivSy  
                        nextSymbol = symbol(tokens.DivSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;   
                    case '+' % Tokens.AddSy  
                        nextSymbol = symbol(tokens.AddSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;     
                    case '-' % Tokens.SubSy  
                        nextSymbol = symbol(tokens.SubSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar; 
                    case '@' % Tokens.AtSy  
                        nextSymbol = symbol(tokens.AtSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;     
                    case ':' % Tokens.ColonSy 
                        nextSymbol = symbol(tokens.ColonSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;     
                    case ';' % Tokens.SemiColonSy
                        nextSymbol = symbol(tokens.SemiColonSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;  
                    case '#' % Tokens.MultiOutputSy
                        nextSymbol = symbol(tokens.MultiOutputSy,[],[obj.Position,obj.Position]);
                        obj.ch = obj.nChar;
                    otherwise
                    %Tokens.UnknownSy
                        nextSymbol = symbol(tokens.UnknownSy,[],[obj.Position,obj.Position]); 
                        obj.ch = obj.nChar;
                end
            end
        end
        %% get next char          
        function nch = nChar(obj) 
            if isempty(obj.String) 
                nch = [];
            else
                nch = obj.String(1);
                obj.String(1) = [];
            end
            obj.Position = obj.Position + 1;
        end
        %% get next, not-whitespace char      
        function nnwch = nnwChar(obj)
            while 1
                if isempty(obj.String)
                    nnwch = [];
                    break
                elseif isspace(obj.String(1))
                    obj.String(1) = [];
                    obj.Position = obj.Position + 1;
                else
                    nnwch = obj.String(1);
                    obj.String(1) = [];
                    obj.Position = obj.Position + 1;
                    break
                end
            end%while
        end%function
    end
    methods (Static)
        function [flag] = isnumber(strnum)   
            allowed = {'1','2','3','4','5','6','7','8','9','0','.'};
            flagVec = false(1,length(strnum));
            for i=1:length(strnum)
                flagVec(i) = ismember(strnum(i),allowed);
            end
            flag1 = ~ismember(false,flagVec);
            flag2 = length(strfind(strnum,'.'))<2;
            flag = flag1 && flag2;
        end
    end
end
