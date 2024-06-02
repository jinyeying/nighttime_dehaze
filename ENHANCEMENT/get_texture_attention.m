clear  
close all
addpath('haze-removal');
texture_folder = './texture_map/';
if ~exist(texture_folder, 'dir')
    mkdir(texture_folder);
end

attention_folder = './attention_map/';
if ~exist(attention_folder, 'dir')
    mkdir(attention_folder);
end

name_folder_dir  = '.\Input\'
input_folder_dir = name_folder_dir;

img_name_jpg = dir([name_folder_dir, '*.jpg']);
img_name_png = dir([name_folder_dir, '*.png']);
img_name = [img_name_jpg; img_name_png];
num = length(img_name);
for i = 1:num

    disp(['Working on image: ' img_name(i).name]);
    [~,namepart, ext] = fileparts(img_name(i).name);
    
    input_name = [name_folder_dir namepart ext];
    y = im2double(imread(input_name));

	name = namepart; 

    [H W D] = size(y);
    A = zeros([H W D]);
	H = floor(H/8)*8;
	W = floor(W/8)*8;
	y = y(1:H,1:W,:);

	[y_text, y_struct] = TV_L2_Decomp(y, 0.03) ;

	w = ones(8,8);
	w(1,1) = 0;w(1,2) = 0;w(2,1) = 0;
	text_idx_fun = @(block_struct) sum(sum((abs(dct2(block_struct.data)).*w)));
	text_idx = [];

	for c = 1:3
	    text_idx(:,:,c) = blockproc(y_text(:,:,c),[8 8],text_idx_fun);
	end
	text_idx = max(text_idx,[],3);
	text_reg = text_idx>0.2;
	text_map = blockproc(text_reg,[1 1],@(block_struct) ones(8,8)*block_struct.data);

	sig=1e-5;
	text_map_refined = generateLaplacian2f(y_struct, text_map,sig);
	thr = 0.7;
	ff = curve(thr*255, 0.04);
	text_map_refined2 = ff(text_map_refined*255)/255;

    A = text_map_refined2;
    cmap = jet(256);
    A = (A - min(A(:))) / (max(A(:)) - min(A(:))); 
    A = uint8(A * 255); 
    A = ind2rgb(A, cmap); 
    
    imwrite(y_text*10+0.5,[texture_folder namepart '.png']); 
    imwrite(A,[attention_folder namepart '.png']);   
end
 

 
        