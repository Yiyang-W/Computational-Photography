function out_put = quilt_random(sample, outsize, patchsize)

out_put = zeros(outsize, outsize, 3);
out_put = uint8(out_put);
sample_size = size(sample(:,:,1));
aaa = sample_size - patchsize;
times = outsize ./ patchsize;
for i = 1:times
    for j = 1:times
        x = uint32(rand() * aaa(2))+1;
        y = uint32(rand() * aaa(1))+1;
        patch = sample(y:y+patchsize-1,x:x+patchsize-1,:);
%         figure;imshow(patch);
%         figure;imshow(out_put);
        out_put((i-1)*patchsize+1:i*patchsize, (j-1)*patchsize+1:j*patchsize,:) = patch(:,:,:);
    end
end


        
