%% Generate augmentations of the original images and masks
clc;
clear;

% Input and output paths
folders = ["InputImg"; "OutPL"; "OutAL"; "OutBL"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_2_LungDataset_crop\', folders);
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_3_LungDataset_augmented\', folders);
extension = [".jpg";"_PL.png";"_AL.png";"_BL.png"];
extension2 = ["_flip";"_bright1";"_bright2";""];

% List of videos and ROI coordenates
vid = readtable('C:\Users\miri_\Desktop\Miriam_TFM\4_Codes\2_Data_Preprocessing\Video_ROI.xlsx');

% Define factors for different basic transformations
factor1 = 2;                                            %flip horizontal
factor2 = [0.8 1.2];                                    %change brightness (by multipying)

% Start loop for each video
for i=1:length(vid.VideoName)
    currVid = char(vid.VidIdentifyer(i));
    numFrames = vid.NumFrames(i);
    
    % Start loop for each frame
    for frame=1:numFrames
        currFrame = append(pathIn,'\',currVid,'_',sprintf('%03d',frame),extension);
        outFrame = append(pathOut,'\',currVid,'_',sprintf('%03d',frame));

        % Augment images and masks
        for img=1:length(extension) 
            % Image
            if img==1
                [aug1,aug2,aug3] = augment_curr_image(currFrame(img),factor1,factor2);

                outFrame1 = append(outFrame(img),extension2(1),extension(img));
                outFrame2 = append(outFrame(img),extension2(2),extension(img));
                outFrame3 = append(outFrame(img),extension2(3),extension(img));
                outFrame4 = append(outFrame(img),extension2(4),extension(img));

                copyfile (currFrame(img),outFrame4);
                imwrite(aug1,outFrame1)
                imwrite(aug2,outFrame2)
                imwrite(aug3,outFrame3)
            else
                [aug1] = augment_curr_image(currFrame(img),factor1,factor2);

                outFrame1 = append(outFrame(img),extension2(1),extension(img));
                outFrame2 = append(outFrame(img),extension2(2),extension(img));
                outFrame3 = append(outFrame(img),extension2(3),extension(img));
                outFrame4 = append(outFrame(img),extension2(4),extension(img));

                copyfile (currFrame(img),outFrame4);
                imwrite(aug1,outFrame1)
                copyfile (currFrame(img),outFrame2);
                copyfile (currFrame(img),outFrame3);
            end
        end
    end
end
 

function [aug1,aug2,aug3] = augment_curr_image(inputImg,factor1,factor2)
% Generates the following augmentations from the input image:
%   - Horizontal flip = factor1
%   - Change of brightness (product) = factor2
    original_img = imread(inputImg); 
    aug1 = flip(original_img,factor1);        
    aug2 = original_img*factor2(1);
    aug3 = original_img*factor2(2);
end

