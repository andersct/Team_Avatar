function [num, response] = getBuoyType()
%getBuoyType Asks for user input of buoy type
%   Detailed explanation goes here

while(true)
    response = input('Buoy type? (t|tall)/(s|sphere)/(n|negative)/(b|bopper): ', 's');
    num = buoyTypeToLabel(response);
    if -1 ~= num
        break;
    else
        disp('bad label');
    end
end

end

