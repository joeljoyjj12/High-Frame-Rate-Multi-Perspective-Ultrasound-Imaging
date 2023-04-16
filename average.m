function [LL1_fused] = average(LL1_reg,LL1_f,max_c,show_img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if show_img
    figure();
    imagesc(LL1_reg);
    colormap('gray');
    title('average registered');
    
    figure();
    imagesc(LL1_f);
    colormap('gray');
    title('average fixed');
end

LL1_fused=(LL1_reg+LL1_f)/2;

cond=(LL1_reg==0)|(LL1_f==0);

if max_c==1
    LL1_fused(cond)=max(LL1_reg(cond),LL1_f(cond));
end

%{
[r,c]=size(LL1_reg);
LL1_fused=zeros(r,c);
for i=1:r
    for j=1:c
        if LL1_f(i,j)==0 || LL1_reg(i,j)==0
            LL1_fused(i,j)=0.5*max(LL1_fused(i,j),LL1_reg(i,j));
        else
            LL1_fused(i,j)=(LL1_fused(i,j)+LL1_reg(i,j))/2;
        end
    end
end
%}


if show_img
    figure();
    imagesc(LL1_fused);
    colormap('gray');
    title('fused average');
end

end

