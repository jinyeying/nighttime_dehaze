function [output] = boostLIME(input, gamma)
if(nargin<2)
    gamma = 0.8;
end
addpath(genpath('./LIME_DEMO_CODE/'))
% Setup params
para.lambda   = .15; % Trade-off coefficient
para.sigma    = 2;   % Sigma for Strategy III
para.gamma    = gamma; %  Gamma Transformation on Illumination Map
para.solver   = 1;   % 1: Sped-up Solver; 2: Exact Solver
para.strategy = 3;   % 1: Strategy I; 2: II; 3: III
% scale input to [0-1]
input         = im2double(input);
% Generate the boosted image using LIME
[output, ~,~] = LIME(input, para);
% Return the output in uint8 format
output        = uint8(output*255);
end
