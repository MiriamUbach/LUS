%% Extract key frames form ultrasound videos 
% By calculating the correlation between the current frame and the next 
% one. Frames with a correlation lower than 1% are discarted.
clc;
clear;
close all;

%%
% Define a starting folder where videos are
fprintf('Please choose a folder with the videos');
start_path = uigetdir();       
myVideos = dir(fullfile(start_path, '*.avi'));            %List of videos

% Loop through all videos
for i = 82:length(myVideos)
    filename = myVideos(i).name;
    file = fullfile(myVideos(i).folder,myVideos(i).name);
    [filepath,name,ext] = fileparts(file);
    % Define final folder for the key frames
    final_path = 'G:\Otros ordenadores\My Computer\Keyframes\';%'C:\Users\Ferran\Documents\TFM_MiriamUbach_LungUS\Keyframes\';
    mkdir(final_path,name);
   
    vid = VideoReader(strcat(file));                      %Load current video
    fprintf(1, 'Now reading %s\n', filename);

    idx0 = 1;                                             %Index frame0
    idx1 = 2;                                             %Index frame1
    
    frame0 = read(vid,idx0);                              %Retrieve data from video: current frame
    frame1 = read(vid,idx1);                              %Retrieve data from video: next frame
    
    T = vid.NumFrames;                                    %Number of frames of the video

    for idx1 = 2:T
        if size(frame0,3)==3                              %Convert RGB to grayscale
            frame0 = rgb2gray(frame0);       
        end 
        if size(frame1,3)==3                              %Convert RGB to grayscale
            frame1 = rgb2gray(frame1);       
        end 

        Y(idx1,1) = corr2(frame0,frame1);                 %Calculate histogram difference between the two frames
       
        if (Y(idx1,1)<0.97) && (idx1<T)                   %Correlation  is greater than 1% and is not the last frame
            name0 = append(final_path,name,'\frame',num2str(idx0),'.jpg');    
            imwrite(imadjust(((frame0))), name0);         %Select frame0 as a key frame 
            frame0 = frame1;
            frame1 = read(vid,idx1+1);
            idx0 = idx1;
            idx1 = idx1+1;
        elseif (Y(idx1,1)>=0.97) && (idx1<T)              %Correlation  is less than 1% and is not the last frame
            frame1 = read(vid,idx1+1);                    %Do not select key frame
            idx1 = idx1+1;
        elseif (Y(idx1,1)<0.97) && (idx1==T)              %Correlation  is greater than 1% and is the last frame
            name0 = append(final_path,name,'\frame',num2str(idx0),'.jpg');    
            name1 = append(final_path,name,'\frame',num2str(idx1),'.jpg');
            imwrite(imadjust(((frame0))), name0);          %Select frame0 and frame 1 as a key frame
            imwrite(imadjust(((frame1))), name1);         
        elseif (Y(idx1,1)>=0.97) && (idx1==T)             %Correlation  is less than 1% and is the last frame 
            name0 = append(final_path,name,'\frame',num2str(idx0),'.jpg');    
            imwrite(imadjust(((frame0))), name0);         %Select frame0 as a key frame 
        end
    end
end