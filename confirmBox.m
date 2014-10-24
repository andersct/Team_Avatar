function response = confirmBox()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

while(true)
    response = input('Save box? y/n: ', 's');
    if response == 'y' || response == 'n'
        break;
    end
end

end

