function dc = makeDataTerm(I_prime,L_inf_sum,k)
I_prime_x = diff(I_prime,1,1);
I_prime_x = [I_prime_x;I_prime_x(end,:,:)];
I_prime_y = diff(I_prime,1,2);
I_prime_y = [I_prime_y,I_prime_y(:,end,:)];
gradient = sum(abs(I_prime_x),3)+sum(abs(I_prime_y),3);
figure,imshow(gradient/255);
I_pad = padarray(I_prime, [floor(patch_size/2) floor(patch_size/2)], 'symmetric');


A_all = 1:L_inf_sum-k;
