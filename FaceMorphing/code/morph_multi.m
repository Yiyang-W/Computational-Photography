function avgim = morph_multi(n)
% this gives the average face of a given dataset

ptsall = zeros(46,2,n);
for i=1:n
    filename = ['./frontalshapes_manuallyannotated_46points/',num2str(i),'a.pts'];
    fid = fopen(filename);
    C = textscan(fid, '%s');

    for j = 3:48
        ptsall(j-2, 1, i) = str2double(C{1}{j*2});
        ptsall(j-2, 2, i) = str2double(C{1}{j*2+1});
    end
    fclose(fid);
end

% t1 = delaunay(movingPoints1(:,1), movingPoints1(:,2));
avgpts = sum(ptsall,3)/n;
tri = delaunay(avgpts(:,1), avgpts(:,2));
A1 = zeros(3,3,size(tri,1));

im = imread(['./frontalimages_spatiallynormalized/',num2str(1),'a.jpg']);
[r, c, ddd] = size(im);
avgim = zeros(r,c,ddd);

for k=1:n
    im = double(imread(['./frontalimages_spatiallynormalized/',num2str(k),'a.jpg']));
    for i = 1:size(tri,1)
        ps1 = [ptsall(tri(i,1),:,k); ptsall(tri(i,2),:,k); ptsall(tri(i,3),:,k)];
        psm = [avgpts(tri(i,1),:); avgpts(tri(i,2),:); avgpts(tri(i,3),:)];
        A1(:,:,i) = computeAffine(psm, ps1);
    end
    
    X = [1:c]';
    for i = 1:r
        Y = ones(c,1) * i;
        index = mytsearch(avgpts(:,1), avgpts(:,2), tri, X, Y);
        for j = 1:c
            if isnan(index(j))
                avgim(i,j,:) = avgim(i,j,:) + im(i,j,:)/n;
            else
                p1 = round(A1(:,:,index(j)) * [j;i;1]);
                
                avgim(i,j,:) = im(p1(2),p1(1),:)/n + avgim(i,j,:);
            end
        end
    end
    
end

avgim = uint8(avgim);