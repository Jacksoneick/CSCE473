function output_image = MarrHildreth(image, sigma)
image = double(image);

% Size of filter
N = abs(sigma*3)*2 + 1;
% Create the log filter
filter = fspecial('log', N, sigma);
output_image = imfilter(image,filter,'replicate');

output_image(output_image > 0) = 1;
output_image(output_image < 0) = 0;

%find the zero crossings
cross_filter = [0 1 0; 1 100 1; 0 1 0];
output_image = imfilter(output_image,cross_filter,'replicate');
output_image(output_image < 100) = 0;
output_image = mod(output_image,100);
output_image(4 < output_image < 0) = 1; 
output_image(output_image == 4) = 0;
end