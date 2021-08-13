function newFPES = ecGeneralflatten(PES)
%flatten a PES
%   general function for EC

% flattening is a class method of fpes, there fore "PES" is already of type
% "fpes" ;-)
    newFPES = PES;
    newFPES.flatten;
end