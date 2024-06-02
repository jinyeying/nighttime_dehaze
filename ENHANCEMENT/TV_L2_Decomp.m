function [T S]= TV_L2_Decomp(Im, lambda)
%TV_L2_DECOMP Summary of this function goes here
%   Detailed explanation goes here


if ~exist('lambda','var')
    lambda = 2e-2;
end

S = im2double(Im);

betamax = 1e5;
fx = [1, -1];
fy = [1; -1];
[N,M,D] = size(Im);
sizeI2D = [N,M];
otfFx = psf2otf(fx,sizeI2D);
otfFy = psf2otf(fy,sizeI2D);
Normin1 = fft2(S);
Denormin2 = abs(otfFx).^2 + abs(otfFy ).^2;
if D>1
    Denormin2 = repmat(Denormin2,[1,1,D]);
end
beta = 2*lambda;
while beta < betamax
    lambeta = lambda/beta;
    Denormin   = 1 + beta*Denormin2;
    % h-v subproblem
    u = [diff(S,1,2), S(:,1,:) - S(:,end,:)];
    v = [diff(S,1,1); S(1,:,:) - S(end,:,:)];
    u = max(abs(u)-lambeta,0).*sign(u);
    v = max(abs(v)-lambeta,0).*sign(v);
    % S subproblem
    Normin2 = [u(:,end,:) - u(:, 1,:), -diff(u,1,2)];
    Normin2 = Normin2 + [v(end,:,:) - v(1, :,:); -diff(v,1,1)];
    FS = (Normin1 + beta*fft2(Normin2))./Denormin;
    S = real(ifft2(FS));
%     figure,imshow(S);
    beta = beta*2;
    fprintf('.');
end
T = Im-S;
fprintf('\n');
end

