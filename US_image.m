%------------------- Description ------------------
% Raw ultrasound images are preprocessed. Log compression followed by
% median filtering and gaussian filtering is done

function [image] = US_image(inp)
norm=inp./max(inp(:));
%norm=norm.^2;
log_P=20*log10(norm);
%log_P=medfilt2(log_P);
%image=(log_P-min(log_P,[],'all'))/(max(log_P,[],'all')-min(log_P,[],'all'));

image=preprocess_A(log_P);
%image=log_P;

end

