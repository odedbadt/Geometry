function res = scan_tris12()



alpha = @(a,b,c)angles([a b c])(:,1);

delta = @(a,b,c)1 - cosh(a).*cosh(a) - cosh(b).*cosh(b) - cosh(c).*cosh(c) + 2.*cosh(a).*cosh(b).*cosh(c);

ro = @(a,b,c)delta(a,b,c) ./ (sinh(a).*sinh(b).*sinh(c));
orb = @(a,b,c)fanganohyperbolic_eee([a b c]);
orb0 = @(a,b,c)acosh(1+2.*ro(a,b,c).*ro(a,b,c));
orb1 = @(a,b,c)2.*asinh(ro(a,b,c));

p = @(a,b,c)a+b+c;



derv = @(f,a,b,c,h)(f(a+h,b,c)-f(a,b,c))/h;


base = (1:0.01:10)';
[x,y,z] = meshgrid(base,[4.9], [5.1]);
x = x(:);
y = y(:);
z = z(:);


dro = derv(ro,x,y,z,0.01);
dro0 = 2.*cos(alpha(x,y,z))-ro(x,y,z)./tanh(x);

dorb = derv(orb,x,y,z,0.01);
dorb0 = 2 .* (2.*cos(alpha(x,y,z))-ro(x,y,z)./tanh(x)) ./ sqrt(ro(x,y,z).*ro(x,y,z) + 1);


%dro0 = (2.*p(x,y,z).*(2.*cos(alpha(x,y,z))-ro(x,y,z)./tanh(x)) - orb(x,y,z))./(p(x,y,z).*p(x,y,z));

figure;
plot(x(:), [orb0(x,y,z) orb(x,y,z)])