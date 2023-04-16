%------------------- Description ------------------
% Similar to Image_Fusion.m. Fusion based on maximum of intensity values.

function [t,fused_image,reg_img] = Image_Fusion(I_fixed_dup,I_moving_dup)

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
reg_img=registered;
%registered = imwarp(moving,t,FillValues=0);
%registered = imwarp(moving,t,FillValues=0);

%Show results
%imshowpair(fixed,registered,"blend");
figure();
imshowpair(fixed,registered,"falsecolor");

%%
%figure();
%imagesc(min(fixed,registered));
%colormap('gray');

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


LL1_fused=average(LL1_reg,LL1_f,1,false);
LH1_fused=wavelet_fusion(LH1_reg,LH1_f);
LV1_fused=wavelet_fusion(LV1_reg,LV1_f);
LD1_fused=wavelet_fusion(LD1_reg,LD1_f);


%{
LL1_fused=max(LL1_reg,LL1_f);
LH1_fused=average(LH1_reg,LH1_f,0);
LV1_fused=average(LV1_reg,LV1_f,0);
LD1_fused=average(LD1_reg,LD1_f,0);
%}

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
%----------------------------------------------------------%
%---------------------------------------------------------------


% Maximum value based fusion
fused_image=max(reg_img,I_fixed_dup);
end

