%------------------- Description ------------------
% Ultrasound image mosaicing 

Imgs_m=load('Dataset/02042023/Img_Data.mat');
%Imgs_m=load('Dataset/Images_28_Raw/Img_Data.mat');

%Imgs_m=Imgs_m.Img_data;
Imgs_m=Imgs_m.newImgArr;
Imgs_m=rescale(Imgs_m);

%% Padding part

s1=2000;
s2=1200;
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
a=size(ImgArr,1);
b=size(ImgArr,2);
m=size(Imgs_m,1);
n=size(Imgs_m,2);
x_c=430;

%%
rot_img_arr(:,:,1)=ImgArr(:,:,1);

rot_angles=[0,15,30,45,60,75,120,135,150,175,190,205,250,275,290,305,320,335];

fusedImage=rot_img_arr(:,:,1);
%figure(2);
%imshow(fusedImage);
%pause(2);
for i=2:18
    rot_img_arr(:,:,i)=rotate_image(ImgArr(:,:,i),x_c+(a-m)/2,rot_angles(i));
    fusedImage=max(fusedImage,rot_img_arr(:,:,i));
end

%%
tr_rot_img_arr=rot_img_arr;
%%
% The user needs to manually give the translation values for each of the
% rotated image
for i=2:18
    user_inp=true;
    while (user_inp==true)
        disp(i);
        x_inp=input('Enter x-coordinate : ');
        y_inp=input('Enter y-coordinate : ');
        J = imtranslate(rot_img_arr(:,:,i),[x_inp, y_inp]);

        figure();
        imshowpair(J,tr_rot_img_arr(:,:,i-1),"falsecolor");

        tr_rot_img_arr(:,:,i)=max(tr_rot_img_arr(:,:,i-1),J);

        user_inp=input(['Do you want to redo translation for image (' num2str(i) ') : ']);
    end
    figure();
    imshow(tr_rot_img_arr(:,:,i));
end

mosaiced_image=tr_rot_img_arr(:,:,end); % Final fused image
%%
function rot_img=rotate_image(img,y_c,theta)
[m,n]=size(img);
img_pad=zeros(y_c*2-1,n);
img_pad(1:m,1:n)=img;
rot_img=imrotate(img_pad,theta,'bilinear','crop');
rot_img=rot_img(1:m,1:n);
end
