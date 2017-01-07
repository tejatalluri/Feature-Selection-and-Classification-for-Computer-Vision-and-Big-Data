warning off;
close all;
clear all;
clc;

filename=uigetfile('*.mp4;*.avi')
FN=filename;
%% reading a video file

mov = VideoReader(filename);
FRate=mov.FrameRate;

%%  Defining Output folder as 'snaps'

opFolder = fullfile(cd, 'snaps');

%% if  not existing 

if ~exist(opFolder, 'dir')
%% make directory & execute as indicated in opfolder variable
mkdir(opFolder);
end
%% getting no of frames

numFrames = mov.NumberOfFrames;

%% setting current status of number of frames written to zero

numFramesWritten = 0;

%% Files = dir('*.jpg');
%% camshift algorithm
%% for loop to traverse & process from frame '1' to 'last' frames 
for t = 1:numFrames 
currFrame = read(mov, t);    %reading individual frames
opBaseFileName = sprintf('%d.jpg', t);
opFullFileName = fullfile(opFolder, opBaseFileName);
imwrite(currFrame, opFullFileName, 'jpg');   %saving as 'png' file
%indicating the current progress of the file/frame written
progIndication = sprintf('Wrote frame %4d of %d.', t, numFrames);
disp(progIndication);
numFramesWritten = numFramesWritten + 1;
end      %end of 'for' loop


path='\snaps\'; % Path for the SNAPS folder
str2 = '.jpg';

for i = 1:30
    name = strcat(num2str(i),str2);
    a = imread(strcat(path,name));
    figure(1),imshow(a);
    pause(0.0001);
    title('Input Video');
end

  %% Detect Calibration
  cd snaps
 for i = 1:30
      imageFileName = sprintf('%d.jpg', i);
      imageFileNames{i} =fullfile('snaps',imageFileName);
 end
   [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
    imageFileNames = imageFileNames(imagesUsed);
  for i = 1:numel(imageFileNames)
      I = imread(imageFileNames{i});
      figure
      imshow(I); hold on; plot(imagePoints(:,1,i), imagePoints(:,2,i), 'ro');
  end
  numImages = 4;
images1 = cell(1, numImages);
images2 = cell(1, numImages);
for i = 1:numImages
    images1{i} = fullfile('snaps',sprintf('%d.jpg',i));
    images2{i} = fullfile('snaps',sprintf('%d.jpg',i));
end
[imagePoints,boardSize,pairsUsed] = ...
    detectCheckerboardPoints(images1,images2);
images1 = images1(pairsUsed);
figure;
for i = 1:numel(images1)
      I = imread(images1{i});
      figure
      imshow(I);
      hold on;
      plot(imagePoints(:,1,i,1),imagePoints(:,2,i,1),'ro');
end
annotation('textbox',[0 0.9 1 0.1],'String','',...
    'EdgeColor','none','HorizontalAlignment','center')
images2 = images2(pairsUsed);
figure;
for i = 1:numel(images2)
      I = imread(images2{i});
     figure
      imshow(I);
      hold on;
      plot(imagePoints(:,1,i,2),imagePoints(:,2,i,2),'ro');
end
annotation('textbox',[0 0.9 1 0.1],'String','',...
    'EdgeColor','none','HorizontalAlignment','center')