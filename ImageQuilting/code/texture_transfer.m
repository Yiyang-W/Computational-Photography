function out_put = texture_transfer(src, tar, patchsize, overlap, tol, alpha)

targ = rgb2gray(tar);
srcg = rgb2gray(src);

src_sin = im2single(src);
srcg_sin = im2single(srcg);
tar_sin = im2single(tar);
targ_sin = im2single(targ);

tar_pretend = tar_sin;
tar_pretend(:,:,1) = targ_sin;
tar_pretend(:,:,2) = targ_sin;
tar_pretend(:,:,3) = targ_sin;

src_pretend = src_sin;
src_pretend(:,:,1) = srcg_sin;
src_pretend(:,:,2) = srcg_sin;
src_pretend(:,:,3) = srcg_sin;

m0 = zeros(patchsize, patchsize);
m1 = [ones(patchsize, overlap) zeros(patchsize, patchsize-overlap)];
m2 = [ones(overlap, patchsize);zeros(patchsize-overlap, patchsize)];
m3 = m1 | m2;
mask_tar = ones(patchsize, patchsize);
out_put = zeros(size(tar));
out_put = uint8(out_put);

tar_size = size(targ);
times = (tar_size-overlap) / (patchsize-overlap);
src_size = size(src(:,:,1));
% aaa = src_size - patchsize;


for i = 1:times(1)
    for j = 1:times(2)
        if i == 1 && j == 1
            mask_ol = m0;
        elseif i == 1
            mask_ol = m1;
        elseif j == 1
            mask_ol = m2;
        else
            mask_ol = m3;
        end
        row = (i-1)*(patchsize-overlap) + 1;
        col = (j-1)*(patchsize-overlap) + 1;
        ssd_ol = ssd_patch(src_sin, out_put(row:row+patchsize-1, col:col+patchsize-1, :) , double(mask_ol));
        ssd_tar = ssd_patch(src_pretend, tar_pretend(row:row+patchsize-1, col:col+patchsize-1, :) , double(mask_tar));
        ssd = (1-alpha) * ssd_ol + alpha * ssd_tar;
        
        [r, c] = choose_sample(ssd, tol);
        patch = src(r:r+patchsize-1, c:c+patchsize-1, :);
        if i == 1
            olpart1 = out_put(1:patchsize, col:col+overlap-1,:);
            olpart2 = patch(1:patchsize, 1:overlap, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask0 = transpose(cut(transpose(err)));
            mask = [mask0 ones(patchsize, patchsize-overlap)];
        elseif j == 1
            olpart1 = out_put(row:row+overlap-1, 1:patchsize,:);
            olpart2 = patch(1:overlap, 1:patchsize, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask0 = cut(err);
            mask = [mask0;ones(patchsize-overlap, patchsize)];
        else
            olpart1 = out_put(row:row+patchsize-1, col:col+overlap-1,:);
            olpart2 = patch(1:patchsize, 1:overlap, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask10 = transpose(cut(transpose(err)));
            mask1 = [mask10 ones(patchsize, patchsize-overlap)];
            
            olpart1 = out_put(row:row+overlap-1, col:col+patchsize-1,:);
            olpart2 = patch(1:overlap, 1:patchsize, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask20 = cut(err);
            mask2 = [mask20;ones(patchsize-overlap, patchsize)];
            
            mask = mask1 & mask2;
        end
        mask_ = zeros([size(mask) 3]);
        mask_(:,:,1) = mask;
        mask_(:,:,2) = mask;
        mask_(:,:,3) = mask;
        mask_ = uint8(mask_);
        tmplt = out_put((i-1)*(patchsize-overlap)+1:(i-1)*(patchsize-overlap)+patchsize, (j-1)*(patchsize-overlap)+1:(j-1)*(patchsize-overlap)+patchsize,:) .* uint8(~mask_);
        patch_cut = patch .* mask_;
        out_put((i-1)*(patchsize-overlap)+1:(i-1)*(patchsize-overlap)+patchsize, (j-1)*(patchsize-overlap)+1:(j-1)*(patchsize-overlap)+patchsize,:) = patch_cut + tmplt;
    end
end

