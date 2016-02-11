function [fimage] = gaussfilt(image,sigma);
%% matlab recap of the Fiji gaussian blur function
% input is (image,sigma)
% output is [filteredimage]

h = ceil(4*sigma);
f = fspecial('gaussian',h,sigma);
fimage = imfilter(image,f);

end