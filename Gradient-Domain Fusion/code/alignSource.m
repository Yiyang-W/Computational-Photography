function [im_s2, mask2] = alignSource(im_s, mask, im_t)
% im_s2 = alignSource(im_s, mask, im_t)
% Asks user for bottom-center position and outputs an aligned source image.

figure(1), hold off, imagesc(im_s), axis image
figure(2), hold off, imagesc(im_t), axis image


disp('choose target bottom-center location')
[tx, ty] = ginput(1);

disp('choose target top-center location')
[tx2, ty2] = ginput(1);
[im_sh,~,~] = size(im_s);
dist = sqrt((ty2-ty).^2+(tx2-tx).^2);
im_s = imresize(im_s, dist/im_sh);
mask = imresize(mask, dist/im_sh);
%rotation
A = [tx2-tx ty-ty2 0];
B = [0 im_sh 0];
C = cross(B, A)/ (dist*im_sh);
D = dot(B, A)/ (dist*im_sh);
alpha = asin(C(3));
if D < 0
    alpha = pi - alpha;
end
im_s = imrotate(im_s, alpha/pi*180);
figure; imagesc(im_s);
[h,w,~] = size(im_s);
mask = imrotate(mask, alpha/pi*180);
cen_y = (ty+ty2)/2;
cen_x = (tx+tx2)/2;
% points = [w/2 w/2 -w/2 -w/2; h/2 -h/2 h/2 -h/2];
% rot_mat = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];
% rot_points = rot_mat * points;
% cen2 = max(rot_points,[],2);
x_diff = cen_x - w/2;
y_diff = cen_y - h/2;

[y, x] = find(mask);
y1 = min(y)-1; y2 = max(y)+1; x1 = min(x)-1; x2 = max(x)+1;
im_s2 = zeros(size(im_t));



yind = (y1:y2);
yind2 = yind + round(y_diff);
xind = (x1:x2);
xind2 = xind + round(x_diff);

y = y + round(y_diff);
x = x + round(x_diff);
ind = y + (x-1)*size(im_t, 1);
mask2 = false(size(im_t, 1), size(im_t, 2));
mask2(ind) = true;

im_s2(yind2, xind2, :) = im_s(yind, xind, :);
im_t(repmat(mask2, [1 1 3])) = im_s2(repmat(mask2, [1 1 3]));

figure(1), hold off, imagesc(im_s2), axis image;
figure(2), hold off, imagesc(im_t), axis image;
drawnow;
