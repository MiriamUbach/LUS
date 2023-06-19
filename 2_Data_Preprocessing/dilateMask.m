%% Dilate masks AL PL and BL masks
clc;
clear;

% Starting input filepath
folders = ["InputImg"; "OutPL"; "OutAL"; "OutBL"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_OriginalData\', folders);

% Output filepath
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_LungDataset\',folders);
sufix = [".jpg"; "_PL.png";"_AL.png"; "_BL.png"];

% List of videos
vid = readtable('C:\Users\miri_\Desktop\Miriam_TFM\4_Codes\2_Data_Preprocessing\Video_ROI.xlsx');
n = length(vid.VideoName);

for idx=1:length(folders)
    if idx==1
        for i=1:n
            num_frames = vid.Num_Frames(i);
            for num=1:num_frames
                input_name = append(pathIn(idx),'\',vid.VideoName(i),'_',num2str(num),sufix(idx));
                output_name = append(pathOut(idx),'\',vid.VidIdentifyer(i),'_',sprintf('%03d',num),sufix(idx));
                copyfile (input_name, output_name)
            end
        end
    else
        for i=1:n
            num_frames = vid.Num_Frames(i);
            for num=1:num_frames
                input_name = append(pathIn(idx),'\',vid.VideoName(i),'_',num2str(num),sufix(idx));
                output_name = append(pathOut(idx),'\',vid.VidIdentifyer(i),'_',sprintf('%03d',num),sufix(idx));
                mask = imread(input_name);
                se = strel('disk',4);
                dilate = imdilate(mask,se);
                imwrite(dilate, output_name);
            end
        end
    end
end


figure;
imshow(mask), title('Original')

imshow(img,[0,3]), title('Original')
figure;
imshowpair(img,Dil1), title('Original')

imshow(Dil1,[0,3]), title('Dilated')


