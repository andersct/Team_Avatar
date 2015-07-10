function [num] = buoyTypeToLabel(in)
%BUOYTYPETOLABEL Converts buoy type label to numerical label, -1 is invalid
%   Detailed explanation goes here

switch in
    case {'nun', 't', 'tall'}
        num = 1;
    case {'s', 'sphere'}
        num = 2;
    case {'n', 'negative'}
        num = 3;
    case {'b', 'bopper'}
        % for the bopper nun buoys we use for testing
        num = 4;
    otherwise
        num = -1;
end
    

end

