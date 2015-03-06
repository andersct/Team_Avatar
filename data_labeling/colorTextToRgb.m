function [r, g, b] = colorTextToRgb(in)
%colorTextToRgb Converts color label to RGB for visualization
%   Detailed explanation goes here

r=0;
g=0;
b=0;

switch in
    case {'r', 'red', 1}
        r=1;
    case {'g', 'green', 2}
        g=1;
    case {'w', 'white', 3}
        r=1;
        g=1;
        b=1;
    case {'u', 'blue', 4}
        b=1;
    case {'y', 'yellow', 5}
        r=1;
        g=1;
    case {'b', 'black', 6}
    case {'n', 'negative', 7}
        % magenta
        r = 1;
        b = 1;
    otherwise
        disp('bad label');
end
    
end

