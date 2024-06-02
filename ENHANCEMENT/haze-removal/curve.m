function [f g] = curve(m, sig)

f = @(x) 255./(1+exp(sig*(-x+m)));
g = @(x) sig*255*exp(sig*(-x+m))./(1+exp(sig*(-x+m))).^2;
% g = ()