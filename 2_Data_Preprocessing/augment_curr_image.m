function [aug1,aug2,aug3] = augment_curr_image(inputImg,factor1,factor2)
% Generates the following augmentations from the input image:
%   - Horizontal flip = factor1
%   - Change of brightness (product) = factor2
    original_img = imread(inputImg); 
    aug1 = flip(original_img,factor1);        
    aug2 = original_img*factor2(1);
    aug3 = original_img*factor2(2);
end