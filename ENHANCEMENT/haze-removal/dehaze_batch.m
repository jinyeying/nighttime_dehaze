function dehaze_batch()
clear
tic
close all

% [I I_out J T_est T A] = removeHaze('frame_22710.jpg',15);
  casePath = 'dehaze_data\15\Small' ;
%  casePath = 'D:\SeSaMe\surveillance\UnderHaze\test_data';  
%   casePath='_paper_use\result\all methods\04'

% casePath='L2images_JPEGsandResults';

% casePath = 'for-learning-based';
% casePath='_paper_use\texture\02';
%  fullfile(casePath,'ski.jpg') 
% y_f =  double(imread(fullfile(casePath,'ski_fogfree.jpg')));
[I I_out J T_est T A] = removeHaze(fullfile(casePath,'img.png'),15);  %fullfile(casePath,'img.jpg')
imwrite(I_out,fullfile(casePath,'img_d.png'));
compress=[20,30,40,50,60,70,80];
% lambda=[0.05,0.04,0.04,0.03,0.03,0.02,0.01];

for i=1:size(compress,2)
    
    rate=compress(i);
%     lamb=lambda(i);
% img_name= fullfile(casePath,[num2str(rate) '.jpg']);
 
[I I_out J T_est T A] = removeHaze(fullfile(casePath,[num2str(rate) '.jpg']),15);  %fullfile(casePath,'img.jpg')
imwrite(I_out,fullfile(casePath,[num2str(rate) '_d.png']));
% imwrite(I_out,fullfile(casePath,'20b.png'))
end

end


% clear
%  casePath = '..\dehaze_data\01' ;
% tic
% [I I_out J T_est T A] = removeHaze(fullfile(casePath,'30.jpg'),15);  %fullfile(casePath,'img.jpg')
% imwrite(I_out,fullfile(casePath,'30b.png'))
% toc
% 
% clear
%  casePath = '..\dehaze_data\01' ;
% tic
% [I I_out J T_est T A] = removeHaze(fullfile(casePath,'40.jpg'),15);  %fullfile(casePath,'img.jpg')
% imwrite(I_out,fullfile(casePath,'40b.png'))
% toc
% 
% clear
% tic
%  casePath = '..\dehaze_data\01' ;
% [I I_out J T_est T A] = removeHaze(fullfile(casePath,'50.jpg'),15);  %fullfile(casePath,'img.jpg')
% imwrite(I_out,fullfile(casePath,'50b.png'))
% toc
% clear
% tic
%  casePath = '..\dehaze_data\01' ;
% [I I_out J T_est T A] = removeHaze(fullfile(casePath,'60.jpg'),15);  %fullfile(casePath,'img.jpg')
% imwrite(I_out,fullfile(casePath,'60b.png'))
% toc
% 
% 
% clear
% tic
%  casePath = '..\dehaze_data\01' ;
% [I I_out J T_est T A] = removeHaze(fullfile(casePath,'70.jpg'),15);  %fullfile(casePath,'img.jpg')
% imwrite(I_out,fullfile(casePath,'70b.png'))
% toc

%[I I_out J T_est T A] = removeHaze('frame_18630.jpg',15);
% subplotImages(I,I_out);
% subplotImages(T,T_est);
 
%   imwrite(I_out,'../dehaze_data/04_dehaze.png');
% imwrite(I_out,'./Images/tianmen_guid_dark_patch10.jpg');
%  figure 
%  imshow(A);
%  title('atmospheric light A');  
 

% im=imread('../dehaze_data/15.bmp');
% 
% imwrite(im,'../dehaze_data/15_90.jpg','quality',90);