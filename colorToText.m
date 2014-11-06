function [ out ] = colorToText( num )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

switch num
    case {1}
        out = 'red';
    case {2}
        out = 'green';
    case {3}
        out = 'white';
    case {4}
        out = 'blue';
    case {5}
        out = 'yellow';
    case {6}
        out = 'black';
    otherwise
        disp('bad label');
end

end

