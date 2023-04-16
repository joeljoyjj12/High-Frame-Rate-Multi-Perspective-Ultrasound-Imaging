%------------------- Description ------------------
% Fusion of multi-perspective images. Stepwise registration and fusion is
% carried out

%% Loading Data
%Imgs_m=load('Dataset\360\Img_data_2.mat');
%Imgs_m=load('Dataset\360\Img_data.mat');
Imgs_m=load('Dataset/02042023/Img_Data.mat');

%Imgs_m=Imgs_m.Img_data;
Imgs_m=Imgs_m.newImgArr;

%%
% !!!!!! Use this block only when direct window images are used 
Imgs_m=rescale(Imgs_m);

%%
% Don't attempt rescaling more than once
for i=1:size(Imgs_m,3)
    Imgs_m(:,:,i)=rescale(US_image(Imgs_m(:,:,i)));
end
%% Preprocessing Images

s1=1200;%2000;
s2=800;%1500;
m=size(Imgs_m,1);
n=size(Imgs_m,2);

% Initialize output array
padded_array = zeros(s1, s2, size(Imgs_m,3));

% Loop over each image in the array and pad it
for i = 1:size(Imgs_m, 3)
    % Determine amount of padding needed on each side
    pad1 = floor((s1 - m) / 2);
    pad2 = floor((s2 - n) / 2);
    
    % Pad image in both directions
    padded_array(:,:,i) = padarray(Imgs_m(:,:,i), [pad1, pad2], 0, 'both');
end

ImgArr=padded_array;

%%
clear tr_mat
tr_mat(size(ImgArr,3))=simtform2d;
regImg_mat=zeros(size(ImgArr));

Transf_Imgs=ImgArr;
%%
for i=1:size(ImgArr,3)-1
    user_inp=true;
    while (user_inp==true)
        disp(i);
        [tr_mat(i),Transf_Imgs(:,:,i+1),regImg_mat(:,:,i)]=Image_Fusion_360(Transf_Imgs(:,:,i),ImgArr(:,:,i+1));
        plot_img(Transf_Imgs(:,:,i+1));
        tr_mat(i).RotationAngle
        user_inp=input(['Do you want to redo registration for images (' num2str(i) ',' num2str(i+1) ') : ']);
    end
end






%% Transforming images using the transformation matrix array
Transf_Imgs=zeros(size(ImgArr));
Transf_Imgs(:,:,1)=ImgArr(:,:,1);

Rfixed = imref2d(size(ImgArr(:,:,1)));

for i=1:size(ImgArr,3)-1
    Transf_Imgs(:,:,i+1)=ImgArr(:,:,i+1);
    for j=i:-1:1
        Transf_Imgs(:,:,i+1) = imwarp(Transf_Imgs(:,:,i+1),tr_mat(j),OutputView=Rfixed,FillValues=0);
    end
end

%% Modifying transformation matrices by taking all successive transformations



%%
function []=registration(ind,ImgArr,tr_mat,regImg_mat)
    disp(ind);
    [tr_mat(ind),if1,regImg_mat(ind)]=Image_Fusion_360(ImgArr(:,:,ind),ImgArr(:,:,ind+1));  

    plot_img(reg_mat(ind));
end

function []=plot_img(img)
    figure();
    imshow(img);
    colormap('gray');
end