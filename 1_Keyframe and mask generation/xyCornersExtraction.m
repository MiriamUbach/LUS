% Save XY coordinates of the first frame of each video, coresponding to the 
% corners of the ultrasound image.
clear;
close all; 
clc;

%%
% Initialise variables
%xyInfo = table;
repeatFlag = 1;

% Select the video frame 
[filename,filepath] = uigetfile('G:\.shortcut-targets-by-id\1vfL1xUzVdG4GJkJbT5ufhYMPY2Pt-UP4\Miriam_and_Ferran\Keyframes\*.jpg', 'Please choose a file');

% Start loop
for row = 1:6                         %For 155 videos (1st frame of each video) 
    close all;
    if repeatFlag
        SelectedInput = strcat(filepath,filename);
    else
        [filename,filepath] = uigetfile('G:\.shortcut-targets-by-id\1vfL1xUzVdG4GJkJbT5ufhYMPY2Pt-UP4\Miriam_and_Ferran\Keyframes\*.jpg', 'Please choose a file');
        SelectedInput = strcat(filepath,filename);
    end
    
    originalInput = im2gray(imread(SelectedInput));
    figure(1); drawnow; hold on;
    imshow(originalInput); title(filename)
    flag = true;

    % Extract the 4 corner points
    while flag
        [~, xCorners, yCorners] = roipoly();
        numberOfVertices = length(xCorners);
        if numberOfVertices ~= 5
            userPrompt = sprintf('You clicked %d points.\nPlease click exactly 4 point only.', numberOfVertices-1);
            uiwait(msgbox(userPrompt));
        else
            flag = false;
        end
    end
    figure(1); hold on;
    plot([xCorners(1) xCorners(2) xCorners(3) xCorners(4) xCorners(1)], [yCorners(1) yCorners(2) yCorners(3) yCorners(4) yCorners(1)], 'linewidth', 3, 'color', [1 0 1]); % Top line
    
    % Save name of the video and corner information of the 1st frame (Xpoints and Ypoints)
    splitPath = regexp(filepath,'\\','split');
    xyInfo(row,:) = table(splitPath(6), xCorners(1), xCorners(2), xCorners(3), xCorners(4), xCorners(5), yCorners(1), yCorners(2), yCorners(3), yCorners(4), yCorners(5));
    xyInfo.Properties.VariableNames = {'Video_Name','xCorner1','xCorner2','xCorner3','xCorner4','xCorner5','yCorner1','yCorner2','yCorner3','yCorner4','yCorner5'};
    
    repeatFlag = input('do you want to repeat the corners? 0/1');
end
