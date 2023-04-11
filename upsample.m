function R = upsample(I,odd,filter)

% increase resolution
I = padarray(I,[1 1 0],'replicate'); % pad the image with a 1-pixel border
% r = 2*size(I,1);
% c = 2*size(I,2);
r = 2*size(I,1);
c = 2*size(I,2);

k = size(I,3);
R = zeros(r,c,k);
R(1:2:r, 1:2:c, :) = 4*I; % increase size 2 times; the padding is now 2 pixels wide
% interpolate, convolve with separable filter
R = imfilter(R,filter);     %horizontal
R = imfilter(R,filter');    %vertical

% remove the border
%R = R(3:r - 2 - odd(1), 3:c - 2 - odd(2), :);
R = R(3:r - 2 - odd(1), 3:c - 2 - odd(2), :);
