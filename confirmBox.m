function response = confirmBox()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

while(true)
    response = input('Save box? y/n: ', 's');
    try
        if response == 'y' || response == 'n'
            break;
        end
    catch
        display('Error in input format')
    end
end

end

