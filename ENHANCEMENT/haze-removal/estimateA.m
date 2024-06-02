function A = estimateA( I, J, numPixels )
%ESTIMATEA Summary of this function goes here
%   Detailed explanation goes here

    % Make a list of the brightest pixels
    brightestJ = zeros(numPixels,3);
    [x_dim y_dim] = size(J);
    for i = 1:x_dim
        for j = 1:y_dim
            [minElement, index] = min(brightestJ(:,3));
            if J(i,j) > minElement
                brightestJ(index,:) = [i j J(i,j)];
            end
        end
    end

    % Find the highest intensity pixel from the original Image using the
    % list calculated above
    highestIntensity = zeros(1,3); 
    
    for i = 1:numPixels
        x = brightestJ(i,1);
        y = brightestJ(i,2);
        intensity = sum(I(x,y,:));
        if intensity > sum(highestIntensity)
            highestIntensity = I(x,y,:);
            air_x=x;
            air_y=y;
        end
    end
    

    
    % Set as the Atmosphere lighting
    dimI = size(I);
    if numel(dimI) == 3
    
      A = zeros(x_dim,y_dim,3);
  
      for a = 1:dimI(3)
            A(:,:,a) = A(:,:,a) + highestIntensity(:,:,a);
      end
    else
      A = zeros(x_dim,y_dim);
      A(:,:) = A(:,:) + highestIntensity(:,:);
    end
    
end

