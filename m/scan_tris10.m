function res = scan_tris10()


base = (0.01:0.05:pi/2)';
base2 = (0.01:0.01:pi/2)';
L = length(base);
L2 = length(base2);
[a,b,c] = meshgrid(base,base,base2);
angles = [a(:) b(:) c(:)];

F = fanganohyperbolic(angles);
P = sum(edges(angles),2);
R = inscribed(angles);
FoR = F./P;

FoR(sum(angles, 2) > pi) = 0;

[mx,mxi] = max(reshape(FoR,[L,L,L2]),[],3);
%figure;
%contour(base, base, mx,150);
%hold on;
%contour(base, base, base2(mxi), 50);

U = unique([a(:) b(:)], 'rows');
res = [U base2(mxi(:))];


