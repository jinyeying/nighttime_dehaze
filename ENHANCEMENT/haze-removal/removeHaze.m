%function [I J T A L] = removeHaze( imageName, patch_size )
function [I I_out J T_est T A] = removeHaze( imageName, patch_size )
%REMOVEHAZE Summary of this function goes here
%   Detailed explanation goes here
if(isstr(imageName))
    %          imageName = strcat('Images/',imageName);
    I =  im2double(imread(imageName));
    %         It=im2double(imread(imageName2));
else
    I = imageName;
end
% Used to make image more realistic due to seeming unbelievable
% when there is no sense of depth
aerialPerspective =0.95;


%     if max(max(max(size(I)))) > 768
%         scale = 768 / max(max(max(size(I))));
%         I =  imresize(I,scale);
%      imwrite(I,'../dehaze_data/13_resize.png');
%     end

% Make grayscales to color
if numel(size(I)) == 2
    [x y] = size(I);
    tmpI = zeros(x,y,3);
    for c = 1:3
        tmpI(:,:,c) = I;
    end
    I = tmpI;
end




J = makeDarkChannel(I,patch_size);

% Section 4.4
%   Estimate Atmosphere

%  We first pick the top 0.1% bright- est pixels in the dark channel.
%  These pixels are most haze- opaque (bounded by yellow lines in
%  Figure 6(b)). Among these pixels, the pixels with highest intensity
%  in the input image I is selected as the atmospheric light.


%
% TL;DR  TAKE .1% of the brightest pixels
dimJ = size(J);
numBrightestPixels = ceil(0.001 * dimJ(1) * dimJ(2)); % Use the cieling to overestimate number needed

A = estimateA(I,J,numBrightestPixels);

%     At = estimateA(It,Jt,numBrightestPixels);


% Section 4.1
%   Estimate the Transmission
%   Equation 12
T_est = 1 - aerialPerspective*makeDarkChannel(I./A,patch_size);



sig =1e-4;
[T1] = generateLaplacian2f(I,T_est,sig);

T1(T1>1)=1;
T1(T1<0)=0;
min(min(T1))





%     title('t map')
%     colormap(hot)
w=5;
sigma=[3 0.1];  % 3 0.1
T=bfilter2(T1,w,sigma);


dehazed = zeros(size(I));
% Equation 16

% Equation 16
for c = 1:3
    im=I(:,:,c);
    a=A(:,:,c);
    dehazed(:,:,c) = (im - a)./(max(T, .1)) + a;
    
end

I_out = dehazed;


end

