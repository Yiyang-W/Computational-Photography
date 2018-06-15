function im_blend = mixedBlend(im, mask, im_bg)

[imh, imw, nb] = size(im_bg);
[row, col] = find(mask);
[num, ~]= size(row);
im_blend = im_bg;
im2var = zeros(imh, imw);
for i = 1:num
    r = row(i);
    c = col(i);
    im2var(r,c) = i;
end

A = sparse([],[],[], 4*num, num, 8*num);
b = zeros(4*num, 1);
delta = 0.3;

for a = 1:nb
    e = 0;
    for i = 1:num
        r = row(i);
        c = col(i);
        tmp = [r, c-1;r-1, c; r, c+1; r+1, c];
        for j = 1:4
            e = e+1;
            index = tmp(j,:);
            rr = index(1);
            cc = index(2);
            d = delta * (im(rr,cc,a)-im(r,c,a)) + (1-delta) * (im_bg(rr,cc,a)-im_bg(r,c,a));
            if mask(rr, cc)
                A(e, im2var(rr,cc))=1;
                A(e, im2var(r,c))=-1;
                b(e) = d;
            else
%                 A(e, im2var(rr,cc))=1;
                A(e, im2var(r,c))=1;
                b(e) = d + im_bg(rr,cc,a);
            end
        end
    end
    v = A\b;
    for i = 1:num
        r = row(i);
        c = col(i);
        im_blend(r,c,a) = v(im2var(r,c));
    end
end







