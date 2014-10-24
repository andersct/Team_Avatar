function [num, response] = getColor()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

while(true)
    response = input('Color? r/g/w/u/y/b: ', 's');
    switch response
        case {'r', 'red'}
            num = 1;
            break;
        case {'g', 'green'}
            num = 2;
            break;
        case {'w', 'white'}
            num = 3;
            break;
        case {'u', 'blue'}
            num = 4;
            break;
        case {'y', 'yellow'}
            num = 5;
            break;
        case {'b', 'black'}
            num = 6;
            break;
        otherwise
            disp('bad label');
    end
end

end

