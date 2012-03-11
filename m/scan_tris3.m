function perimiters = scan_tris3()
al0 = 0.1:0.01:pi/2;
[a,c] = meshgrid(al0,al0); 
b = a; 
al1 = [a(:) b(:) c(:)];
al = al1(sum(al1,2) < pi, :);

F = fanganohyperbolic(al);
P = sum(edges(al),2);
U = unique(al(:,1));

mx = [U U arrayfun(@(x)al(maxindex(F.*(al(:,1) == x)), 3), U) arrayfun(@(x)al(maxindex(F./P.*(al(:,1) == x)), 3), U)]

csvwrite('maximums2.csv', mx);