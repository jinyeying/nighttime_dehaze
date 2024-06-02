function T_colored = colorTransmission( T )
%COLORTRANSMISSION Summary of this function goes here
%   Detailed explanation goes here

t = size(T);
T_colored = zeros(t(1), t(2), 3);

maxT = max(max(max(T)));
minT = min(min(min(T)));
avg = (maxT + minT)/2;

T_colored(:,:,1) = T > ( maxT - avg/2 );
T_colored(:,:,2) = ((minT+avg/2) < T) .* (T < (maxT-avg/2));
T_colored(:,:,3) = T < minT+avg/2;

end