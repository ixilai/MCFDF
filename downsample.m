function R = downsample(I, filter)

border_mode = 'symmetric';
%filter='Gaussian';
% low pass, convolve with separable filter
 R = imfilter(I,filter,border_mode);     %horizontal
 R = imfilter(R,filter',border_mode);    %vertical
%figure,imshow(R);

% decimate
r = size(I,1);
c = size(I,2);
R = R(1:2:r, 1:2:c, :);  
