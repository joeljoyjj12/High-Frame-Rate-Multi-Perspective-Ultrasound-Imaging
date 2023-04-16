%----------------------------------------------------------------------%
%----------------------------- Part A ---------------------------------%
%----------------------------------------------------------------------%
%{
    Part A involves coarse registration of the 2 images taken.
    Uses cpselect to get the transform matrix and then transforms
    the moving image
%}

%Data=importdata('Dataset_Connector\28_11_2022\dataset_P1_multi_frame_connector_PwSa7.6MHz_28_Nov_2022\dataset_PW1_28_Nov_2022_12_37_43_PM.mat');

%Data_P1=importdata('Dataset_Connector\28_11_2022\dataset_P1_sample_connector_PwSa7.6MHz_28_Nov_2022\dataset_PW1_28_Nov_2022_12_20_40_PM.mat');
%Data_P2=importdata('Dataset_Connector\28_11_2022\dataset_P2_sample_connector_PwSa7.6MHz_28_Nov_2022\dataset_PW1_28_Nov_2022_12_09_25_PM.mat');

%file_name='Dataset\23022023\dataset_Wrist_semi_c_2_PwSa7.6MHz_23_Feb_2023\dataset_PW1_23_Feb_2023_ 1_03_18_PM.mat';
%file_name='Dataset\23022023\dataset_Wrist_semi_c_PwSa7.6MHz_23_Feb_2023\dataset_PW1_23_Feb_2023_12_56_21_PM.mat';
%file_name='Dataset\18032023\dataset_PW1_18_Mar_2023_11_50_00_AM-001.mat';
%file_name='Dataset\31032023\dataset_PW1_31_Mar_2023_ 2_11_31_PM-002.mat';
%file_name='Dataset\31032023\dataset_PW1_31_Mar_2023_ 4_59_34_PM.mat';
%file_name='Dataset\14042023\dataset_Wrist_360_8_PwSa7.6MHz_14_Apr_2023\dataset_PW1_14_Apr_2023_11_30_26_PM.mat';
load('Dataset\Images_28_Raw\dataset_Wrist_360_18_PwSa7.6MHz_02_Apr_2023\dataset_PW1_02_Apr_2023_12_01_59_PM.mat');
file_name='Dataset\Images_28_Raw\dataset_Wrist_360_18_PwSa7.6MHz_02_Apr_2023\dataset_PW1_02_Apr_2023_12_01_59_PM.mat';
Data=importdata(file_name);

%%
I=Data.ImgData;
ind_new=18;
abcd(1:512,1:128,ind_new)=rescale(US_image(I(:,:,4)));
%%
%I=Imgs;
%img_ind=[120,360,500,600,750,900,1100,1300];
%img_ind=[900,950,1000,1050];
%img_ind=[4360,4380,4410,4440,4470,4500,4540];
%img_ind=[4680,4710,4790,4840,4920];
%img_ind=[4830,4870];

I_fixed=US_image(Imgs(:,:,900));
I_moving=US_image(Imgs(:,:,1100));
I_moving_2=US_image(Imgs(:,:,1300));

for i=1:length(img_ind)
    figure();
    imshow(rescale(US_image(Imgs(:,:,img_ind(i)))));
    %imshow(I_fixed);
    colormap('gray');
    title('Image '+string(img_ind(i)));
    %clim([0.2 1]);
end

%%
I_fixed=(I_fixed-min(I_fixed(:)))/(max(I_fixed(:))-min(I_fixed(:)));
I_moving=(I_moving-min(I_moving(:)))/(max(I_moving(:))-min(I_moving(:)));

I_moving_2=(I_moving_2-min(I_moving_2(:)))/(max(I_moving_2(:))-min(I_moving_2(:)));

s1=800;
s2=300;

I_fixed_dup=zeros(s1,s2);
I_moving_dup=zeros(s1,s2);
I_moving_2_dup=zeros(s1,s2);

m=size(I_fixed,1);n=size(I_fixed,2);

I_fixed_dup((s1-m)/2:(s1-m)/2+m-1,(s2-n)/2:(s2-n)/2+n-1)=I_fixed;
I_moving_dup((s1-m)/2:(s1-m)/2+m-1,(s2-n)/2:(s2-n)/2+n-1)=I_moving;
I_moving_2_dup((s1-m)/2:(s1-m)/2+m-1,(s2-n)/2:(s2-n)/2+n-1)=I_moving_2;

%%
[t1,if1,reg_if1]=Image_Fusion(I_fixed_dup,I_moving_dup);

%%
[t2,if2,reg_if2]=Image_Fusion(I_moving_dup,I_moving_2_dup);
%%
figure();
%imagesc(I_fixed);
imagesc(I_fixed_dup);
colormap('gray');
title('fixed');

figure();
%imagesc(I_moving);
imagesc(I_moving_dup);
colormap('gray');
title('moving');

figure();
imshowpair(I_fixed_dup,reg_if1,"falsecolor");

figure();
%imagesc(I_moving);
imagesc(medfilt2(medfilt2(if1)));
caxis([0.1,1]);
colormap('gray');
title('Fused'); 

%%
%%
figure();
%imagesc(I_fixed);
imshow(I_moving_dup);
colormap('gray');
title('fixed');

figure();
%imagesc(I_moving);
imshow(I_moving_2_dup);
colormap('gray');
title('moving');

figure();
imshowpair(I_moving_dup,reg_if2,"falsecolor");

figure();
%imagesc(I_moving);
imshow(medfilt2(medfilt2(if2)));
caxis([0.1,1]);
colormap('gray');
title('Fused'); 
%%
%fixed=I_fixed;
fixed=I_fixed_dup;
%moving=I_moving;
moving=I_moving_dup;

% Select control points
[mp,fp]=cpselect(moving,fixed,Wait=true);

%%
% Infer Geometric transformation
%t = fitgeotform2d(mp,fp,"projective");
%t = fitgeotform2d(mp,fp,"affine");
t = fitgeotform2d(mp,fp,"similarity");

%%
% Transform Unregistered image
Rfixed = imref2d(size(fixed));
registered = imwarp(moving,t,OutputView=Rfixed,FillValues=0);
%registered = imwarp(moving,t,FillValues=0);
%registered = imwarp(moving,t,FillValues=0);

%Show results
%imshowpair(fixed,registered,"blend");
imshowpair(fixed,registered,"falsecolor");

%%
figure();

subplot(1,3,1);
imagesc(moving);
colormap('gray');
%imshow(moving);
title('Unregistered');

subplot(1,3,2);
imagesc(registered);
colormap('gray');
%imshow(registered);
title('registered');

subplot(1,3,3);
imagesc(fixed);
colormap('gray');
%imshow(fixed);
title('Fixed Image');

%%
%------------------------------------------------------------------------%
%--------------------------Fine registration-----------------------------%
[optimizer,metric] = imregconfig("multimodal");
optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

movingRegistered = imregister(registered,fixed,"affine",optimizer,metric);
%movingRegistered = imregister(I_moving_dup,I_fixed_dup,"similarity",optimizer,metric);
%%
imshowpair(I_fixed_dup,movingRegistered,"falsecolor");

figure();
imagesc(I_fixed_dup);
colormap('gray');
title('Fixed');

figure();
imagesc(I_moving_dup);
colormap('gray');
title('Moving');

figure();
imagesc(movingRegistered);
colormap('gray');
title('Registered');

%%
%----------------------------------------------------------------------%
%----------------------------- Part B ---------------------------------%
%----------------------------------------------------------------------%
%{
    Image fusion using DWT decomposition
%}

wv = 'haar';
lv = 2;
xfusmean = wfusimg(I_fixed_dup,registered,wv,lv,'mean','mean');

xfusmaxmin = wfusimg(I_fixed_dup,registered,wv,lv,'max','min');

%%

I2_reg=registered;

[LL1_reg,LH1_reg,LV1_reg,LD1_reg] = dwt2(I2_reg,'haar');
%plot_wavelet(LL1_reg,LH1_reg,LV1_reg,LD1_reg);
[LL2_reg,LH2_reg,LV2_reg,LD2_reg] = dwt2(LL1_reg,'haar');
%plot_wavelet(LL2_reg,LH2_reg,LV2_reg,LD2_reg);

%%
[LL1_f,LH1_f,LV1_f,LD1_f] = dwt2(I_fixed_dup,'haar');
%plot_wavelet(LL1_f,LH1_f,LV1_f,LD1_f);
[LL2_f,LH2_f,LV2_f,LD2_f] = dwt2(LL1_f,'haar');
%plot_wavelet(LL2_f,LH2_f,LV2_f,LD2_f);

%%

%------------------ 1 Level DWT ---------------------------%
%----------------------------------------------------------%
LL1_fused=average(LL1_reg,LL1_f,1);
LH1_fused=wavelet_fusion(LH1_reg,LH1_f);
LV1_fused=wavelet_fusion(LV1_reg,LV1_f);
LD1_fused=wavelet_fusion(LD1_reg,LD1_f);
fused_image=idwt2(LL1_fused,LH1_fused,LV1_fused,LD1_fused,'haar');
%----------------------------------------------------------%
%----------------------------------------------------------%

%{
%------------------- 2 Level DWT --------------------------%
%----------------------------------------------------------%
LD1_fused=wavelet_fusion(LD1_reg,LD1_f);
LH1_fused=wavelet_fusion(LH1_reg,LH1_f);
LV1_fused=wavelet_fusion(LV1_reg,LV1_f);

LL2_fused=average(LL2_reg,LL2_f,1);
LH2_fused=wavelet_fusion(LH2_reg,LH2_f);
LV2_fused=wavelet_fusion(LV2_reg,LV2_f);
LD2_fused=wavelet_fusion(LD2_reg,LD2_f);

LL1_fused=idwt2(LL2_fused,LH2_fused,LV2_fused,LD2_fused,'haar');
fused_image=idwt2(LL1_fused,LH1_fused,LV1_fused,LD1_fused,'haar');
%}


plot_wavelet(LL1_fused,LH1_fused,LV1_fused,LD1_fused);
%----------------------------------------------------------%
%---------------------------------------------------------------

%%
figure();
%imagesc(fused_image(20:445,155:348),[0,1]);
imshow(fused_image(20:445,155:348),[0,0.9]);
set(gca,'xtick',[],'ytick',[]);
%colormap('gray');
title('Fused Image');

figure();
%imagesc(I_fixed,[0,1]);
imshow(I_fixed,[0,1]);
set(gca,'xtick',[],'ytick',[]);
%colormap('gray');
title('Fixed Image (Image 1)');

figure();
%imagesc(I_moving,[0,1]);
imshow(I_moving,[0,1]);
set(gca,'xtick',[],'ytick',[]);
%colormap('gray');
title('Moving Image (Image 2)');

%%
figure();

subplot(3,1,1);
histogram(I_fixed,BinLimits=[0.2,1]);
ylim([0 3000]);
title('Fixed Image');

cond=(fused_image<0);
fused_image_2=fused_image;
fused_image_2(cond)=0;
subplot(3,1,2);
histogram(fused_image_2(20:445,155:348),BinLimits=[0.2,1]);
ylim([0 3000]);
title('Fused Image');

subplot(3,1,3);
histogram(I_moving,BinLimits=[0.2,1]);
ylim([0 3000]);
title('Moving Image');

% All histograms in same plot
figure();
histogram(I_fixed,BinLimits=[0.2,1]);
hold on;

histogram(I_moving,BinLimits=[0.2,1]);
hold on;

histogram(fused_image_2(20:445,155:348),BinLimits=[0.2,1]);

legend('Fixed','Moving','Fused');


figure();
histogram(fixed_image,'Normalization','cdf');

%%

% Regional Energy E(x,y)
w=1/16*[1 2 1;2 4 2;1 2 1];
I_reg=LD1_reg;
I_f=LD1_f;
Q_reg=I_reg.^2;
Q_f=I_f.^2;

E_reg=conv2(Q_reg,w,'same');
E_f=conv2(Q_f,w,'same');

% Similarity
P=LD1_reg.*LD1_f;
S=2*conv2(P,w,'same');
S=S./(E_reg+E_f);

S(isnan(S))=1;

% Fused subband
T=0.65; % Threshold

%%
[m,n]=size(S);
I_fused=zeros(m,n);

W_min=(S-T)/(2*(1-T));
W_max=1-W_min;
%%
c1=(S<=T)&(E_reg>E_f);
c2=(S<=T)&(E_reg<=E_f);
c3=(S>T)&(E_reg>E_f);
c4=(S>T)&(E_reg<=E_f);

I_fused(c1)=I_reg(c1);
I_fused(c2)=I_f(c2);
I_fused(c3)=W_max(c3).*I_reg(c3)+W_min(c3).*I_f(c3);
I_fused(c4)=W_min(c4).*I_reg(c4)+W_max(c4).*I_f(c4);

%{
for i=1:m
    for j=1:n
        if(S(i,j)<=T)
            if(E_reg(i,j)>E_f(i,j))
                I_fused(i,j)=I_reg(i,j);
            else
                I_fused(i,j)=I_f(i,j);
            end
        else
            if(E_reg(i,j)>E_f(i,j))
                I_fused(i,j)=W_max(i,j)*I_reg(i,j)+W_min(i,j)*I_f(i,j);
            else
                I_fused(i,j)=W_min(i,j)*I_reg(i,j)+W_max(i,j)*I_f(i,j);
            end
        end
    end
end
%}

%%
% Show fused DWT
figure();
imagesc(I_fused);
colormap('gray');
title('Fused');

figure();
imagesc(I_f);
colormap('gray');
title('Fixed');

figure();
imagesc(I_reg);
colormap('gray');
title('Registered');

