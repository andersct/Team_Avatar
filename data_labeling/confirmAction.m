function response = confirmAction(varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

numvarargs = length(varargin);
if length(varargin) > 1
    error('confirmAction:TooManyInputs', ...
        'requires at most 1 optional inputs');
end
optargs = {'Save box? y/n: '};
optargs(1:numvarargs) = varargin;
[message] = optargs{:};

while(true)
    response = input(message, 's');
    try
        if response == 'y' || response == 'n'
            break;
        end
    catch
        display('Error in input format')
    end
end

end

