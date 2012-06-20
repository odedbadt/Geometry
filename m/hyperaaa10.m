function res =hyperaaa10(X)

alpha = pi / 4;
a = acosh(1+ sqrt(2));
b = acosh(cosh(a)*cosh(3*a));
gamma = acos((cosh(a)*cosh(b) - cosh(3*a)) / sinh(a)/sinh(b));
delta = acos((cosh(3*a)*cosh(b) - cosh(a)) / sinh(3*a)/sinh(b));

Y = acosh(cosh(X)*cosh(b) - sinh(X).*sinh(b)*cos(pi/4+delta));
Z = acosh(cosh(X)*cosh(b) - sinh(X).*sinh(b)*cos(pi/4+gamma));

theta = acos((cosh(Y)*cosh(b) - cosh(X)) ./ sinh(Y)./sinh(b) );
phi   = acos((cosh(Z)*cosh(b) - cosh(X)) ./ sinh(Z)./sinh(b) );


W1 = acosh(cosh(X).*cosh(Y) - sinh(X).*sinh(Y).*cos(pi/4 + gamma - theta));
W2 = acosh(cosh(X).*cosh(Z) - sinh(X).*sinh(Z).*cos(pi/4 + delta - phi));

W = mean([W1 W2], 2);


omega = acos((cosh(X).*cosh(W) - cosh(Y)) ./ sinh(X)./sinh(W) );
xi    = acos((cosh(X).*cosh(W) - cosh(Z)) ./ sinh(X)./sinh(W) );

res = omega+xi-pi;


