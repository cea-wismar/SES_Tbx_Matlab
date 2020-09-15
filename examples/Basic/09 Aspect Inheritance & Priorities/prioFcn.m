function [ outprio ] = prioFcn( prioVar,aspName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch prioVar
    
    case 1
        %chapterDEC is favoured
        if strcmp(aspName,'chapterDEC')
            outprio = 2;
        else
            outprio = 1;
        end
    case 2
        %structureDEC is favoured
        if strcmp(aspName,'structureDEC')
            outprio = 2;
        else
            outprio = 1;
        end


end

