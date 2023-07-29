function weights = psfweight(theta,T,q)

% expected input
% theta = -180:180;

% T is optical thickness 
% According to Narasimhan in CVPR03 paper, 
% T = sigma * R (extinctiontion coefficition * distance or depth)
% which is the same \beta d in haze modeling

% q is forward scattering parameter
% 0.0-0.2 air
% 0.2-0.7 aerosol
% 0.7-0.8 haze
% 0.8-0.85 mist
% 0.85-0.9 fog
% 0.9-1.0 rain

[mpath,~,~] = fileparts(mfilename('fullpath'));

M = 200;        % number of polynomials for a series solution
bEarlyTerm = false;

mu = cosd(theta);       % eq (5.1)



% lookup table for legendreP
fLU = fullfile(mpath,'psfweight_poly.mat');
if exist(fLU,'file')
    load(fLU,'mu_ref','legendrePLU');
else
    mu_ref = -1:2/1000:1;
    legendrePLU = zeros(M,length(mu_ref));
    for m=1:M
        legendrePLU(m,:) = legendreP(m,mu_ref);
        fprintf('%d\n',m);
    end
    save(fLU,'legendrePLU','mu_ref');
end

% eq (5.25) and (5.26)
alpha = @(m) m+1;
beta = @(m,q) (2*m+1)/m * (1-q^(m-1));

% eq (5.27)
gm = @(m,alpha,beta,T) exp( -beta*T - alpha*log(T) );

%%%%%%%%%%%%%%
%%% method 1
%%%%%%%%%%%%%%
% eq (5.28)
weights = zeros(size(mu));
for m=1:M
    if m==1
        L_pre = ones(size(mu));
    else
        L_pre = L;
    end
    
    L = interp1(mu_ref,legendrePLU(m,:),mu);
    p = gm(m,alpha(m),beta(m,q),T) * (L_pre + L);
    
    weights = weights + p;
    
    % early terminate
    if bEarlyTerm && abs(max(p))<2e-3
        fprintf('%d\n',m);
        break
    end
end

% normalize
weights = weights * T^2;
end
