function medim = morph(im1, im2, im1pts, im2pts, tri, warp_frac, dissolve_frac)
% this produces a warp between im1 and im2 using point correspondences 
% defined in im1_pts and im2_pts (which are both n-by-2 matrices of (x,y) locations) 
% and the triangulation structure tri. 
% The parameters warp_frac and dissolve_frac control shape warping and cross-dissolve, respectively.

[r, c, ddd] = size(im1);
midpts = warp_frac * im2pts + (1-warp_frac) * im1pts;
A1 = zeros(3,3,size(tri,1));
A2 = zeros(3,3,size(tri,1));
medim = zeros(r,c,ddd);
im1 = double(im1);
im2 = double(im2);

for i = 1:size(tri,1)
    ps1 = [im1pts(tri(i,1),:); im1pts(tri(i,2),:); im1pts(tri(i,3),:)];
    ps2 = [im2pts(tri(i,1),:); im2pts(tri(i,2),:); im2pts(tri(i,3),:)];
    psm = [midpts(tri(i,1),:); midpts(tri(i,2),:); midpts(tri(i,3),:)];
    A1(:,:,i) = computeAffine(psm, ps1);
    A2(:,:,i) = computeAffine(psm, ps2);
end


X = [1:c]';
for i = 1:r
    Y = ones(c,1) * i;
%     ind1 = mytsearch(im1pts(:,1), im1pts(:,2), tri, X, Y);
%     ind2 = mytsearch(im2pts(:,1), im2pts(:,2), tri, X, Y);
    index = mytsearch(midpts(:,1), midpts(:,2), tri, X, Y);
    for j = 1:c
        if isnan(index(j))
            medim(i,j,:) = dissolve_frac*im2(i,j,:) + (1-dissolve_frac)*im1(i,j,:);
        else
%             p1 = int16(floor(A1(:,:,index(j)) * [j;i;1]+1))
%             p2 = int16(floor(A2(:,:,index(j)) * [j;i;1]+1))
            p1 = round(A1(:,:,index(j)) * [j;i;1]);
            p2 = round(A2(:,:,index(j)) * [j;i;1]);

            medim(i,j,:) = dissolve_frac*im2(p2(2),p2(1),:) + (1-dissolve_frac)*im1(p1(2),p1(1),:);
        end
    end
end

medim = uint8(medim);
    