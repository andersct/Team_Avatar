function destCell = messUpLabelFix(srcCell, destCell, startInd, endInd)

for i=startInd:endInd % this is the last picture
    destCell{i,1} = srcCell{i,1};
    destCell{i,2} = srcCell{i,2};
    destCell{i,3} = srcCell{i,3};
end

end