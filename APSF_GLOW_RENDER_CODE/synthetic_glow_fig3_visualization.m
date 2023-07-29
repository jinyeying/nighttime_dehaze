clc; clear; close all;
addpath(genpath('./function'));

clean_root = 'D:\Dropbox\nighttime\ACMMM23\paired_data\clean_data\';

%% clean image
image_name = '000438.png'; 
clean_path = fullfile(clean_root,image_name);    
clean_img = im2double(imread(clean_path));
%% mask
mask = max(clean_img,[],3)>0.8;
light_size = sum(mask(:))/numel(mask(:))*100;

sig=1e-5;
text_map_refined = generateLaplacian2f(clean_img, mask, sig);
thr = 0.3;
ff = curve(thr*255, 0.04);
text_map_refined2 = ff(text_map_refined*255)/255;

%% light source
light_sources = text_map_refined2.*clean_img;
%% APSF (kernel size, T, q)
ksize = 200;
theta = -180:360/ksize:180;
T = 1.0;q = 0.9; 
APSF = psfweight(theta,T,q); 

APSF2D = get2Drot(APSF);

%%
img = imfilter(light_sources, APSF2D / sum(APSF2D(:)), 'conv', 'symmetric');

param = 0.4196*light_size.^2 - 4.258 * light_size + 11.35;
if light_size>4 || param < 2
    param = 2;
end
I = clean_img*0.99 + img*param;

fig_detail = true;
%fig_detail = false;
if fig_detail
    sprow = 2; spcol = 4;
    subplot(sprow,spcol,1), imshow(clean_img); title('Clean');
    subplot(sprow,spcol,2), plot(0:ksize,APSF,'linewidth',1.5);title('APSF');
    pbaspect([1 1 1]);
    subplot(sprow,spcol,3), surf(APSF2D,'edgecolor','none');
    axis([0 ksize 0 ksize 0 inf]);title('APSF2D');
    subplot(sprow,spcol,4), imshow(mat2gray(img));title('Boosted Glow');
    subplot(sprow,spcol,5), imshow(mask); title('Mask');
    subplot(sprow,spcol,6), imshow(text_map_refined2); title('Matting');
    subplot(sprow,spcol,7), imshow(light_sources); title('Light Source');
    subplot(sprow,spcol,8), imshow(I); title('Rendered Glow');
else
    sprow = 1; spcol = 2;
    subplot(sprow,spcol,1), imshow(clean_img); title('Clean');
    subplot(sprow,spcol,2), imshow(I); title('Rendered Glow');
end

