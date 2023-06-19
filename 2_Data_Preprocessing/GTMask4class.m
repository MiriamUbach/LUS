%% Generate a 4-class GT mask containing AL PL and BL masks
% Classes: 0-background / 80-PL mask / 150-AL mask / 250-BL mask
clc;
clear;

% Input and output paths
folders = ["OutPL"; "OutAL"; "OutBL"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_4_LungDataset_resized\', folders);
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_4_LungDataset_resized\OutGT_4class');
PL = dir(fullfile(pathIn(1), '*.png'));
AL = dir(fullfile(pathIn(2), '*.png'));
BL = dir(fullfile(pathIn(3), '*.png'));

n = numel(PL);
for i=1:n
    % Current mask names
    currPL = append(pathIn(1),'\',PL(i).name);
    currAL = append(pathIn(2),'\',AL(i).name);
    currBL = append(pathIn(3),'\',BL(i).name);
    % Output mask name
    currGT = currPL;
    currGT = replace(currGT,'_PL.png','_GT.png');
    currGT = replace(currGT,'OutPL','OutGT_4class');
    
    % Load masks
    I1 = imread(currPL);
    I2 = imread(currAL);
    I3 = imread(currBL);
    maskPL = uint8(I1*80);
    maskAL = uint8(I2*150);
    maskBL = uint8(I3*250);
    % Combine the 3 masks preserving the indexes for each class
    newMask = maskAL;                % Start with mask AL
    index = (maskBL ~= 0);           % Index where BL is nonzero
    newMask(index) = maskBL(index);  % Overwrite with nonzero values of BL
    index = (maskPL ~= 0);           % Index where mask PL is nonzero
    newMask(index) = maskPL(index);  % Overwrite with nonzero values of mask PL
    imwrite(newMask, currGT);
end

