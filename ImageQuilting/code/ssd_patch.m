function ssd = ssd_patch(I, T, M)
T = im2double(T);
A = imfilter(I.^2, M); 
C = I;
C(:,:,1) = 2*imfilter(I(:,:,1), M.*T(:,:,1));
C(:,:,2) = 2*imfilter(I(:,:,2), M.*T(:,:,2));
C(:,:,3) = 2*imfilter(I(:,:,3), M.*T(:,:,3));
B = sum(sum((M.*T).^2));
ssd = A + B - C;
ssd = sum(ssd,3);
Isize = size(ssd);
ps = size(T,1);
ssd = ssd((1+ps)/2:Isize(1)-(1+ps)/2+1, (1+ps)/2:Isize(2)-(1+ps)/2+1, :);
% ssd = imfilter(I.^2, M) -2*imfilter(I, M.*T) + sum(sum((M.*T).^2));
% ssd = imfilter(I.^2, M) -2*imfilter(I, M.*T);