classdef tokens < int8
    %contains all relevant Symbols (tokens) and assign a number to them
    %for an easier comparison of symbols    
    enumeration
        UnknownSy         (-1) % Symbol is unknown
        NoSy              ( 0) % there is no Symbol left
        StrSy             ( 1) % Symbol for a String
        NumStrSy          ( 2) % Symbol for a Number
        VariableSy        ( 3) % Symbol for an SES-Variable
        CommaSy           ( 4) % ","
        RBracketOpenSy    ( 5) % "("
        RBracketCloseSy   ( 6) % ")" 
        CurlyBraceOpenSy  ( 7) % "{"
        CurlyBraceCloseSy ( 8) % "}"
        EqualSy           ( 9) % "="
        UnequalSy         (10) % "~="
        GreaterThanSy     (11) % ">"
        GreaterEqualSy    (12) % ">="
        LessThanSy        (13) % "<"
        LessEqualSy       (14) % "<="
       %KeywordSy         (15) % Symbol for a keyword
        LogAndSy          (16) % "&"
        LogOrSy           (17) % "|"
        MulSy             (18) % "*"
        DivSy             (19) % "/"
        AddSy             (20) % "+"
        SubSy             (21) % "-"
        SqBracketOpenSy   (22) % "["
        SqBracketCloseSy  (23) % "]"
        AtSy              (24) % "@"
        FunctionSy        (25) % Symbol for SES Functions
        ColonSy           (26) % ":"
        SemiColonSy       (27) % ";"
        MultiOutputSy     (28) % "#"
        NotSy             (29) % "~"        
    end      
end
