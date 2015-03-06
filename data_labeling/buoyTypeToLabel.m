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
    otherwise
        num = -1;
end
    

end

