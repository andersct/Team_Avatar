function [r, g, b] = colorTextToRgb(string)
%colorTextToRgb Converts color label to RGB for visualization
%   Detailed explanation goes here

r=0;
g=0;
b=0;

switch string
    case {'r', 'red'}
        r=1;
    case {'g', 'green'}
        g=1;
    case {'w', 'white'}
        r=1;
        g=1;
        b=1;
    case {'u', 'blue'}
        b=1;
    case {'y', 'yellow'}
        r=1;
        g=1;
    case {'b', 'black'}
    case {'n', 'negative'}
        % magenta
        r = 1;
        b = 1;
    otherwise
        disp('bad label');
end
    
end

