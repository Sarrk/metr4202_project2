%% Documentation:
% This script executes the series of commands necessary for METR4202
% Project 2. The libraries utilised include the kinect for matlab library
% ('kinect'), the CCFind library ('CCFind') and the RADOCC calibration
% library ('RADOCCToolbox').

% 'mex -setup' (Choose microsoft compiler) may need to be run first to
% ensure the code in the kinect library works.

% kinect
%   Code from Example.m modified into kinectTakePhoto.m

% RADOCCToolbox
%   Some code has been changed to allow for autonomous operation, toolbox
%   may not work as intended anymore but will work when utilised through
%   this script

% CCFind
%   Code is used as is

%% Initialisation
% Clean up workspace
close all
clear all
clc

% Go to the right directory and set up paths
cd('H:\Project 2');
addpath(genpath('H:\Project 2')); % Add all files and folders inside the toolboxes folder to the path

% Start up the kinect
oldDir = pwd;
cd 'H:\Project 2\toolboxes\kinect'; % Move to kinect function directory
compile_cpp_files('C:\Program Files\OpenNI'); % TURN BACK ON
cd(oldDir);

%% Color Calibration [ Task 1 ]
% This section will take photos until CCFind (inside colorCal) finds the
% colour chart and returns the colours, the colour info for Neutral 6.5 is
% displayed first and Orange Yellow second, but only Orange Yellow's colour
% data is saved

% Take photo and attempt to calibrate off it
while 1
    % Take 5 pictures
    colHand = kinectTakePhoto(5,1,'../../col_','bmp');
    [X, I] = getChart('col_', 'bmp', 5); % X is the (y,x) data for the colour chart

    % Double check that CCFind didn't just exhaust the images - i.e. found an X
    if ~isempty(X)
        break % Continue on and do a calibration
    end
end

% Now that we have locations of the colours, get the pixel values at the
% designated square.

% Display Task Results
clc;

% These two functions get the data for squares 21 and 12
[neutralRGB, neutralHSV, neutralYCRCB] = colorCal(X, I, 21)
[orangeRGB, orangeHSV, orangeYCRCB] = colorCal(X, I, 12)

pause();

close all;
delete('col_*') % Clean up the files
    
%% Camera Calibration [ Task 2 ]

% Take a lot of photos for camera calibration - dance yeah
calHand = kinectTakePhoto(60, 0.1, '../../cal_', 'bmp'); % 60 frames
[intrinsics, extrinsics] = cameraCal('cal_', 'bmp'); 

% Intrinsics is a struct with vector elements:
% fc [1x2]
% cc [1x2]
% alpha_c [1x1]
% kc [1x5]
% err [1x2]

% Extrinsics is a matrix with dimensions of [4x4xN] (N is the number of
% frames used in the calibration). Elements 1-3 


% Display Task Results
clc;
eval('intrinsics');
eval('extrinsics');

pause();

close all;
delete('cal_*') % Clean up the files

% not fully working
% undistort_image % Looks for an image called img.bmp in the pwd and saves the undistorted copy as img_rect.bmp
%                 Requires 'intrinsics' struct variable to be present


%% Localisation [ Task 4 ]

% Use caltag to get some points

while 1
    % Take a pictures
    tagHand = kinectTakePhoto(1, 2, '../../tag_', 'bmp'); % Take a photo of the tag frame
    I = imread('tag_1.bmp');
    [wPt,iPt] = caltag(I, 'caltag/test/output.mat', false ); % Note that iPt stores values as (y,x)
                                                             % wPt is the
                                                             % name of the
                                                             % point
                                                             % recordeded
                                                              
    close all % Keep it clean
    % Double check that caltag worked, i.e. filled wPt and iPt
    if ~isempty(wPt)
        break % Continue on
    end
end

% Plot the 'central frame' point onto the image
% We choose centre frame point as the point the first point that is detected when
% looking at the bottom left corner. - i.e. first in iPt
xpt1 = iPt(1,2);
ypt1 = iPt(1,1);

imshow(I);
hold on;
plot (xpt1, ypt1, 'ro', 'MarkerSize', 20);
plot (xpt1, ypt1, 'rx', 'MarkerSize', 5);

% Get a depth map photo - assumes the scene hasn't changed since the tag
% photo was taken
[xyz] = kinectTakeDepth;

% Get the depth images from the photo for the origin point
% The 640 - ... is a quick and dirty reversal the x pts of the image (the
% depth map wasn't adjusted when taken unike the photos
% The xo, yo, zo are mm positions relative to the the camera
xo = xyz(round(640 - xpt1), round(ypt1),1);
yo = xyz(round(640 - xpt1), round(ypt1),2);
zo = xyz(round(640 - xpt1), round(ypt1),3);

sprintf('Pose of the frame relative to the camera\n Roll is about the z axis, pitch is about the x and Yaw is about y axis\n');
sprintf('xPosition - yPosition, zPosition, Roll, Pitch, Yaw\n');
pos = [xo, yo, zo] % roll, pitch, yaw];

sprintf('tfw no rpy ;_;\n');