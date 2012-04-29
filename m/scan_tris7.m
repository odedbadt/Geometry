function mx = scan_tris7(a)


sc = @(x)fanganohyperbolic(x)./sum(edges(x),2);

equi = sc([a a a]);
equi(a*3 > pi) = nan;

pi3 = [a ones(size(a,1), 2)];
pi3(sum(pi3,2) > pi) = nan;

e = 0.000001;

mxb = max(0,min(pi-a,pi/2-e));

mx = real([equi ...
  sc([a a*0+e a*0+e])...
  sc([a min(pi/2-e, (pi-a-e*2)) a*0+e])...
  sc([a (min(pi-a,pi)/2-e) (min(pi-a,pi)/2)])...
  sc([a mxb max(0,min(pi-a-mxb-e,pi/2-e))])...
  sc(pi3)...
]);