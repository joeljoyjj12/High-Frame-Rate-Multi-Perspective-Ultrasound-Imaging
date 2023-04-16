%------------------- Description ------------------
% Here 2 images are given as input and the function returns the fused image 
% based on a wavelet-decomposition fusion strategy

function [fused_image] = Fusion_2_Imgs(I_fixed_dup,I2_reg)

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

end

