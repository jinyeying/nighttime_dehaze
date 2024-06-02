function [ T ] = generateLaplacian2f( I,T_est,sig)
%GENERATELAPLACIAN2 Summary of this function goes here
%   Detailed explanation goes here

% casePath = '../enhance_data/02' ;
addpath(genpath('haze-removal2'));
%%%%  guided filter
% r =4;
% eps =   1*10^-3;
% q = zeros(size(I));
% T1 = guidedfilter(rgb2gray(I), T_est, r, eps);
% figure
% imshow(T1)
% title (['r: ' num2str(r)  '; eps: ' num2str(eps)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
[H,W,D]= size(I);
win_size = 1;
winH=3;
winW=3;
win_pixels = 9;
windows_num=(H-2*win_size)*(W-2*win_size);

% As per equation in paper when computing the laplacian
% U is to be added to the window covariance
U = .000001 ./win_pixels.*eye(3);



im_col= zeros(win_pixels,windows_num,3);
for i=1:3
    im_col(:,:,i) = im2col(I(:,:,i),[winH winW],'sliding');   %% 0.65724 seconds
end

im_mean=repmat(mean(im_col),win_pixels,1);
im_diff=im_col-im_mean;
clear  im_mean
clear im_col

diff_2d=zeros(win_pixels,3*windows_num);
 
for i=1:3
    diff_2d(:,i:3:3*windows_num)=im_diff(:,:,i);  %%%    0.10852 seconds. 
end

clear im_diff

%%%%%%%%%%%% form matrix A,  blkdiag from cell   4 s 
% t1=toc;
% C = mat2cell(diff_2d,[win_pixels],3*ones(1,windows_num));    %%%  1.34 second
% C{1}=sparse(C{1});
% A1 = blkdiag(C{:});
% clear C
% t2=toc;
% t2-t1
%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%  form matrix A, 0.467 s 
 
 x_ind=1:win_pixels*windows_num;
 x_ind=reshape(x_ind,win_pixels,windows_num);
x_ind=repmat(x_ind,3,1);  % 3   for rgb
x_ind=x_ind(:)';

y_ind=repmat(1:3*windows_num,win_pixels,1);
y_ind=y_ind(:)';

A = sparse(x_ind,y_ind,diff_2d(:)',win_pixels*windows_num,3*windows_num);
 
 

%%%%%%%%%%  form  U_sparse;    0.03
U_sparse=spdiags((.000001./win_pixels*ones(3*windows_num,1)),0,3*windows_num,3*windows_num);
 


%%%%%%%%%%%%%    0.3686 s
cov_rgb=  A'*A/win_pixels+U_sparse;
clear U_sparse
%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   get the inverse; 
 
ide=speye(3);
temp=repmat(ide,1,windows_num);
row_cov_rgb=temp*cov_rgb;

%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  blockproc  ? inv;
%%%%%%%%%%%% 45 / 17s
 
 
% fun_x = @(block_struct)  inv(block_struct.data); 
% T2 = blockproc(full(row_cov_rgb),[winH winW],fun_x,'UseParallel',true);   %
%  t2=toc;
%  t2-t1
%%%%%%%%%%%%%%%%    7.6360 s
 
C = mat2cell(row_cov_rgb,3,3*ones(1,windows_num));   %%%?? 5.4983??
% disp([' mat 2 cell  ', num2str(toc-t2)])
C{1}=full(C{1});
C= cellfun(@inv,C,'UniformOutput',0); %%%?? 1.3860????

C{1}=sparse(C{1});
 
 
% cov_inv_rgb= blkdiag(C{:});  %%%2.5683
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     0.3015
C = cell2mat(C);
x_ind=1:3*windows_num;
x_ind=reshape(x_ind,3,windows_num);
x_ind=repmat(x_ind,3,1);  % 3   for rgb
x_ind=x_ind(:)';
y_ind=repmat(1:3*windows_num,3,1);
y_ind=y_ind(:)';
cov_inv_rgb = sparse(x_ind,y_ind,C(:)',3*windows_num,3*windows_num);
clear C
 
%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   1.5 s 
%%   9*9 ones block diags
 
x_ind=1:9*windows_num;
x_ind=reshape(x_ind,9,windows_num);
x_ind=repmat(x_ind,9,1);  % 3   for rgb
x_ind=x_ind(:)';
y_ind=repmat(1:9*windows_num,9,1);
y_ind=y_ind(:)';
diag_ones = sparse(x_ind,y_ind, ones(1,81*windows_num),9*windows_num,9*windows_num);
%%%%%%%%%%%%%%
 

 
   
 
ini_res=speye(9*windows_num)-(A*cov_inv_rgb*A'+diag_ones)./win_pixels;   % 2s  
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  till now  12s 
 
 
clear A
clear B
clear cov_rgb
ide=speye(9);
temp=repmat(ide,1,windows_num);
ini_res=temp*ini_res;
L_elements=ini_res(:)';   %%  sparse

 
% L_elements=full(L_elements);
% L_elements(1,[40:100])

clear ini_res
clear temp


%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      generate X_indx; Y_indx
windowIndicies = 1:H*W;
windowIndicies = reshape(windowIndicies,H,W);
w_ind_col=im2col(windowIndicies,[winH winW],'sliding');
clear windowIndicies

% fun_x = @(block_struct)  repmat(block_struct.data',win_pixels,1);
% X = blockproc(w_ind_col,[win_pixels 1],fun_x);

tem=repmat(w_ind_col(:),1,win_pixels);
tem=tem';
X=tem(:)';
clear tem
Y=repmat(w_ind_col,win_pixels,1);   %%% 
Y=Y(:)';
clear w_ind_col


 
 

L = sparse(X,Y,L_elements,H*W,H*W);
clear X
clear Y
clear L_elements
A=(L + sig .* speye(size(L)));
b= T_est(:) .* sig;
T= A \b;

clear A
% T = (L + sig .* speye(size(L))) \ T_est(:) .* sig;

 
 
T = reshape(T, size(T_est));

end

