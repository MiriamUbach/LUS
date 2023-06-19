%% Create a new set --> Blind Set
% Take the list of videos BlindSetRefference.xls created in 
% RandomSplitVid.m and creates% list to a new folder, creating like this the Blind Set (Hide Out Set)
clc;
clear;

% Input and output paths
folders = ["InputImg";"OutPL"; "OutAL"; "OutBL";"OutGT_4class"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_4_LungDataset_resized\', folders);
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_5_LungPreprocessedDataset\1_TrainingSet\', folders);

% Load the list of randomly selected videos
Selected = readtable('BlindSetRefference.xls');
n = length(Selected.VideoName);

% Move the images
numFilesProcessed = 0;

for i=1:n
    ContainString = Selected.VidIdentifyer(i);
    for j=1:length(folders)
        thisFolder = append(pathIn(j),'\');
        outFolder = pathOut(j);
        if j==1
            imgNames = dir(fullfile(pathIn(j),'*.jpg'));
            numImg = length(imgNames);
            for k=1:numImg
                thisFileName = append(thisFolder,imgNames(k).name);
                if contains(thisFileName, ContainString)
                    copyfile(thisFileName,outFolder)
                end
                numFilesProcessed = numFilesProcessed + 1;
            end
        else
            imgNames = dir(fullfile(pathIn(j),'*.png'));
            numImg = length(imgNames);
            for k=1:numImg
                thisFileName = append(thisFolder,imgNames(k).name);
                if contains(thisFileName, ContainString)
                    copyfile(thisFileName,outFolder)
                end
                numFilesProcessed = numFilesProcessed + 1;
            end
        end
    end
end