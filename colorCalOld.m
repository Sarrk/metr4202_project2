close all;
clear all;

%% Task Description
% Return 3 vector variables: rgb = [1x3], hsv = [1x3], lab = [1x3]
% Do this for 21 (Neutral 6.5) and 12 (Orange Yellow)

%     15 
% 20 [21] 22

%      6
% 11 [12]
%     18

%% Functional Pre-stored values (i.e. variable-ish)

% Variances stored as decimal percentages
hVar = 90; %90
sVar = 0.20; %20
vVar = 0.25; %25

%% Pre-stored values
imgPath = 'H:\folder3\img_10.bmp';

% xriteRGB = [
%     [115 82 68]
%     [194 150 30]
%     [98 122 157]
%     [87 108 67]
%     [133 128 177]
%     [103 189 170]
%     [214 126 44]
%     [80 91 166]
%     [193 90 99]
%     [94 60 108]
%     [157 188 64]
%     [224 163 46] % 12
%     [56 61 150]
%     [70 148 73]
%     [175 54 60]
%     [231 199 31]
%     [187 86 149]
%     [8 133 161]
%     [243 243 242]
%     [200 200 200]
%     [160 160 160] % 21
%     [122 122 121]
%     [85 85 85]
%     [52 52 52]
%     ];

hsv12 = [39.4, 79.46, 87.84];  % degrees, percent, percent
hsv21 = [0.0 0.0 62.75];     % degrees, percent, percent

%% Load and prepare image

% 640 (x) x 480 (y) image
I = imread(imgPath); % Stored (y, x, [RGB]);

% Get a filter kernal for blurring
K = fspecial('gaussian');

% Save the original image and blur a copy a bit
Iorig = I;
I = imfilter(I, K);
I = imfilter(I, K);
I = imfilter(I, K);

Ihsv = rgb2hsv(I); % Stored (y, x, [HSV]);

% Convert to appropriate scales
Ihsv(:, :, 1) = Ihsv(:, :, 1) * 360; % Hue - degrees
Ihsv(:, :, 2) = Ihsv(:, :, 2) * 100; % Sat - percent
Ihsv(:, :, 3) = Ihsv(:, :, 3) * 100; % Val - percent

% Display image
figure;
imshow(I);
hold on;

I12 = zeros(480, 640);
I21 = zeros(480, 640);

%% Look for [12] - Orange Yellow

% Set actual values to look for
hAct = hsv12(1); % 0-360
sAct = hsv12(2); % 0-100
vAct = hsv12(3); % 0-100

% Begin checking
for y = 1:1:480 % Iterate across y pixels
    for x = 1:1:640 % Iterate across x pixels

        % Get the HSV values for this pt in the image
        h = Ihsv(y,x,1);
        s = Ihsv(y,x,2);
        v = Ihsv(y,x,3);

        % Check if hue is within variance 
        % NOTE: Hue is on a circular scale, there are two distances to the
        % actual, "forwards" and "backwards" on the circular scale. If
        % either distance is smaller than the variance (i.e. close enough
        % to the value) it is valid.
        hDist = abs(h - hAct);
        if (hDist <= hVar) || (abs(hDist - 360) <= hVar)
            
            % If the hue was good, check if the sat is in variance
            if (s <= (sAct + sVar*100)) && (s >= (sAct - sVar*100)) % +/- percent var (note the scale is already in percent)

                % If the hue and sat were good, check the val is in variance
                if (v <= (vAct + vVar*100)) && (v >= (vAct - vVar*100)) % +/- percent var (note, scale is also in percent)

                    %sprintf('Found hue (%i) (Actual: %i) at (x,y) = (%i, %i)\n', h, hAct, x, y);
                    % This point has passed the test - Plot it
                    plot(x,y, 'ro', 'MarkerSize', 5) % Plot point on the image
                    I12(y,x) = 1;

                end
            end
        end   
    end
end

%% Look for [21] - Neutral 6.5

% Set actual values to look for
hAct = hsv21(1); % 0-360
sAct = hsv21(2); % 0-100
vAct = hsv21(3); % 0-100

% Begin checking
for y = 1:1:480 % Iterate across y pixels
    for x = 1:1:640 % Iterate across x pixels

        % Get the HSV values for this pt in the image
        h = Ihsv(y,x,1);
        s = Ihsv(y,x,2);
        v = Ihsv(y,x,3);

        % Check if hue is within variance 
        % NOTE: Hue is on a circular scale, there are two distances to the
        % actual, "forwards" and "backwards" on the circular scale. If
        % either distance is smaller than the variance (i.e. close enough
        % to the value) it is valid.
        hDist = abs(h - hAct);
        if (hDist <= hVar) || (abs(hDist - 360) <= hVar)
            
            % If the hue was good, check if the sat is in variance
            if (s <= (sAct + sVar*100)) && (s >= (sAct - sVar*100)) % +/- percent var (note the scale is already in percent)

                % If the hue and sat were good, check the val is in variance
                if (v <= (vAct + vVar*100)) && (v >= (vAct - vVar*100)) % +/- percent var (note, scale is also in percent)

%                     sprintf('Found hue (%i) (Actual: %i) at (x,y) = (%i, %i)\n', h, hAct, x, y);
%                     This point has passed the test - Plot it
                    plot(x,y, 'bo', 'MarkerSize', 5) % Plot point on the image
                    I21(y,x) = 1;

                end
            end
        end   
    end
end


%%