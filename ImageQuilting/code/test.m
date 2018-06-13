% close all;
im = imread('leaf.jpg');
% % figure;imshow(im);

% im2 = quilt_random(im,1963, 149);
% figure;imshow(im2);
% imwrite(im2, 'method1_letter.jpg');

% im3 = quilt_simple(im, 1200, 149, 50, 0.01);
% % imwrite(im3, 'method2_3.jpg');
% figure;imshow(im3);

% im3 = quilt_simple(im, 1706, 89, 40, 0.1);
% imwrite(im3, 'method2_3.jpg');
% figure;imshow(im3);

% im3 = quilt_simple(im, 1200, 149, 40, 1);
% imwrite(im3, 'method2_leaf.jpg');
% figure;imshow(im3);

% im3 = quilt_cut(im, 600, 155, 26, 0.1);
% figure;imshow(im3);
% im4 = quilt_cut(im, 1200, 149, 50, 0.01);
% figure;imshow(im4);

im4 = quilt_cut(im, 1706, 89, 40, 0.1);
figure;imshow(im4);

% im4 = quilt_cut(im, 1200, 149, 50, 1);
% figure;imshow(im4);
imwrite(im4, 'method3_leaf_2.jpg');

im_1 = imread('beans.jpg');
im5 = quilt_cut(im_1, 1706, 89, 40, 0.1);
imwrite(im5, 'method3_beans_2.jpg');

im_2 = imread('stones.jpg');
im6 = quilt_cut(im_2, 1706, 89, 40, 0.1);
imwrite(im6, 'method3_stones_2.jpg');

im_src = imread('starry-night.jpg');
% im_src = imread('white_small.jpg');
% im_src = imread('rice.jpg');
% im_tar = imread('feynman.tiff');
im_tar = imread('Zhang5.jpg');

im_out = texture_transfer(im_src, im_tar, 25, 5, 0.1, 0.6);
figure;imshow(im_out);imwrite(im_out, 'Zhang5_starry-night_2.jpg');

im_src_2 = imread('sketch.tiff');
im_tar_2 = imread('feynman.tiff');
im_out_2 = texture_transfer(im_src_2, im_tar_2, 25, 5, 0.1, 0.6);
figure;imshow(im_out_2);imwrite(im_out_2, 'feynman_sketch_2.jpg');

