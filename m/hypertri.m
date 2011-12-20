function perimiters = hypertri(a, b, c)
h = hyper();

lbc = h.line(b, c);
lab = h.line(a, b);
lca = h.line(c, a);

pa = h.perpendicular(a, lbc);
pb = h.perpendicular(b, lca);
pc = h.perpendicular(c, lab);

ia = h.intersection(lbc, pa);
ib = h.intersection(lca, pb);
ic = h.intersection(lab, pc);

ca = h.line(ib, ic);
cb = h.line(ic, ia);
cc = h.line(ia, ib);

da = h.dist(ib, ic);
db = h.dist(ic, ia);
dc = h.dist(ia, ib);




perimiters = [a(:,1) b(:,1) c(:,1) da+db+dc];



%plot(points(:,1), points(:,2))