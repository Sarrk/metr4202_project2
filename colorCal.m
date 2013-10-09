function [ rgb, hsv, ycrcb ] = colorCal( X, I, colorNum )
% This function extracts the colour information given the centre position
% of a colour square on an x-rite colour chart (X matrix), the image
% corresponding to the X matrix and the desired color square (designations
% based off the x-rite chart).

% Returns color data in the rgb, hsv and ycrcb color spaces.

% RGB is in the range 0-255 for [R G B] channels, 8 bit numbers
% HSV is in degrees from 0 to 360 (8 bit) for the H channel, and in decimal (double) percent for H
% and V channels, 0 - 1
% YCrCb has Y in the range 16-235 and Cb and Cr in the range 16-240, 8 bit numbers

% Initialise the return variables
rgb = zeros(1,3);
hsv = zeros(1,3);
ycrcb = zeros(1,3);

% Plot the chart and the location of the pixel
% The x indicates the location of the  pixel that was taken
colorHand = figure;
imshow(I);
hold on;
plot(X(colorNum, 2), X(colorNum, 1), 'bo', 'MarkerSize', 20);
plot(X(colorNum, 2), X(colorNum, 1), 'wx', 'MarkerSize', 5);

% Get pixel data
RGBMat = uint8(I(X(colorNum,1), X(colorNum,2), :)); % Store as 1x1 'image'

% Pull out rgb data
rgb(1) = RGBMat(1,1,1);
rgb(2) = RGBMat(1,1,2);
rgb(3) = RGBMat(1,1,3);

% Convert to HSV
HSVMat = rgb2hsv(RGBMat);

% Pull out hsv data
hsv(1) = uint8(HSVMat(1,1,1) * 360);
hsv(2) = HSVMat(1,1,2);
hsv(3) = HSVMat(1,1,3);

% Convert to YCrCb
YCRCBMat = rgb2ycbcr(RGBMat);

% Pull out YCrCb data
ycrcb(1) = YCRCBMat(1,1,1);
ycrcb(2) = YCRCBMat(1,1,2);
ycrcb(3) = YCRCBMat(1,1,3);

end

