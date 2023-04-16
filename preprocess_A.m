function [out] = preprocess_A(img)
out=img;
% Apply median filter to remove salt and pepper noise
median_filtered = medfilt2(img);
out=median_filtered;

% Apply a Gaussian filter for further smoothing
gaussian_filtered = imgaussfilt(median_filtered);

%out=gaussian_filtered;

% Apply a Sobel filter to enhance edges
%sobel_filtered = edge(gaussian_filtered,'sobel',0.2);

% Apply a binary threshold
%binary_filtered = imbinarize(sobel_filtered, 0.5);

% Invert the image
%inverted_filtered = imcomplement(binary_filtered);

% Show the result
%out=inverted_filtered;
end

