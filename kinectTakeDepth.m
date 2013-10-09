function [XYZ] = kinectTakeDepth()
% Uses the kinect to take a real world depth map photo and returns three
% matrices of dimension N x M (the dimension of the photo). Note that this
% is stored (x,y), i.e X(x,y) will retrive the depth (x,y,z) of the pixel in the
% image at (x,y) pixels (eugh).

% Change to the directory
oldDir = pwd;
cd 'H:\Project 2\toolboxes\kinect'

% Configure the kinect
SAMPLE_XML_PATH='Config/SamplesConfig.xml';
KinectHandle=mxNiCreateContext(SAMPLE_XML_PATH);

% Warm up photo
I=mxNiPhoto(KinectHandle); I=permute(I,[3 2 1]);
XYZ=mxNiDepthRealWorld(KinectHandle);

X=XYZ(:,:,1); Y=XYZ(:,:,2); Z=XYZ(:,:,3);
maxZ=3000; Z(Z>maxZ)=maxZ; Z(Z==0)=nan;

for i=1:1 % Take 1 photo - sorry, no option to pass in how many you want here!

    % Take a photo (not sure if useful, discarded) and also depth photo
    mxNiUpdateContext(KinectHandle);
    I=mxNiPhoto(KinectHandle); I=permute(I,[3 2 1]);
    XYZ=mxNiDepthRealWorld(KinectHandle);
    
%    X=XYZ(:,end:-1:1,1); Y=XYZ(:,:,2); Z=XYZ(:,:,3); % Assign to x,y,z, also flip the X because that's how the kinect do.
%    maxZ=3000; Z(Z>maxZ)=maxZ; Z(Z==0)= 0; % Limit the range to 3m
    
end

% Stop the Kinect Process
mxNiDeleteContext(KinectHandle);

% Change back to the old process
cd(oldDir);

end
