classdef parser < handle   
    properties
        parent
        aktToken
        Scanner
        Error 
        %Tokens = tokens;
        SymList 
        isCondition
    end
    methods
        function obj = parser(parent)
            obj.parent = parent;
        end
        function TranslationUnit(obj,String,Rule,SES,varargin)
            Variables = SES.var(:,1);
            %TEMPORAL FIX
            if nargin == 6 % Used to add 'Parent' and 'Children'
                Variables{end+1} = varargin{1};
                Variables{end+1} = varargin{2};
            end
            fcns = SES.fcn;
            Functions = cell(1,length(fcns));
            for i=1:length(fcns)
                nextfcn = fcns{i};
                if ~isempty(nextfcn.Filename)
                    lastdot = strfind(nextfcn.Filename,'.');
                    lastdot = lastdot(end);
                    Functions{i} = nextfcn.Filename(1:lastdot-1);
                end
            end
            Functions(cellfun(@isempty,Functions)) = [];  %delete empty cell entries
            obj.Error = false;
            obj.SymList = cell(0);
            Variables(cellfun(@isempty,Variables)) = [];  %delete empty cell entries
            obj.Scanner = scanner(String,Variables,Functions);
            obj.aktToken = obj.Scanner.GetNextSymbol;
            eval(['obj.',Rule])
        end
        %% Rules that could be selected 
        function Priority(obj)
            if obj.aktToken.Token == tokens.NumStrSy
                if ( str2double(obj.aktToken.Wert) == uint16(str2double(obj.aktToken.Wert)) ) &&...
                    ( str2double(obj.aktToken.Wert) > 0   )
                    obj.read;
                else 
                    %error message nur ein wert pro attribut erlaubt
                    obj.read 
                    obj.Error = true;
                    return
                end
            elseif ismember(obj.aktToken.Token,obj.first('AnonymousFunction'))
                obj.AnonymousFunction;
            elseif obj.aktToken.Token == tokens.VariableSy
                obj.read;
            else
                %error message 
                obj.read 
                obj.Error = true;
                return
            end
            if obj.aktToken.Token ~= tokens.NoSy
                %error message nur ein wert erlaubt
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        function AttributValue(obj)
            %            obj.isCondition = 1;  
            if ismember(obj.aktToken.Token,obj.first('GenExpression'))
                obj.GenExpression;
            elseif ismember(obj.aktToken.Token,obj.first('Set'))
                obj.Set;
            elseif obj.aktToken.Token == tokens.NoSy
                obj.read;
            else
                %error message nur ein wert pro attribut erlaubt
                obj.read 
                obj.Error = true;
                return
            end
            if obj.aktToken.Token ~= tokens.NoSy
                %error message nur ein wert pro attribut erlaubt
                obj.read 
                obj.Error = true;
                return
            end
        end%rule
        function CouplingFunction(obj)
%             Variables(end+1)={'Children'}; % TEST !
%             Variables(end+1)={'Parent'};   % TEST !
            obj.AnonymousFunction;
            if obj.aktToken.Token ~= tokens.NoSy
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        function Condition(obj)
            obj.isCondition = false;   
            if ismember(obj.aktToken.Token,obj.first('GenExpression'))
                obj.GenExpression;
                %         elseif ismember(obj.aktToken.Token,obj.first('Set'))
                %             obj.Set;
            else
                %error message nur ein wert pro attribut erlaubt
                obj.read 
                obj.Error = true;
                return
            end
            if obj.aktToken.Token ~= tokens.NoSy
                %error message nur ein wert pro attribut erlaubt
                obj.read 
                obj.Error = true;
                return
            end
            if obj.isCondition
                %error message nur ein wert pro attribut erlaubt
                obj.read 
                obj.Error = true;
                return
            end 
            
        end%rule        
        %%            
        function AnonymousFunction(obj)
            if obj.aktToken.Token == tokens.FunctionSy
                obj.read   
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end 
            if obj.aktToken.Token == tokens.RBracketOpenSy
                obj.read;
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end
            loopCond = obj.aktToken.Token ~= tokens.RBracketCloseSy;
            while loopCond
                if ismember(obj.aktToken.Token,obj.first('GenExpression'))
                    obj.GenExpression;
                elseif ismember(obj.aktToken.Token,obj.first('Set'))
                    obj.Set;
                else
                    obj.Vector;
                end
                if obj.aktToken.Token == tokens.CommaSy
                    loopCond = true;
                    obj.read;
                else
                    loopCond = false;
                end
            end%while
            if obj.aktToken.Token == tokens.RBracketCloseSy
                obj.read;
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end
        end%function   
        
        function MultiOutputFunction(obj)
            if obj.aktToken.Token == tokens.MultiOutputSy
                obj.read;
            else
                %error message
                obj.read 
                obj.Error = true;
                return 
            end
            if ismember(obj.aktToken.Token,obj.first('AnonymousFunction'))
                obj.AnonymousFunction;
            elseif ismember(obj.aktToken.Token,obj.first('Set'))
                obj.Set;
            else
                %error message
                obj.read 
                obj.Error = true;
                return 
            end
            if obj.aktToken.Token ~= tokens.NoSy
                %error message
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        %% Recursive Rules         
        %%        
        function GenExpression(obj)
            while ismember(obj.aktToken.Token,obj.first('AddOp')) || obj.aktToken.Token == tokens.NotSy
                obj.read;
            end
            obj.Product;
            while ismember(obj.aktToken.Token,obj.first('AddOp'))
                obj.AddOp
                obj.Product;
            end
        end%function
        
        function Product(obj)
            obj.Compare;
            while ismember(obj.aktToken.Token,obj.first('MulOp'))
                obj.MulOp
                obj.Compare;
            end
        end%function
        function Compare(obj)
            obj.Logic; 
            while ismember(obj.aktToken.Token,obj.first('CmpOp'))
                %                   obj.loop = obj.loop+1;
                obj.CmpOp
                obj.Logic;
            end
            %             if obj.loop == 0
            %                 %error message
            %                 obj.Error = true;
            %             end
            CmpLogNotExist = false;
            FcnExist = false;
            for i=1:length(obj.SymList)
                nxtSym = obj.SymList(i);
                if ismember(nxtSym.Token,obj.first('CmpOp'))||...
                    ismember(nxtSym.Token,obj.first('LogOp'))||...
                    nxtSym.Token == tokens.NotSy
                    CmpLogNotExist = true;
                elseif nxtSym.Token == tokens.FunctionSy
                    FcnExist = true;
                end
            end
            if CmpLogNotExist || FcnExist
                obj.isCondition = false;
            else
                %error message
                obj.isCondition = true;
                return
            end
        end%function
        function Compare2(obj)
            if obj.aktToken.Token ~= tokens.FunctionSy
                obj.Logic;
                obj.CmpOp;
                obj.Logic;
            else
                obj.Logic; 
                while ismember(obj.aktToken.Token,obj.first('CmpOp'))
                    obj.CmpOp
                    obj.Logic;
                end
            end
        end%function
        function Logic(obj)
            obj.Factor;
            while ismember(obj.aktToken.Token,obj.first('LogOp'))
                obj.LogOp
                obj.Factor;
            end
        end%function
        function Factor(obj)
            if obj.aktToken.Token == tokens.RBracketOpenSy
                obj.read;  %read current Symbol and get next Token
                obj.GenExpression;
                if obj.aktToken.Token == tokens.RBracketCloseSy
                    obj.read;
                else
                    %error message
                    obj.read 
                    obj.Error = true;
                    return
                end
            elseif ismember(obj.aktToken.Token,obj.first('SpecExpression'))
                obj.SpecExpression;
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        function Matrix(obj)
            %!!!!!muss in parserregel geändert werden!!!!!
            if obj.aktToken.Token == tokens.SqBracketOpenSy
                obj.read;  %read current Symbol and get next Token
                if ismember(obj.aktToken.Token,obj.first('AddOp'))
                    obj.AddOp;
                end
                if obj.aktToken.Token == tokens.NumStrSy
                    obj.read;
                else
                    obj.read 
                    %error message
                    obj.Error = true;
                    return
                end 
                %                 obj.GenExpression;
                while ismember(obj.aktToken.Token,[tokens.CommaSy,tokens.SemiColonSy,tokens.ColonSy])
                    obj.read;
                    if ismember(obj.aktToken.Token,obj.first('AddOp'))
                        obj.AddOp;
                    end
                    if obj.aktToken.Token == tokens.NumStrSy
                        obj.read;
                    else
                        obj.read 
                        %error message
                        obj.Error = true;
                        return
                    end
                    %                     obj.GenExpression;
                end
                if obj.aktToken.Token == tokens.SqBracketCloseSy
                    obj.read;
                else
                    obj.read 
                    %error message
                    obj.Error = true;
                    return
                end
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        function Vector(obj)
            if obj.aktToken.Token == tokens.SqBracketOpenSy
                obj.read;  %read current Symbol and get next Token
                if obj.aktToken.Token == tokens.SqBracketCloseSy
                    %empty Vector is allowed
                    obj.read;
                else
                    obj.GenExpression;
                    while ismember(obj.aktToken.Token,[tokens.CommaSy,tokens.ColonSy])
                        obj.read;
                        obj.GenExpression;
                    end
                    if obj.aktToken.Token == tokens.SqBracketCloseSy
                        obj.read;
                    else
                        obj.read 
                        %error message
                        obj.Error = true;
                        return
                    end
                end
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        function Set(obj)
            if obj.aktToken.Token == tokens.CurlyBraceOpenSy
                obj.read;  %read current Symbol and get next Token
                obj.GenExpression;
                while obj.aktToken.Token == tokens.CommaSy 
                    obj.read;
                    obj.GenExpression;
                end
                if obj.aktToken.Token == tokens.CurlyBraceCloseSy
                    obj.read;
                else
                    %error message
                    obj.read 
                    obj.Error = true;
                    return
                end
            else
                %error message
                obj.read 
                obj.Error = true;
                return
            end
        end%function
        function LogOp(obj)
            if obj.aktToken.Token == tokens.LogAndSy
                obj.read
            elseif obj.aktToken.Token == tokens.LogOrSy
                obj.read    
            else
                %error message
                obj.read 
                obj.Error = true;
            end 
        end%function
        function CmpOp(obj)
            if obj.aktToken.Token == tokens.EqualSy
                obj.read
            elseif obj.aktToken.Token == tokens.UnequalSy
                obj.read    
            elseif obj.aktToken.Token == tokens.GreaterThanSy
                obj.read 
            elseif obj.aktToken.Token == tokens.GreaterEqualSy
                obj.read 
            elseif obj.aktToken.Token == tokens.LessThanSy
                obj.read     
            elseif obj.aktToken.Token == tokens.LessEqualSy
                obj.read      
            else
                %error message
                obj.read 
                obj.Error = true;
            end 
        end%function
        function MulOp(obj)
            if obj.aktToken.Token == tokens.MulSy
                obj.read
            elseif obj.aktToken.Token == tokens.DivSy
                obj.read    
            else
                %error message
                obj.read 
                obj.Error = true;
            end 
        end%function
        function AddOp(obj)
            if obj.aktToken.Token == tokens.AddSy
                obj.read
            elseif obj.aktToken.Token == tokens.SubSy
                obj.read    
            else
                %error message
                obj.read 
                obj.Error = true;
            end 
        end%function
        function SpecExpression(obj)
            if obj.aktToken.Token == tokens.StrSy
                obj.read
            elseif obj.aktToken.Token == tokens.NumStrSy
                obj.read    
            elseif obj.aktToken.Token == tokens.VariableSy
                obj.read
            elseif obj.aktToken.Token == tokens.FunctionSy
                obj.AnonymousFunction;
            elseif ismember(obj.aktToken.Token,obj.first('Matrix'))
                obj.Matrix
            else
                %error message
                obj.read 
                obj.Error = true;
            end            
        end%function
        function read(obj)
            %lese aktuelles Symbol ein und aktuallisiere nächstes Token
            obj.SymList = [obj.SymList,obj.aktToken];
            obj.aktToken = obj.Scanner.GetNextSymbol;      
        end%function
        function firstTerm = first(~,NonTerminal)
            switch NonTerminal
                case 'SpecExpression'
                firstTerm = [tokens.StrSy,tokens.NumStrSy,tokens.VariableSy,tokens.SqBracketOpenSy,tokens.FunctionSy];
                case 'LogOp'
                firstTerm = [tokens.LogAndSy,tokens.LogOrSy];    
                case 'AddOp'
                firstTerm = [tokens.AddSy,tokens.SubSy];
                case 'MulOp'
                firstTerm = [tokens.MulSy,tokens.DivSy];   
                case 'CmpOp'
                firstTerm = [tokens.EqualSy,tokens.UnequalSy,...
                tokens.GreaterThanSy,tokens.GreaterEqualSy,...
                tokens.LessThanSy,tokens.LessEqualSy];       
                case 'GenExpression'
                firstTerm = [tokens.StrSy       , tokens.NumStrSy,...
                tokens.VariableSy, tokens.RBracketOpenSy, tokens.NotSy,...
                tokens.AddSy       , tokens.SubSy, tokens.FunctionSy,...
                tokens.SqBracketOpenSy]; 
                case 'Set'
                firstTerm = [tokens.CurlyBraceOpenSy];  
                case 'Matrix'
                firstTerm = [tokens.SqBracketOpenSy];
                case 'AnonymousFunction'
                firstTerm = [tokens.FunctionSy]; 
            end
        end%function
        function followTerm = follow(~,NonTerminal)
            switch NonTerminal
                case 'Set'
                followTerm = [tokens.StrSy       , tokens.NumStrSy,...
                tokens.VariableSy, tokens.RBracketOpenSy,...
                tokens.AddSy       , tokens.SubSy];    
                case 'AnonymousFunction'
                followTerm = [tokens.tokens.RBracketOpenSy]; 
            end
        end%function
        %% helpful - replace Name in a String by a new Name %%%%%%%%%%%%%%%%%%%%%%%
        function [String] = replaceSymValues(obj,oldName,NewName,Token,String)
            for kk = 1:length(obj.SymList)
                nextSym = obj.SymList(kk);
                if nextSym.Token == Token
                    if strcmp(nextSym.Wert,oldName)
                        if nextSym.Pos(2) == length(String)                 % einfache Ersetzung des gesamten Strings
                            String = [String(1:nextSym.Pos(1)-1),NewName];
                        else
                            newString = replace(String,oldName,NewName);    % C.D. 16.12.2021
                            String = newString;
                            %String = [String(1:nextSym.Pos(1)-1),NewName,String(nextSym.Pos(2)+1:end)]; % Ersetzung von Zeichen innerhalb des Strings --> Fehler bei mehrfachem Vorkommen
                        end
                    end
                end
            end
        end%function
        %% helpful - compares 2 SymLists and returns true if they are equal%%%%%%%%   
        function [flag] = symcmp(~,SymList1,SymList2)
            if length(SymList1) ~= length(SymList2)
                flag = false;
            else %SymLists have the same length
                flag = true;
                for i=1:length(SymList1)
                    nextSym1 = SymList1(i);
                    nextSym2 = SymList2(i);
                    if nextSym1.Token == nextSym2.Token
                        if nextSym1.Token == tokens.NumStrSy
                            if nextSym1.Wert ~= nextSym2.Wert
                                flag = false;
                                break
                            end
                        elseif ismember(nextSym1.Token,[tokens.StrSy,...
                            tokens.VariableSy,...
                            tokens.FunctionSy])
                            %                                                 tokens.KeywordSy,...
                            if ~strcmp(nextSym1.Wert,nextSym2.Wert)
                                flag = false;
                                break
                            end
                        end
                    else 
                        flag = false;
                        break
                    end
                end
            end
        end%function
    end
end
