%Canny Edge Function
function CannyEdge(image, sigma, highthresh, lowthresh)

%Need a Gaussian Blur(Sigma Notation used here)
HighT = highthresh;
LowT = lowthresh;
figure;imshow(image);
title('Original Image');
image = double(image);

GaussianImage = imgaussfilt(image,sigma);


%Our derivative of the Gaussian, set up Sobel operators
Sobelx = [-1 0 +1; -2 0 +2; -1 0 +1];
Sobely = [-1 -2 -1; 0 0 0; +1 +2 +1];

%Convultion via horizontal and vertical filter
X_Direction = conv2(GaussianImage,double(Sobelx), 'same');

Y_Direction = conv2(GaussianImage,double(Sobely), 'same');


Magnitude = sqrt(X_Direction.^2 + Y_Direction.^2);
angle = atan2(Y_Direction,X_Direction)*180/pi;



%Non-Maximum Suppression
[h,w] = size(image);
output = zeros(h,w);
x = [0 1];
for i=2:h-1 % row
    for j=2:w-1 % col         
            if (angle(i,j)>=-22.5 && angle(i,j)<=22.5) || ...
                (angle(i,j)<-157.5 && angle(i,j)>=-180)
                if (Magnitude(i,j) >= Magnitude(i,j+1)) && ...
                   (Magnitude(i,j) >= Magnitude(i,j-1))
                    output(i,j)= Magnitude(i,j);
                else
                    output(i,j)=0;
                end
            elseif (angle(i,j)>=22.5 && angle(i,j)<=67.5) || ...
                (angle(i,j)<-112.5 && angle(i,j)>=-157.5)
                if (Magnitude(i,j) >= Magnitude(i+1,j+1)) && ...
                   (Magnitude(i,j) >= Magnitude(i-1,j-1))
                    output(i,j)= Magnitude(i,j);
                else
                    output(i,j)=0;
                end
            elseif (angle(i,j)>=67.5 && angle(i,j)<=112.5) || ...
                (angle(i,j)<-67.5 && angle(i,j)>=-112.5)
                if (Magnitude(i,j) >= Magnitude(i+1,j)) && ...
                   (Magnitude(i,j) >= Magnitude(i-1,j))
                    output(i,j)= Magnitude(i,j);
                else
                    output(i,j)=0;
                end
            elseif (angle(i,j)>=112.5 && angle(i,j)<=157.5) || ...
                (angle(i,j)<-22.5 && angle(i,j)>=-67.5)
                if (Magnitude(i,j) >= Magnitude(i+1,j-1)) && ...
                   (Magnitude(i,j) >= Magnitude(i-1,j+1))
                    output(i,j)= Magnitude(i,j);
                else
                    output(i,j)=0;
                end
            end
    end
end

 %get all the edges

%Hystersis Thresholding (0-1 scale)


Thresh_Low = LowT * max(max(output));
Thresh_High = HighT * max(max(output));

Final_Product = zeros (h, w); %Our Threshold Matrix starts out like this

for i = 1  : h
    for j = 1 : w
        if (output(i, j) < Thresh_Low)
            Final_Product(i, j) = 0;
        elseif (output(i, j) > Thresh_High)
            Final_Product(i, j) = 1;
        %Looks for points connecting to an edge to continue along the edge
        elseif ( output(i+1,j)>Thresh_High || output(i-1,j)>Thresh_High || output(i,j+1)>Thresh_High || output(i,j-1)>Thresh_High || output(i-1, j-1)>Thresh_High || output(i-1, j+1)>Thresh_High || output(i+1, j+1)>Thresh_High || output(i+1, j-1)>Thresh_High)
            Final_Product(i,j) = 1;
        end;
    end;
end;

edge_final = uint8(Final_Product.*255);
%Show our final canny result
figure, imshow(edge_final);