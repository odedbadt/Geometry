
angles = rand(10000,3) * pi/2;
angles = angles(sum(angles,2) < pi, :);
angles(1,:) = [0.79738,0.65369,0.18177];

Phi2 = 2*prod(cos(angles),2)+sum(cos(angles).*cos(angles), 2) - 1;

F0 = fanganohyperbolic(angles);
P0 = sum(edges(angles), 2);
R0 = atanh(sqrt(Phi2 ./ (2*prod(1+cos(angles), 2))));


F1 = 2*asinh(sqrt(Phi2));
P1 = 2*asinh(sqrt(Phi2) ./ 4 ./ prod(sin(angles / 2), 2) );
R1 = atanh(sqrt(Phi2) ./ 4 ./ prod(cos(angles / 2), 2) );




E = edges(angles);
A = cosh(E);
B = circshift(A',1)';
C = circshift(B',1)';

sA = sinh(E);
sB = circshift(sA',1)';
sC = circshift(sB',1)';


a = cos(angles);
b = circshift(a',1)';
c = circshift(b',1)';

P2 = acosh(sum(A.*sB.*sC, 2) + prod(A,2) );
P2 = acosh(prod(A,2)  +  sum(A .* (B.*C - A) ./ a, 2) );

P2 = acosh(prod(A,2).*(1 + sum(1./a,2))  -  sum(A.*A./a, 2));


SG = @(x)sum(x,2);
PI = @(x)prod(x,2);

P2 = acosh(PI(A).*(1 + SG(1./a))  -  sum(A.*A./a, 2));

P2 = acosh(PI(a+b.*c)./PI(1-a.*a).*(1 + SG(1./a))  -  sum(A.*A./a, 2));

P2 = acosh(PI(a+b.*c)./PI(1-a.*a).*(1 + SG(1./a))  -  sum( power(a + b.*c, 2).*(1-a.*a).*b.*c   , 2) ./PI(1-a.*a)./PI(a));

P2 = acosh((PI(a+b.*c).*(SG(a.*b) + PI(a)) - SG(power(a + b.*c, 2).*(1-a.*a).*b.*c)) ./ PI(1-a.*a)./PI(a));

M = @(j,k,l)SG(power(a,j).*power(b,k).*power(c,l));


P2 = acosh((-M(2,2,1)+2*M(3,2,1)+2*M(4,2,1)+3*M(3,2,1)+M(3,3,2)+M(2,2,2)/3+M(3,3,1)+M(4,2,1)+M(3,3,3)/3-M(2,1,1)+M(4,1,1)) ./ PI(1-a.*a)./PI(a));


P2 = acosh(( (M(1,1,1)/3 + M(2,2,0) + M(3,1,1) +M(2,2,2)/3)  .* (M(1,1,0) + M(1,1,1)/3)   - SG(power(a + b.*c, 2).*(1-a.*a).*b.*c)) ./ PI(1-a.*a)./PI(a));


P2 = acosh((M(2,2,1)+M(3,3,0)+M(1,2,3)+M(3,2,1)+M(4,2,1)+M(3,2,2)+M(1,2,4)+M(2,3,3)+M(2,2,2)/3+M(3,3,1)+M(4,2,2)+M(3,3,3)/3 - ...
           (M(2,0,0)+M(1,0,0)+).*(1-a.*a).*b.*c)) ./ PI(1-a.*a)./PI(a));


P3 = asinh(PI(sA) .* (1 + SG(a)) + SG(sA.*A));
 


COMP = [P0 P1 P2 P3];

COMP(1:7,:)