function [magnitude, orientation] = filters(image, filter_type, threshold)
image = double(image);
filter = fspecial(filter_type);
if ~strcmpi(filter_type,'laplacian')
    
    s1 = imfilter(image,filter,'replicate');
    s2 = imfilter(image,filter','replicate');
    magnitude = sqrt(s1.^2 + s2.^2);
    orientation = atan(s2./s1);
    orientation(isnan(orientation)) = 0;
    thresh = magnitude <= threshold;
    magnitude(thresh) = 0;
    orientation(thresh) = 0;
else
   orientation = NaN;
   magnitude = imfilter(image,filter,'replicate');
   magnitude(magnitude <= threshold) = 0;
end