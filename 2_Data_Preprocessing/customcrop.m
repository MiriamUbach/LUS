%% Crops the video frames and related masks into custom defined boundaries 
% Takes the ROI coordenates in the excel file Video_ROI.xlsx
clc;
clear;

% Input and output paths
folders = ["InputImg"; "OutPL"; "OutAL"; "OutBL"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_LungDataset\', folders);
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_LungDataset_crop\', folders);

% List of videos and ROI coordenates
vid = readtable('C:\Users\miri_\Desktop\Miriam_TFM\4_Codes\2_Data_Preprocessing\Video_ROI.xlsx');

for i = 1:length(vid.VideoName)
    % Load current dimensions
    currwidth = vid.width(i);
    currheight = vid.height(i);
    num_frames = vid.NumFrames(i);


    for frame=1:num_frames
        name = append(char(vid.VidIdentifyer(i)),'_',sprintf('%03d',frame));

        input1 = append(pathIn(1),'\',name,'.jpg');
        input2 = append(pathIn(2),'\',name,'_PL.png');
        input3 = append(pathIn(3),'\',name,'_AL.png');
        input4 = append(pathIn(4),'\',name,'_BL.png');

        output1 = append(pathOut(1),'\',name,'.jpg');
        output2 = append(pathOut(2),'\',name,'_PL.png');
        output3 = append(pathOut(3),'\',name,'_AL.png');
        output4 = append(pathOut(4),'\',name,'_BL.png');
        
        % Case where height and width is equal
        if currwidth == currheight
            copyfile (input1, output1)
            copyfile (input2, output2)
            copyfile (input3, output3)
            copyfile (input4, output4)
     
        % Case where height > width. We will preserve the width and crop 
        % the height.
        elseif currwidth < currheight
            Img1 = imread(input1);
            Img2 = imread(input2);
            Img3 = imread(input3);
            Img4 = imread(input4);

            % Definde cropping coordenates for the video
            ymin = vid.yMin(i);
            ymax = vid.yMax(i);

            % Crop height
            crop1 = Img1(ymin:ymax,:);
            crop2 = Img2(ymin:ymax,:);
            crop3 = Img3(ymin:ymax,:);
            crop4 = Img4(ymin:ymax,:);

            n = size(crop1);
            % Add horizontal padding if width and height no equal
            if n(1)>n(2)
                padding = ceil((n(1)-n(2))/2);
                finalsize = [0,padding];
                outImg1 = padarray(crop1,finalsize);
                outImg2 = padarray(crop2,finalsize);
                outImg3 = padarray(crop3,finalsize);
                outImg4 = padarray(crop4,finalsize);
                
                imwrite(outImg1,output1)
                imwrite(outImg2,output2)
                imwrite(outImg3,output3)
                imwrite(outImg4,output4)
            else
                imwrite(crop1,output1)
                imwrite(crop2,output2)
                imwrite(crop3,output3)
                imwrite(crop4,output4)        
            end
        
        % Case where height < width. We will preserve the height and crop 
        % the width.
        elseif currwidth > currheight
            Img1 = imread(input1);
            Img2 = imread(input2);
            Img3 = imread(input3);
            Img4 = imread(input4);

            % Definde cropping coordenates for the video
            xmin = vid.xMin(i);
            xmax = vid.xMax(i);
            ymin = vid.yMin(i);
            ymax = vid.yMax(i);
    
            % Crop height and width
            crop1 = Img1(ymin:ymax,xmin:xmax);
            crop2 = Img2(ymin:ymax,xmin:xmax);
            crop3 = Img3(ymin:ymax,xmin:xmax);
            crop4 = Img4(ymin:ymax,xmin:xmax);

            n = size(crop1);
            % Add vertical padding if width and height no equal
            if n(2)>n(1)
                padding = n(2)-n(1);
                finalsize = [padding,0];
                outImg1 = padarray(crop1,finalsize,'post');
                outImg2 = padarray(crop2,finalsize,'post');
                outImg3 = padarray(crop3,finalsize,'post');
                outImg4 = padarray(crop4,finalsize,'post');
                
                imwrite(outImg1,output1)
                imwrite(outImg2,output2)
                imwrite(outImg3,output3)
                imwrite(outImg4,output4)  
            else
                imwrite(crop1,output1)
                imwrite(crop2,output2)
                imwrite(crop3,output3)
                imwrite(crop4,output4)        
            end
        end
    end
end
    
   
%% Plot example process to add to the report

% List of videos and ROI coordenates
vid = readtable('C:\Users\miri_\Desktop\Miriam_TFM\4_Codes\2_Data_Preprocessing\Video_ROI.xlsx');

% Input and output paths
folders = ["InputImg"; "OutPL"; "OutAL"; "OutBL"];
ext = ["_027.jpg";"_027_PL.png";"_027_AL.png";"_027_BL.png"];
pathIn = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_LungDataset\', folders);
pathOut = append('C:\Users\miri_\Desktop\Miriam_TFM\1_Datasets\2_LungDataset_crop\', folders);

% EXAMPLE 1: CASE HEIGHT > WIDTH (Reg021 -> Reg-Grep-Normal)
% Images and masks to plot
name1 = append(pathIn,'\',char(vid.VidIdentifyer(109)),ext);
name2 = append(pathOut,'\',char(vid.VidIdentifyer(109)),ext);
% Input
Img1 = imread(name1(1));
PL1 = imread(name1(2));
AL1 = imread(name1(3));
BL1 = imread(name1(4));
BW=labeloverlay(Img1,PL1);
BW1=labeloverlay(BW,AL1,'Colormap','spring');
% Output
Img2 = imread(name2(1));
PL2 = imread(name2(2));
AL2 = imread(name2(3));
BL2 = imread(name2(4));
BW3=labeloverlay(Img2,PL2);
BW4=labeloverlay(BW3,AL2,'Colormap','spring');

% Coordenates
xmin = vid.xMin(109);
xmax = vid.xMax(109);
ymin = vid.yMin(109);
ymax = vid.yMax(109);

figure;
subplot(1,2,1)
imshow(BW1); title('(a) Original')
axis on
hold on;
% Plot cropping coordenates
plot([xmin,xmax],[ymin,ymin], 'w', 'LineWidth', 2);
plot([xmin,xmax],[ymax,ymax], 'w', 'LineWidth', 2);
% plot([xmin,xmin],[ymin,ymax], 'w', 'LineWidth', 2);
% plot([xmax,xmax],[ymin,ymax], 'w', 'LineWidth', 2);
subplot(1,2,2)
imshow(BW4); title('(b) Cropped and padded')
