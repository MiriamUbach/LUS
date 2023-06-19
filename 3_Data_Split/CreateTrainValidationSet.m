%% Create a new set --> Test Set
% Create a Train set and a Validation set by random splitting the remaining 
% frames after splitting the Blind Set.
% 70% Training set
% 30% Validation set
clc;
clear;

% Input and output paths
folders = ["InputImg";"OutPL"; "OutAL"; "OutBL";"OutGT_4class"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_4_LungDataset_resized\', folders);
pathOutTrain = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_5_LungPreprocessedDataset\1_TrainingSet\', folders);
pathOutVal = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_5_LungPreprocessedDataset\2_ValidationSet\', folders);

% List of frames
fileListImg = dir(fullfile(pathIn(1),'*.jpg')); 
nImg = numel(fileListImg);
for i=1:nImg
    Imgs(i,1) = append(pathIn(1),'\',fileListImg(i).name);
    Masks(i,1) = replace(Imgs(i,1),'.jpg','_PL.png');
    Masks(i,1) = replace(Masks(i,1),'InputImg','OutPL');
    Masks(i,2) = replace(Imgs(i,1),'.jpg','_AL.png');
    Masks(i,2) = replace(Masks(i,2),'InputImg','OutAL');
    Masks(i,3) = replace(Imgs(i,1),'.jpg','_BL.png');
    Masks(i,3) = replace(Masks(i,3),'InputImg','OutBL');
    Masks(i,4) = replace(Imgs(i,1),'.jpg','_GT.png');   
    Masks(i,4) = replace(Masks(i,4),'InputImg','OutGT_4class');
end

% Create random indexes for randomly selecting 70% of the images for each 
% class (Cov, Pneu, PnThorax, Reg, Uninf)
train_percent = 0.7;
train_idx = crossvalind('HoldOut', nImg, train_percent);

% Split the data
train_images = Imgs(~train_idx,1);
train_masks = Masks(~train_idx,:);
val_images = Imgs(train_idx,1);
val_masks = Masks(train_idx,:);

% Move the images to training folder
numTrainProcessed = 0;
for j=1:length(train_images)
    movefile(train_images(j),pathOutTrain(1));
    movefile(train_masks(j,1),pathOutTrain(2));
    movefile(train_masks(j,2),pathOutTrain(3));
    movefile(train_masks(j,3),pathOutTrain(4));
    movefile(train_masks(j,4),pathOutTrain(5));
    numTrainProcessed = numTrainProcessed + 1;
end

% Move the images to validation folder
numValProcessed = 0;
for k=6535:length(train_images)
    movefile(val_images(k),pathOutVal(1));
    movefile(val_masks(k,1),pathOutVal(2));
    movefile(val_masks(k,2),pathOutVal(3));
    movefile(val_masks(k,3),pathOutVal(4));
    movefile(val_masks(k,4),pathOutVal(5));
    numValProcessed = numValProcessed + 1;
end
