function [ X, I ] = getChart( filePath, fileFormat, numImages )
% Uses the CCFind toolbox to 

% Keep iterating over the images until CCFind works on one
for i = 1:numImages
    I = imread(strcat(filePath, num2str(i), '.', fileFormat));
    X = CCFind(I); % Returns the pixel location of the centre of the color squares, (y, x)
    
    % If CCFind worked, X will contain something, so we can stop, else keep
    % going
    if ~isempty(X)
        break
    end
    
end

end

