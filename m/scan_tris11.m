function res = scan_tris11()


base = (0.1:1:10)';
base2 = (0.1:1:10)';


L = length(base);
L2 = length(base2);
[a,b,c] = meshgrid(base,base,base2);
es = [a(:) b(:) c(:)];

F = fanganohyperbolic_eee(es);
P = sum(es,2);
FoR = F./P;

FoR(sum(angles(es), 2) > pi) = 0;

[mx,mxi] = max(reshape(FoR,[L,L,L2]),[],3);
figure;
contour(base, base, base2(mxi), 50);
%hold on;
%surface(base, base, base2(mxi), 50);

U = unique([a(:) b(:)], 'rows');
res = [U base2(mxi(:))];


