%% Extract masks for each frame
% - Pleural line
% - B lines
% - A lines
close all;
clear; 
clc;

%%
% Load xyInfo file: contains ROI corners
[xyInfo,Names] = xlsread('xyInfo.xlsx');
% Video filepaths
%filepath = append('G:\Otros ordenadores\My Computer\Keyframes\', Names);
filepath = append('G:\Otros ordenadores\My Computer\Keyframes\', Names);


% Start loop
for DataRow = 1:size(xyInfo,1)
    % thetaPleural = (-20:0.25:20)+90;  % angels to detect pleural lines
    DataRow=103;
    file = char(filepath(DataRow));                             %Selected video: Convert to character
    myFrames = dir(fullfile(file, '*.jpg'));                    %List of video keyframes
    
    for i = 29:40%length(myFrames)
        Input = strcat(file,'\',myFrames(i).name);              %Selected frame
        [writePath,writeName, ~] = fileparts(Input);            %Define mask final path/name
        originalInput = imread(Input);                          %Read current frame
        firstFrame = im2double(originalInput);                  %Image: uint8 to floating point
        xCorners = round(xyInfo(DataRow,1:5));                  %x and y corners of the ROI
        yCorners = round(xyInfo(DataRow,6:10));

        % Initialize 3 masks: pleural-line (pl), a-lines (al), b-lines (bl)
        plMask = zeros(size(firstFrame));
        alMask = zeros(size(firstFrame));
        blMask = zeros(size(firstFrame));
        [R, C] = size(firstFrame);                              %nRows and nColumns

        figure; imshow(firstFrame,[]); 
       
%         % Question: Skip the frame?
%         question = questdlg('Skip the frame?',...
%             'skip',...
%             'yes','no','no'); 
%         % Handle response
%         switch question                                             
%             case 'yes'                                          %skip frame
%                 fflag = false;
%             case 'no'                                           %extract patterns
%                 fflag = true;
%         end
        
        % PATTERNS
        if fflag                                                %fflag=true
            %Extract patterns
            % 1. PLEURAL LINE
            % Question: Is there pleural line?
            pflag = questdlg('do you see the pleural line?', ...
                'Pattrens', ...
                'true','false', 'true');
            switch pflag                                        %Handle response
                case 'true'                                     %yes pleural line
                    pflag = true; 
                    while pflag
                        [~, xCorners, yCorners] = roipolyold();
                        numberOfVertices = length(xCorners)-1;
                        if numberOfVertices ~= 2
                            userPrompt = sprintf('You clicked %d points.\nPlease click exactly 2 point only.', numberOfVertices-1);
                            uiwait(msgbox(userPrompt));
                        else
                            pflag = false;
                        end
                    end
                    xCorners = xCorners(1:2);
                    yCorners = yCorners(1:2);
                    nPoints = max(abs(diff(xCorners)), abs(diff(yCorners)))+1;    % Number of points in line
                    rIndex = round(linspace(yCorners(1), yCorners(2), nPoints));  % Row indices
                    cIndex = round(linspace(xCorners(1), xCorners(2), nPoints));  % Column indices
                    index = sub2ind([R C], rIndex, cIndex);                       % Linear indices
                    plMask(index) = 255;                                          % Modify red plane

                    se = strel('disk',5);                        %mask: pleural line
                    plMask = imdilate(plMask,se);

                    % Question: Ask for patterns
                    answer1 = questdlg('is there a pattern?', ...
                        'Pattrens', ...
                        'yes','no', 'no');
                    switch answer1
                        case 'yes'                               %Patterns are visible
                            % Question: Ask for the type of patterns
                            answer = questdlg('Which patterns do you see?', ...
                                'Pattrens', ...
                                'PA','PB', 'PAB','PAB');
                            % Handle response
                            switch answer 
                                % PA PATTERNS
                                case 'PA'       
                                    % 2. A-LINES
                                    aflag = true;
                                    while aflag
                                        [~, xCorners, yCorners] = roipolyold();
                                        xCorners = xCorners(1:2);
                                        yCorners = yCorners(1:2);
                                        nPoints = max(abs(diff(xCorners)), abs(diff(yCorners)))+1;    % Number of points in line
                                        rIndex = round(linspace(yCorners(1), yCorners(2), nPoints));  % Row indices
                                        cIndex = round(linspace(xCorners(1), xCorners(2), nPoints));  % Column indices
                                        index = sub2ind([R C], rIndex, cIndex);                       % Linear indices
                                        alMask(index) = 255;
                                        flag = questdlg('continue with another a-line?','continue','yes','no','no');
                                        switch flag
                                            case 'yes'
                                                aflag = true;
                                            case 'no'
                                                aflag = false;
                                        end
                                    end
                                    alMask = imdilate(alMask,se);               %mask: a-line

                                % PB PATTERN
                                case 'PB'
                                    % 3. B- LINES
                                    bflag = true;
                                    while bflag
                                        [~, xCorners, yCorners] = roipolyold();
                                        xCorners = xCorners(1:2);
                                        yCorners = yCorners(1:2);
                                        nPoints = max(abs(diff(xCorners)), abs(diff(yCorners)))+1;    % Number of points in line
                                        rIndex = round(linspace(yCorners(1), yCorners(2), nPoints));  % Row indices
                                        cIndex = round(linspace(xCorners(1), xCorners(2), nPoints));  % Column indices
                                        index = sub2ind([R C], rIndex, cIndex);                       % Linear indices
                                        blMask(index) = 255;
                                        flag = questdlg('Continue with another b-line?','continue','yes','no','no');
                                        switch flag
                                            case 'yes'
                                                bflag = true;
                                            case 'no'
                                                bflag = false;
                                        end
                                    end
                                    blMask = imdilate(blMask,se);               %mask: b-line

                                % PAB PATTERN
                                case 'PAB'
                                    % 2. A-LINES
                                    aflag = true;
                                    while aflag
                                        [~, xCorners, yCorners] = roipolyold();
                                        xCorners = xCorners(1:2);
                                        yCorners = yCorners(1:2);
                                        nPoints = max(abs(diff(xCorners)), abs(diff(yCorners)))+1;    % Number of points in line
                                        rIndex = round(linspace(yCorners(1), yCorners(2), nPoints));  % Row indices
                                        cIndex = round(linspace(xCorners(1), xCorners(2), nPoints));  % Column indices
                                        index = sub2ind([R C], rIndex, cIndex);                       % Linear indices
                                        alMask(index) = 255;
                                        flag = questdlg('continue with another a-line?','continue','yes','no','no');
                                        switch flag
                                            case 'yes'
                                                aflag=true;
                                            case 'no'
                                                aflag=false;
                                        end
                                    end
                                    alMask = imdilate(alMask,se);               %mask: a-line

                                    % 2. B-LINES
                                    bflag = true;
                                    while bflag
                                        [~, xCorners, yCorners] = roipolyold();
                                        xCorners = xCorners(1:2);
                                        yCorners = yCorners(1:2);
                                        nPoints = max(abs(diff(xCorners)), abs(diff(yCorners)))+1;    % Number of points in line
                                        rIndex = round(linspace(yCorners(1), yCorners(2), nPoints));  % Row indices
                                        cIndex = round(linspace(xCorners(1), xCorners(2), nPoints));  % Column indices
                                        index = sub2ind([R C], rIndex, cIndex);                       % Linear indices
                                        blMask(index) = 255;
                                        flag = questdlg('continue with another b-line?','continue','yes','no','no');
                                        switch flag
                                            case 'yes'
                                                bflag = true;
                                            case 'no'
                                                bflag = false;
                                        end
                                    end
                                    blMask = imdilate(blMask,se);               %mask: b-line
                            end
                            close all;
                            imwrite(plMask, strcat([writePath, '\plMask_',writeName,'.png']));
                            imwrite(alMask, strcat([writePath, '\alMask_',writeName,'.png']));
                            imwrite(blMask, strcat([writePath, '\blMask_',writeName,'.png']));

                        case 'no'                                %Patterns are not visible
                            close all;
                            imwrite(plMask, strcat([writePath, '\plMask_',writeName,'.png']));
                            imwrite(alMask, strcat([writePath, '\alMask_',writeName,'.png']));
                            imwrite(blMask, strcat([writePath, '\blMask_',writeName,'.png']));
                            continue;
                    end
                case 'false'                                     %No pleural line
                    imwrite(plMask, strcat([writePath, '\plMask_',writeName,'.png']));
                    imwrite(alMask, strcat([writePath, '\alMask_',writeName,'.png']));
                    imwrite(blMask, strcat([writePath, '\blMask_',writeName,'.png']));
                    continue;     
            end
        else %if fflag=false (skip the frame)                                                 
            close all;
        end
    end
end



