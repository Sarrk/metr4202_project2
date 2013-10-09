%%% INPUT THE IMAGE FILE NAME:

fc = intrinsics.fc';
cc = intrinsics.cc';
kc = intrinsics.kc';
alpha_c = intrinsics.alpha_c;

KK = [fc(1) alpha_c*fc(1) cc(1);0 fc(2) cc(2) ; 0 0 1];

%%% Compute the new KK matrix to fit as much data in the image (in order to
%%% accomodate large distortions:
r2_extreme = (nx^2/(4*fc(1)^2) + ny^2/(4*fc(2)^2));
dist_amount = 1; %(1+kc(1)*r2_extreme + kc(2)*r2_extreme^2);
fc_new = dist_amount * fc;

KK_new = [fc_new(1) alpha_c*fc_new(1) cc(1);0 fc_new(2) cc(2) ; 0 0 1];

disp('Program that undistorts images');
disp('The intrinsic camera parameters are assumed to be known (previously computed)');

fprintf(1,'\n');
     
image_name = 'img';

format_image2 = 'bmp';

ima_name = [image_name '.' format_image2];
    
I = imread(ima_name);
  
%% UNDISTORT THE IMAGE:

fprintf(1,'Computing the undistorted image...')

[I2] = rect(double(I),eye(3),fc,cc,kc,alpha_c,KK_new);

fprintf(1,'done\n');

figure(3);
image(I2);
title('Undistorted image - Stored in array I2');
drawnow;

%% SAVE THE IMAGE IN FILE:

ima_name2 = [image_name '_rect.' format_image2];

fprintf(1,['Saving undistorted image under ' ima_name2 '...']);

imwrite(uint8(I2), strcat(ima_name2, '.', format));

fprintf(1,'done\n');
