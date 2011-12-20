function perimiters = scan_tris()
N = 1000;

t = pipe(cartesian_product((1:N)', (1:N)'), @(x)x(x(:,1) < x(:,2),:));
zz = zeros(length(t), 1);
oo = ones(length(t), 1);

a = [zz, oo];
b = [t(:,1)/(N+1)*pi*2, oo];
c = [t(:,2)/(N+1)*pi*2, oo];
perimiters = hypertri(a, b, c);
