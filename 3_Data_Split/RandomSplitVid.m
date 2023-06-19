%%
clc;
clear;

%% Create a list of randomly selected videos from the data (-> For Test Set)
% Take 20% of the videos for each class (Cov, Pneu, PnThorax, Reg and 
% Uninf) and save for Testing the NN -> Hide Out data

% Load list of videos
vid = readcell('C:\Users\miri_\Desktop\Miriam_TFM\4_Codes\3_Data_Preprocessing\ListVideos.xlsx');
% Define where are the different classes
lbStart = [1 34 58 89 112];
lbEnd = [33 57 88 111 148];

% Randomply generate a list by selecting a % of the videos for each class
% - Input: list of videos, percentage
% - Output: List of selected videos and the corresponding indexes of the
% original list.
m1 = 1;
for i=1:5
    label = vid(lbStart(i):lbEnd(i));
    n = length(label);
    randIndex = randperm(n, ceil(n * 0.20));
    m2 = m1-1+length(randIndex);
    Selected(m1:m2,1) = label(randIndex);
    SelectedIdx(m1:m2,1) = randIndex+lbStart(i)-1;
    m1 = m2+1;
end
MyTable = table(Selected,SelectedIdx,'VariableNames',{'VideoName','Video Index (related to ListoVideos.xlsx)'});
writetable(MyTable,'BlindSetRefference.xls')
    

