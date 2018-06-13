function [row, col] = choose_sample(ssd, tol)

m = min(min(ssd));
m = max(m, 0.0001);
[r, c] = find(ssd <= m *(1+tol));
A = rand()*size(r, 1)+1;
ran = uint32(floor(A));
row = r(ran);
col = c(ran);
