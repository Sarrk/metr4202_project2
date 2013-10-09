function [figureHandle] = kinectTakePhoto(numPhotos, waitTime, fileName, format)
% Wait time is in seconds, format e.g. "bmp"
% The number of the photo is appended onto the fileName
% The depth is the same but it is fileName with D appended on, then the
% number appended too
% e.g. for 'img_' and 'bmp' -> img_1.bmp & img_D1.tiff
% The depth map always comes out as a .tiff

% Code snippet for plotting depth map
%subplot(1,2,2),h2=imshow(D,[0 9000]); colormap('jet');

%% Initialise
SAMPLE_XML_PATH='Config/SamplesConfig.xml';

oldDir = pwd;
cd 'H:\Project 2\toolboxes\kinect'

%% Start the Kinect Process
KinectHandles=mxNiCreateContext(SAMPLE_XML_PATH);

% Quick hack to get a square-ish figure for photos
x = ceil(sqrt(numPhotos));
y = ceil(numPhotos/x);

% Create figure
figureHandle = figure;
subplot(x,y,1);

% Warm up the camera with 3 dummy photos
for i=1:3
    % Initial delay for the photo - handy for single photos
    pause(1);
    
    % Take colour photo and depth photo
    I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
    D=mxNiDepth(KinectHandles); D=permute(D,[2 1]);
    mxNiUpdateContext(KinectHandles);
    
end

% Take some photos
for i=1:numPhotos
    % Initial delay for the photo - handy for single photos
    pause(waitTime);
    
    % Take colour photo and depth photo
    I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
    D=mxNiDepth(KinectHandles); D=permute(D,[2 1]);
    mxNiUpdateContext(KinectHandles);
    
    % Flip images to properly orientate ('looking out' of the camera)
    I = I(:, end:-1:1,:);
    D = D(:, end:-1:1,:);

    % Display the colour photo on the series of photos
    subplot(x,y,i);
    imshow(I);
    drawnow;
    
    % Save the images
    imwrite(I, strcat(fileName, num2str(i), '.', format));
    imwrite(D, strcat(fileName, 'D', num2str(i), '.', 'tiff'));
    
end

% Stop the Kinect Process
mxNiDeleteContext(KinectHandles);

cd(oldDir);


end

