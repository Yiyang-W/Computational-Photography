im1 = imread('hanbao.jpg');
im2 = imread('jiang.jpg');
figure;imshow(im1);
figure;imshow(im2);
cpselect(im1, im2);

t1 = delaunay(movingPoints1(:,1), movingPoints1(:,2));
t2 = delaunay(fixedPoints1(:,1), fixedPoints1(:,2));

% this produces 43 images of the morphing process
for i=1:43
    im3 = morph(im1, im2, movingPoints1, fixedPoints1,t1, i/45, i/45);
    imwrite(im3,['./out_',num2str(i),'.jpg']);
end

