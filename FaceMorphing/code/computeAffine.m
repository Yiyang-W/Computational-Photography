function A = computeAffine(pts1,pts2)

bb = [pts2(1,:), pts2(2,:), pts2(3,:)]';
AA = zeros(6,6);
AA(1,1:3) = [pts1(1,:), 1];
AA(2,4:6) = [pts1(1,:), 1];
AA(3,1:3) = [pts1(2,:), 1];
AA(4,4:6) = [pts1(2,:), 1];
AA(5,1:3) = [pts1(3,:), 1];
AA(6,4:6) = [pts1(3,:), 1];


tt = AA\bb;

A = [tt(1:3)'; tt(4:6)'; 0 0 1];
% for i = 1:size(pts1(1))
%     A * [pts1(i,:) 1]' - [pts2(i,:) 1]'
% end