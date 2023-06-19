%% DeepLab v3+
clc;
clear;

% PREREQUISITES
% Install Deep Learning Toolbox and Computer Vision Toolbox
% Install Parallel Computing Toolbox (for GPU computing)

% Step 1: Prepare training dataset
imgFolderTrain = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\2_LungPreprocessedDataset\1_TrainingSet\InputImg';
mskFolderTrain = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\2_LungPreprocessedDataset\1_TrainingSet\OutGT_4class';

% Define class names
classNames = ["Background","PL","AL","BL"]; 
labelIDs   = [0 80 150 250];

% Get image and label file paths
imgPathTrain = dir(fullfile(imgFolderTrain, '*.jpg')); 
lblPathTrain = dir(fullfile(mskFolderTrain, '*.png')); 

% Create arrays to store file paths
imgFilesTrain = cell(numel(imgPathTrain), 1);
lblFilesTrain = cell(numel(lblPathTrain), 1);

% Get image and label file paths
for idx = 1:numel(imgPathTrain)
    imgFilesTrain{idx} = fullfile(imgPathTrain(idx).folder, imgPathTrain(idx).name);
    lblFilesTrain{idx} = fullfile(lblPathTrain(idx).folder, lblPathTrain(idx).name);
end

% Create the training datastores 
imdsTrain = imageDatastore(imgFilesTrain);
pxdsTrain = pixelLabelDatastore(lblFilesTrain,classNames,labelIDs);
trainData = combine(imdsTrain,pxdsTrain);

% Step 2: Prepare validation dataset
imgFolderVal = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\2_LungPreprocessedDataset\2_ValidationSet\InputImg';
mskFolderVal = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\2_LungPreprocessedDataset\2_ValidationSet\OutGT_4class';

% Get image and label file paths
imgPathVal = dir(fullfile(imgFolderVal, '*.jpg')); 
lblPathVal = dir(fullfile(mskFolderVal, '*.png')); 

% Create arrays to store file paths
imgFilesVal = cell(numel(imgPathVal), 1);
lblFilesVal = cell(numel(lblPathVal), 1);

% Get image and label file paths
for i = 1:numel(imgPathVal)
    imgFilesVal{i} = fullfile(imgPathVal(i).folder, imgPathVal(i).name);
    lblFilesVal{i} = fullfile(lblPathVal(i).folder, lblPathVal(i).name);
end

% Create the training datastores 
imdsVal = imageDatastore(imgFilesVal);
pxdsVal = pixelLabelDatastore(lblFilesVal,classNames,labelIDs);
valData = combine(imdsVal,pxdsVal);

% Step 3: Define DeepLab v3+ Architecture
imageSize = [256 256];
numClasses = 4;
lgraph = deeplabv3plusLayers(imageSize,numClasses,"resnet50");

% Replace the original input layer 
newInputLayer = imageInputLayer(imageSize(1:2),Name="newInputLayer");
lgraph = replaceLayer(lgraph,lgraph.Layers(1).Name,newInputLayer);

% Replace the first 2-D convolution layer with a new 2-D convolution layer 
% to match the size of the new input layer.
newConvLayer = convolution2dLayer([7 7],64,Stride=2,Padding=[3 3 3 3],Name="newConv1");
lgraph = replaceLayer(lgraph,lgraph.Layers(2).Name,newConvLayer);

% % Replace last layer weighted cross entropy loss classification layer
classWeights = [0.2037,1.2561,1.1542,0.7808];

cLayer = pixelClassificationLayer('Name','Pixel_Cassification','Classes',classNames,'ClassWeights',classWeights); %add class weights
lgraph = replaceLayer(lgraph,'classification',cLayer);

% Step 4: Train the DeepLab v3+
% Set training options.
options = trainingOptions("rmsprop", ...
    Shuffle="every-epoch", ...
    InitialLearnRate=1e-4, ...
    MaxEpochs=8, ...
    MiniBatchSize=32, ...
    ValidationData=valData, ...
    ValidationFrequency=50, ...
    Verbose=1, ...
    ExecutionEnvironment="gpu",...
    Plots="training-progress", ...
    OutputNetwork="best-validation-loss");

% Train the DeepLab v3+
fprintf('Starting the training \n');
[net,info] = trainNetwork(trainData,lgraph,options);

% Step 5: Save the trained model
modelDateTime = string(datetime("now",Format="yyyy-MM-dd-HH-mm-ss"));
netDir = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\5_DeepLab_v3\Trial10';
save(fullfile(netDir,"test1-" ...
    +modelDateTime+".mat"),"net");
save(fullfile(netDir,"trainInfo.mat"),"info");

% Step 6: Evaluate the UNet on the blind set
fprintf('Evaluating the network \n');

% Prepare blind set for evaluation
imgFolderBlind = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\2_LungPreprocessedDataset\3_BlindSet\InputImg';
mskFolderBlind = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\2_LungPreprocessedDataset\3_BlindSet\OutGT_4class';

% Get image and label file paths
imgPathBlind = dir(fullfile(imgFolderBlind, '*.jpg')); 
lblPathBlind = dir(fullfile(mskFolderBlind, '*.png')); 

% Create arrays to store file paths
imgFiles = cell(numel(imgPathBlind), 1);
lblFiles = cell(numel(lblPathBlind), 1);

% Get image and label file paths
for idx = 1:numel(imgPathBlind)
    imgFiles{idx} = fullfile(imgPathBlind(idx).folder, imgPathBlind(idx).name);
    lblFiles{idx} = fullfile(lblPathBlind(idx).folder, lblPathBlind(idx).name);
end

% Create the blind datastores 
imdsBlind = imageDatastore(imgFiles);
pxdsBlind = pixelLabelDatastore(lblFiles,classNames,labelIDs);

% Evaluate performance on validation set
resultsDir = 'C:\Users\Miriam\Documents\Miriam_TFM_LUS\5_DeepLab_v3\Trial10';
fprintf('Validation metrics:\n');
pxdsPred = semanticseg(imdsBlind, net,...
    'MiniBatchSize', 32,... 
    'WriteLocation',resultsDir,...
    'ExecutionEnvironment',"gpu");
metrics = evaluateSemanticSegmentation(pxdsPred,pxdsBlind);
save(fullfile(resultsDir,"metrics.mat"),"metrics");


