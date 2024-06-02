function J = makeDarkChannel( I, patch_size )
    % Assuming that this is RGB but overall not requiring it
    [image_x image_y channels] = size(I);
    J = zeros(image_x,image_y);
    tmpPatch = double(zeros(2*floor(patch_size/2),2*floor(patch_size/2),channels));
    
    I = padarray(I, [floor(patch_size/2) floor(patch_size/2)], 'symmetric');
    I_min=min(I,[],3);
    
    % I think the size actually returns in order [y x ~ but doesn't really
    % matter as long as order is kept
    
    % padarray resizes the example 300x400 to 314x414.  
    % Use original image_x, image_y and add 2*floor(patch_size/2)

%     for i = 1:image_x
%         minX = i;
%         maxX = (i + 2*floor(patch_size/2));
%         for j = 1:image_y
%             minY = j;
%             maxY = (j + 2*floor(patch_size/2));
%             
%             % copy all color channels over
%             tmpPatch = I(minX:maxX, minY:maxY,:);
%             J(i,j) = min(tmpPatch(:)); % find min across all channels
%         end
%     end
im_col=im2col(I_min,[patch_size patch_size],'sliding');
J=min(im_col);
J=reshape(J,image_x,image_y);


end

