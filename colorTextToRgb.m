function [r, g, b] = colorTextToRgb(string)
%UNTITLED2 Summary of this function goes here
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
    otherwise
        disp('bad label');
end
    
end

