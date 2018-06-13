function out_put = quilt_simple(sample, outsize, patchsize, overlap, tol)
m1 = [ones(patchsize, overlap) zeros(patchsize, patchsize-overlap)];
m2 = [ones(overlap, patchsize);zeros(patchsize-overlap, patchsize)];
m3 = m1 | m2;
out_put = zeros(outsize, outsize, 3);
out_put = uint8(out_put);

times = (outsize-overlap) / (patchsize-overlap);
sample_size = size(sample(:,:,1));
aaa = sample_size - patchsize;

imsin = im2single(sample);

for i = 1:times
    for j = 1:times
        if i == 1 && j == 1
            x = uint32(rand() * aaa(2))+1;
            y = uint32(rand() * aaa(1))+1;
            patch = sample(y:y+patchsize-1,x:x+patchsize-1,:);
            out_put(1:patchsize, 1:patchsize,:) = patch(:,:,:);
            continue
        elseif i == 1
            M = m1;
        elseif j == 1
            M = m2;
        else
            M = m3;
        end
        row = (i-1)*(patchsize-overlap) + 1;
        col = (j-1)*(patchsize-overlap) + 1;
        ssd = ssd_patch(imsin, out_put(row:row+patchsize-1, col:col+patchsize-1, :) , double(M));
        [r, c] = choose_sample(ssd, tol);
        patch = sample(r:r+patchsize-1, c:c+patchsize-1, :);
        out_put((i-1)*(patchsize-overlap)+1:(i-1)*(patchsize-overlap)+patchsize, (j-1)*(patchsize-overlap)+1:(j-1)*(patchsize-overlap)+patchsize,:) = patch(:,:,:);
    end
end
        