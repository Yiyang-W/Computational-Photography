% Provided by Yasutaka Furukawa

DO_BLEND = false;
DO_MIXED  = false;

if DO_BLEND
    % do a small one first, while debugging
%     im_background = imresize(im2double(imread('sand2.jpg')), 0.95, 'bilinear');
%     im_object = imresize(im2double(imread('text.png')), 0.95, 'bilinear');

    im_background = im2double(imread('Mona_lisa.jpg'));
    im_object = im2double(imread('Zhang2.jpg'));
%     im_background = im2double(imread('dinner.jpg'));
%     im_object = im2double(imread('apple2.jpg'));
    
%     im_background = im2double(imread('sand2.jpg'));
%     im_object = im2double(imread('text.png'));
    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend)
end

% Same steps as Poisson blending, but this one mixes the gradiant in source and target,
% gives translucency for that part.
if DO_MIXED
    % read images
    %...
    
%     im_background = im2double(imread('g.jpg'));
%     im_object = im2double(imread('rose.jpg'));
    
    im_background = im2double(imread('milk.jpg'));
    im_object = im2double(imread('rose.jpg'));
    
    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    
    % blend
    im_blend2 = mixedBlend(im_s, mask_s, im_background);
    figure(4), hold off, imshow(im_blend2);
end

