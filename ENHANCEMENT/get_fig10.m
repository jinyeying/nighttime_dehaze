clear;
close all;
addpath('haze-removal');

img_name = 'flickr3_real_B.png';
name_folder_dir = ['.\Input\', img_name];
input_folder_dir = name_folder_dir;

y = im2double(imread(name_folder_dir));

[H, W, D] = size(y);
H = floor(H/8) * 8;
W = floor(W/8) * 8;
y = y(1:H, 1:W, :);

[y_text, y_struct] = TV_L2_Decomp(y, 0.03);

w = ones(8, 8);
w(1, 1) = 0; w(1, 2) = 0; w(2, 1) = 0;
text_idx_fun = @(block_struct) sum(sum((abs(dct2(block_struct.data)) .* w)));
text_idx = [];

for c = 1:3
    text_idx(:,:,c) = blockproc(y_text(:,:,c), [8 8], text_idx_fun);
end
text_idx = max(text_idx, [], 3);
text_reg = text_idx > 0.2;
text_map = blockproc(text_reg, [1 1], @(block_struct) ones(8, 8) * block_struct.data);

sig = 1e-5;
text_map_refined = generateLaplacian2f(y_struct, text_map, sig);
thr = 0.7;
ff = curve(thr * 255, 0.04);
A2 = ff(text_map_refined * 255) / 255;

A = A2;
cmap = jet(256);
A = (A - min(A(:))) / (max(A(:)) - min(A(:))); 
A = uint8(A * 255);
A = ind2rgb(A, cmap); 

our_c = im2double(imread(['.\Output_dark\' img_name]));
[reH, reW, ~] = size(A2);
img = imresize(y, [reH, reW]);
our_c = imresize(our_c, [reH, reW]);

outB = im2double(boostLIME(our_c, 0.3));
outB = imresize(outB, [reH, reW]);
enhance_outB = outB .* A2 +  outB .* (1 - A2);
figure(1), imshow([img, our_c, A, enhance_outB]);
