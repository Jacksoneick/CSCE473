function create_hybrids()
%CREATE_HYBRIDS Summary of this function goes here
%   Detailed explanation goes here

image_one = im2single(imread('data/dog.bmp'));
image_two = im2single(imread('data/cat.bmp'));

cutoff_frequency = 7.5;

% build gaussian filter with specificed standard deviation
gaussian_filter = fspecial('gaussian', cutoff_frequency*4, cutoff_frequency);


low = my_imfilter(image_one, gaussian_filter);

high = image_two - my_imfilter(image_two, gaussian_filter);

% combine the low and high frequencies
hybrid_image = low + high;

new = vis_hybrid_image(hybrid_image);

imshow(new);
end

