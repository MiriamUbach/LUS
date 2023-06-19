%% Resize set of images
clc;
clear;

% Input and output paths
folders = ["InputImg"; "OutPL"; "OutAL"; "OutBL"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_3_LungDataset_augmented\', folders);
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_4_LungDataset_resized\', folders);

% Morfological structural element for dilation
se = strel('square',4);

for i=1:length(folders)
    if i==1
        % Load list of images
        imgs = dir(fullfile(pathIn(i),'*.jpg'));
        imgs = natsortfiles(imgs);
        n = length(imgs);
        % Resize [256 256], bilinear interpolation, antialiasin=true
        for frame=1:n
            currFrame = append(pathIn(i),'\',imgs(frame).name);
            InputImg = imread(currFrame);
            resizedImg = imresize(InputImg,[256 256],'bicubic',Antialiasing=true);
            targetImg = append(pathOut(i),'\',imgs(frame).name);
            imwrite(resizedImg,targetImg);
        end
    else
        % Load list of masks
        imgs = dir(fullfile(pathIn(i),'*.png'));
        imgs = natsortfiles(imgs);
        n = length(imgs);
        % Resize [256 256], bilinear interpolation, antialiasin=true and
        % apply dilation to the masks
        for frame=1:n
            currFrame = append(pathIn(i),'\',imgs(frame).name);
            InputImg = imread(currFrame);
            resizedImg = imresize(InputImg,[256 256],'bicubic',Antialiasing=true);
            dilatedImg = imdilate(resizedImg,se);
            targetImg = append(pathOut(i),'\',imgs(frame).name);
            imwrite(dilatedImg,targetImg);
        end
    end
end
