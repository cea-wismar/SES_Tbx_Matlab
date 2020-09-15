classdef symbol < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here    
    properties
        Token
        Wert
        Pos        
    end
    
    methods        
        function obj = symbol(Token,Wert,Pos)          
           obj.Token = Token;
           obj.Wert  = Wert;
           obj.Pos   = Pos;           
        end
    end    
end

