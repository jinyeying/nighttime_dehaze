function [ y ] = scale( x )
%SCALE Summary of this function goes here
%   Detailed explanation goes here
min_x=min(min(x));
max_x=max(max(x));
y=(x-min_x)/(max_x-min_x)*0.97+0.03;

end

