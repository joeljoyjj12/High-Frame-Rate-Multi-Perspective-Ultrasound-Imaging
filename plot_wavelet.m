function [] = plot_wavelet(cA,cH,cV,cD,sc)
if nargin<5
    sc=true;
end

figure();

subplot(2,2,1);
if sc==true
    imagesc(cA);
    colormap('gray');
else
    imshow(cA);
end


subplot(2,2,2);
if sc==true
    imagesc(cH);
    colormap('gray');
else
    imshow(cH);
end

subplot(2,2,3);
if sc==true
    imagesc(cV);
    colormap('gray');
else
    imshow(cV);
end

subplot(2,2,4);
if sc==true
    imagesc(cD);
    colormap('gray');
else
    imshow(cD);
end

