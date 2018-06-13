function im = hybridImage(im1, im2, cutoff_low, cutoff_high)
close all;
[r, c] = size(im1);
% Choose a proper cutoff-frequency
cutoff_frequency = 3.8;
im1_after = imgaussfilt(im1, cutoff_frequency);
im2_after = im2 - imgaussfilt(im2, cutoff_frequency);
im = (im1_after + im2_after) / 2;

% Show the log magnitude of the Fourier transform of the two input images, 
% the filtered images, and the hybrid image.
% i1 = log(abs(fftshift(fft2(im1))));
% i3 = log(abs(fftshift(fft2(im2))));
% i2 = log(abs(fftshift(fft2(im1_after))));
% i4 = log(abs(fftshift(fft2(im2_after))));
% figure(100); imagesc([i1 zeros(r,floor(c/8)) i2; zeros(floor(r/8), 2*c+floor(c/8)); i3 zeros(r,floor(c/8)) i4]);
% figure(101); imagesc(log(abs(fftshift(fft2(im2_after)))));
% figure; imagesc(log(abs(fftshift(fft2(im)))));