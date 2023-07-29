% prepare training data from Flicker nighttime images
clc; clear; close all;

addpath(genpath('./function'));

reH = 256; reW = 320;
addnoise = true;

data_from = 'D:\Dropbox\nighttime\ACMMM23\paired_data\clean_data\';
data_root = 'D:\Dropbox\nighttime\ACMMM23\paired_data\';

path_clean = [data_root '/clean']; if ~exist(path_clean,'dir'), mkdir(path_clean); end
path_degrad = [data_root '/glow']; if ~exist(path_degrad,'dir'), mkdir(path_degrad); end
path_ls = [data_root '/glow_render_visual/light_source']; if ~exist(path_ls,'dir'), mkdir(path_ls); end
path_pairs = [data_root '/glow_render_visual/pairs']; if ~exist(path_pairs,'dir'), mkdir(path_pairs); end
fid_clean = fopen(fullfile(data_root,'list_clean.txt'),'w');
fid_degrad = fopen(fullfile(data_root,'list_degrad.txt'),'w');

clean_list = [dir([data_from '/*.jpg']); dir([data_from '/*.png'])];

for iid = 1:length(clean_list)

%% clean image
clean_path = fullfile(clean_list(iid).folder,clean_list(iid).name);
clean_img = im2double(imread(clean_path));

if size(clean_img,1) > size(clean_img,2)
    clean_img = imresize(clean_img,[reW, reH]); 
else
    clean_img = imresize(clean_img,[reH, reW]); 
end

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

%% APSF(kernel size, T, q)
ksize = 200;
theta = -180:360/ksize:180;
T = 1.0; q = 0.9;
APSF = psfweight(theta,T,q);  

APSF2D = get2Drot(APSF);

%%
img = imfilter(light_sources, APSF2D / sum(APSF2D(:)), 'conv', 'symmetric');

%%
param = 0.4196*light_size.^2 - 4.258 * light_size + 11.35;
if light_size>4 || param < 2
    param = 2;
end
param = param + 0.05*randn(1);
I = clean_img*0.99 + img*param;

clean_img = imresize(clean_img,[reH reW]);
I = imresize(I,[reH reW]);

if addnoise
    I = imnoise(I,'gaussian',0,1e-4);
end

%% save results
clean_loc = fullfile(path_clean,clean_list(iid).name);
degrad_loc = fullfile(path_degrad,clean_list(iid).name);

% list file
fprintf(fid_clean,sprintf('/clean/%06d.png\n',clean_list(iid).name));
fprintf(fid_degrad,sprintf('/glow/%06d.png\n',clean_list(iid).name));

% save to
ls_loc = fullfile(path_ls,clean_list(iid).name);
pair_loc = fullfile(path_pairs,clean_list(iid).name);

imwrite(clean_img,clean_loc);
imwrite(I,degrad_loc);
imwrite(light_sources,ls_loc);
imwrite([clean_img I],pair_loc)

% display
fprintf('flickr - %06d\n',iid);
end

fclose('all');
