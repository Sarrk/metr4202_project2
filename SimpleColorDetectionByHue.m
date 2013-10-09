% Demo macro to very, very simple color detection in 
% HSV (Hue, Saturation, Value) color space.
% Requires the Image Processing Toolbox.  Developed under MATLAB R2010a.
% by ImageAnalyst

% Modified for METR4202 by Callum Sinclair

function SimpleColorDetectionByHue(fullImageFileName)

% Do some initialization stuff.
figure;

% Read in image into an array.
rgbImage = imread('img_27.bmp'); 

% Display the original image.
subplot(1, 1, 1);
imshow(rgbImage);
drawnow; % Make it display immediately.
title('Original Color Image'); 

% Convert RGB image to HSV
[hImage, sImage, vImage] = rgb2hsv(rgbImage);

% Assign the low and high thresholds for each color band.
% Take a guess at the values that might work for the user's image.
hueThresholdLow = 0;
hueThresholdHigh = graythresh(hImage);
saturationThresholdLow = graythresh(sImage);
saturationThresholdHigh = 1.0;
valueThresholdLow = graythresh(vImage);
valueThresholdHigh = 1.0;

% 	else
% 		% Use values that I know work for the onions and peppers demo images.
% 		hueThresholdLow = 0.10;
% 		hueThresholdHigh = 0.14;
% 		saturationThresholdLow = 0.4;
% 		saturationThresholdHigh = 1;
% 		valueThresholdLow = 0.8;
% 		valueThresholdHigh = 1.0;
% 	end

% Show the thresholds as vertical red bars on the histograms.


% Now apply each color band's particular thresholds to the color band
hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

% Display the thresholded binary images.
subplot(3, 4, 10);
imshow(hueMask, []);
title('=   Hue Mask', 'FontSize', fontSize);
subplot(3, 4, 11);
imshow(saturationMask, []);
title('&   Saturation Mask', 'FontSize', fontSize);
subplot(3, 4, 12);
imshow(valueMask, []);
title('&   Value Mask', 'FontSize', fontSize);
% Combine the masks to find where all 3 are "true."
% Then we will have the mask of only the red parts of the image.
yellowObjectsMask = uint8(hueMask & saturationMask & valueMask);
subplot(3, 4, 9);
imshow(yellowObjectsMask, []);
caption = sprintf('Mask of Only\nThe Yellow Objects');
title(caption, 'FontSize', fontSize);

	% Tell user that we're going to filter out small objects.
	smallestAcceptableArea = 100; % Keep areas only if they're bigger than this.
	message = sprintf('Note the small regions in the image in the lower left.\nNext we will eliminate regions smaller than %d pixels.', smallestAcceptableArea);
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		% User canceled so exit.
		return;
	end

	% Open up a new figure, since the existing one is full.
	figure;  
	% Maximize the figure. 
	set(gcf, 'Position', get(0, 'ScreenSize'));

	% Get rid of small objects.  Note: bwareaopen returns a logical.
	yellowObjectsMask = uint8(bwareaopen(yellowObjectsMask, smallestAcceptableArea));
	subplot(3, 3, 1);
	imshow(yellowObjectsMask, []);
	fontSize = 13;
	caption = sprintf('bwareaopen() removed objects\nsmaller than %d pixels', smallestAcceptableArea);
	title(caption, 'FontSize', fontSize);

	% Smooth the border using a morphological closing operation, imclose().
	structuringElement = strel('disk', 4);
	yellowObjectsMask = imclose(yellowObjectsMask, structuringElement);
	subplot(3, 3, 2);
	imshow(yellowObjectsMask, []);
	fontSize = 16;
	title('Border smoothed', 'FontSize', fontSize);

	% Fill in any holes in the regions, since they are most likely red also.
	yellowObjectsMask = uint8(imfill(yellowObjectsMask, 'holes'));
	subplot(3, 3, 3);
	imshow(yellowObjectsMask, []);
	title('Regions Filled', 'FontSize', fontSize);

	message = sprintf('This is the filled, size-filtered mask.\nNext we will apply this mask to the original RGB image.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		% User canceled so exit.
		return;
	end

	% You can only multiply integers if they are of the same type.
	% (yellowObjectsMask is a logical array.)
	% We need to convert the type of yellowObjectsMask to the same data type as hImage.
	yellowObjectsMask = cast(yellowObjectsMask, class(rgbImage)); 

	% Use the yellow object mask to mask out the yellow-only portions of the rgb image.
	maskedImageR = yellowObjectsMask .* rgbImage(:,:,1);
	maskedImageG = yellowObjectsMask .* rgbImage(:,:,2);
	maskedImageB = yellowObjectsMask .* rgbImage(:,:,3);
	% Show the masked off red image.
	subplot(3, 3, 4);
	imshow(maskedImageR);
	title('Masked Red Image', 'FontSize', fontSize);
	% Show the masked off saturation image.
	subplot(3, 3, 5);
	imshow(maskedImageG);
	title('Masked Green Image', 'FontSize', fontSize);
	% Show the masked off value image.
	subplot(3, 3, 6);
	imshow(maskedImageB);
	title('Masked Blue Image', 'FontSize', fontSize);
	% Concatenate the masked color bands to form the rgb image.
	maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);
	% Show the masked off, original image.
	subplot(3, 3, 8);
	imshow(maskedRGBImage);
	fontSize = 13;
	caption = sprintf('Masked Original Image\nShowing Only the Yellow Objects');
	title(caption, 'FontSize', fontSize);
	% Show the original image next to it.
	subplot(3, 3, 7);
	imshow(rgbImage);
	title('The Original Image (Again)', 'FontSize', fontSize);

	% Measure the mean HSV and area of all the detected blobs.
	[meanHSV, areas, numberOfBlobs] = MeasureBlobs(yellowObjectsMask, hImage, sImage, vImage);
	if numberOfBlobs > 0
		fprintf(1, '\n----------------------------------------------\n');
		fprintf(1, 'Blob #, Area in Pixels, Mean H, Mean S, Mean V\n');
		fprintf(1, '----------------------------------------------\n');
		for blobNumber = 1 : numberOfBlobs
			fprintf(1, '#%5d, %14d, %6.2f, %6.2f, %6.2f\n', blobNumber, areas(blobNumber), ...
				meanHSV(blobNumber, 1), meanHSV(blobNumber, 2), meanHSV(blobNumber, 3));
		end
	else
		% Alert user that no yellow blobs were found.
		message = sprintf('No yellow blobs were found in the image:\n%s', fullImageFileName);
		fprintf(1, '\n%s\n', message);
		uiwait(msgbox(message));
    end

return; % from SimpleColorDetection()
% ---------- End of main function ---------------------------------


%----------------------------------------------------------------------------
function [meanHSV, areas, numberOfBlobs] = MeasureBlobs(maskImage, hImage, sImage, vImage)
	[labeledImage numberOfBlobs] = bwlabel(maskImage, 8);     % Label each blob so we can make measurements of it
	if numberOfBlobs == 0
		% Didn't detect any yellow blobs in this image.
		meanHSV = [0 0 0];
		areas = 0;
		return;
	end
	% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
	blobMeasurementsHue = regionprops(labeledImage, hImage, 'area', 'MeanIntensity');   
	blobMeasurementsSat = regionprops(labeledImage, sImage, 'area', 'MeanIntensity');   
	blobMeasurementsValue = regionprops(labeledImage, vImage, 'area', 'MeanIntensity');   
	
	meanHSV = zeros(numberOfBlobs, 3);  % One row for each blob.  One column for each color.
	meanHSV(:,1) = [blobMeasurementsHue.MeanIntensity]';
	meanHSV(:,2) = [blobMeasurementsSat.MeanIntensity]';
	meanHSV(:,3) = [blobMeasurementsValue.MeanIntensity]';
	
	% Now assign the areas.
	areas = zeros(numberOfBlobs, 3);  % One row for each blob.  One column for each color.
	areas(:,1) = [blobMeasurementsHue.Area]';
	areas(:,2) = [blobMeasurementsSat.Area]';
	areas(:,3) = [blobMeasurementsValue.Area]';

	return; % from MeasureBlobs()
	
	
%----------------------------------------------------------------------------
% Function to show the low and high threshold bars on the histogram plots.
function PlaceThresholdBars(plotNumber, lowThresh, highThresh)
	% Show the thresholds as vertical red bars on the histograms.
	subplot(3, 4, plotNumber); 
	hold on;
	maxYValue = ylim;
	maxXValue = xlim;
	hStemLines = stem([lowThresh highThresh], [maxYValue(2) maxYValue(2)], 'r');
	children = get(hStemLines, 'children');
	set(children(2),'visible', 'off');
	% Place a text label on the bar chart showing the threshold.
	fontSizeThresh = 14;
	annotationTextL = sprintf('%d', lowThresh);
	annotationTextH = sprintf('%d', highThresh);
	% For text(), the x and y need to be of the data class "double" so let's cast both to double.
	text(double(lowThresh + 5), double(0.85 * maxYValue(2)), annotationTextL, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	text(double(highThresh + 5), double(0.85 * maxYValue(2)), annotationTextH, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	
	% Show the range as arrows.
	% Can't get it to work, with either gca or gcf.
% 	annotation(gca, 'arrow', [lowThresh/maxXValue(2) highThresh/maxXValue(2)],[0.7 0.7]);

	return; % from PlaceThresholdBars()


%----------------------------------------------------------------------------