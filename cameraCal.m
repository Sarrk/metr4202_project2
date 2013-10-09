function [ intrinsics, extrinsics ] = cameraCal( fileName, fileFormat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Read in images ('Read Images')
calib_name = fileName;
format_image = fileFormat;

% Call the toolbox function to read in images
ima_read_calib;

%% Get the grid corners ('Grid Corner Extraction')
ima_numbers = [];
dont_ask = 1; % Don't ask

dX = 30; % Magic number - The predetermined size of the grid
dY = 30; % 

click_calib; % Call the toolbox function to process the images

%% Get the calibration data ('Calibration')
go_calib_optim; % Call the toolbox function to get the calibration data

% Initialise the struct for returning
intrinsics = struct('fc', fc', 'cc', cc', 'alpha_c', alpha_c, 'kc', kc', 'err', err_std');
                    
%% Get the extrinsics

% Init extrinsic data structure
tfMat = zeros(4,4,n_ima);

for i = 1:n_ima

    tfMat(1:3, 1:3, i) = eval(['Rc_' num2str(i)]);
    tfMat(1:3, 4, i) = eval(['Tc_' num2str(i)]);
    tfMat(4, 1:4, i) = [0 0 0 1];

end

% Fill the struct
extrinsics = struct('transformation_matrices', tfMat);

end

