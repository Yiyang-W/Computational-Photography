function out_put = quilt_cut(sample, outsize, ps, ol, tol)
m1 = [ones(ps, ol) zeros(ps, ps-ol)];
m2 = [ones(ol, ps);zeros(ps-ol, ps)];
m3 = m1 | m2;
out_put = zeros(outsize, outsize, 3);
out_put = uint8(out_put);

times = (outsize-ol) / (ps-ol);
sample_size = size(sample(:,:,1));
aaa = sample_size - ps;

imsin = im2single(sample);

for i = 1:times
    for j = 1:times
        if i == 1 && j == 1
            x = uint32(rand() * aaa(2))+1;
            y = uint32(rand() * aaa(1))+1;
            patch = sample(y:y+ps-1,x:x+ps-1,:);
            out_put(1:ps, 1:ps,:) = patch(:,:,:);
            continue
        elseif i == 1
            M = m1;
        elseif j == 1
            M = m2;
        else
            M = m3;
        end
        row = (i-1)*(ps-ol) + 1;
        col = (j-1)*(ps-ol) + 1;
        ssd = ssd_patch(imsin, out_put(row:row+ps-1, col:col+ps-1, :) , double(M));        
        [r, c] = choose_sample(ssd, tol);
        patch = sample(r:r+ps-1, c:c+ps-1, :);
        if i == 1
            olpart1 = out_put(1:ps, col:col+ol-1,:);
            olpart2 = patch(1:ps, 1:ol, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask0 = transpose(cut(transpose(err)));
            mask = [mask0 ones(ps, ps-ol)];
        elseif j == 1
            olpart1 = out_put(row:row+ol-1, 1:ps,:);
            olpart2 = patch(1:ol, 1:ps, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask0 = cut(err);
            mask = [mask0;ones(ps-ol, ps)];
        else
            olpart1 = out_put(row:row+ps-1, col:col+ol-1,:);
            olpart2 = patch(1:ps, 1:ol, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask10 = transpose(cut(transpose(err)));
            mask1 = [mask10 ones(ps, ps-ol)];
            
            olpart1 = out_put(row:row+ol-1, col:col+ps-1,:);
            olpart2 = patch(1:ol, 1:ps, :);
            
            olpart1 = im2single(olpart1);
            olpart2 = im2single(olpart2);
            
            err = sum((olpart1 - olpart2).^2, 3);
            mask20 = cut(err);
            mask2 = [mask20;ones(ps-ol, ps)];
            
            mask = mask1 & mask2;
        end
        mask_ = zeros([size(mask) 3]);
        mask_(:,:,1) = mask;
        mask_(:,:,2) = mask;
        mask_(:,:,3) = mask;
        mask_ = uint8(mask_);
        tmplt = out_put((i-1)*(ps-ol)+1:(i-1)*(ps-ol)+ps, (j-1)*(ps-ol)+1:(j-1)*(ps-ol)+ps,:) .* uint8(~mask_);
        patch_cut = patch .* mask_;
        
        out_put((i-1)*(ps-ol)+1:(i-1)*(ps-ol)+ps, (j-1)*(ps-ol)+1:(j-1)*(ps-ol)+ps,:) = patch_cut + tmplt;
    end
end

    
            
            