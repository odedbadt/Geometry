function mx = scan_tris9()
figure;
hold on;
for ii=0.1:0.1:pi/2
  plotme(0.05,ii);
end
end
function plotme(aa,bb)
[a,b,c] = meshgrid(aa,bb,0.01:0.001:min([max(aa,bb),(pi/2-aa-bb)]));
angles = [a(:) b(:) c(:)];
F = fanganohyperbolic(angles);
P = sum(edges(angles),2);

FoR = F./P;
plot(c(:), F./P);
