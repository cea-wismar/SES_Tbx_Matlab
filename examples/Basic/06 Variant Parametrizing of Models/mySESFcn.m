function [ out ] = mySESFcn( varVariant )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if varVariant == 1
    out = 'HelloWorld';
elseif varVariant == 2
    out = 'HelloSky';
else
    out = 'error';
end

end