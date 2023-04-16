%------------------- Description ------------------
% Similarity and Energy calculation for wavelet fusion

function [I_fused] = wavelet_fusion(LD1_reg,LD1_f)

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
end

