pnorm = @(p,v)power(sum(power(abs(v), p), 2), 1/p)
pnormalize = @(p,v)bsxfun(@rdivide, v, pnorm(p, v));
pnormal = @(p, v)power(abs(pnormalize(p, v)), p - 1) .* sign(v);
pdist = @(p,u,v)pnorm(p,u-v)

N = 128;

[x1,y1,z1] = meshgrid(1:128,1:128,1:128);
x = x1(:)/N*pi*2; y = y1(:)/N*pi*2; z = z1(:)/N*pi*2;
P = 4.0;
X = pnormalize(P, [cos(x) sin(x)]);
Y = pnormalize(P, [cos(y) sin(y)]);
Z = pnormalize(P, [cos(z) sin(z)]);
O = pdist(P, X, Y) + pdist(P,Y,Z) + pdist(P,Z,X);

SM = @(O,ii)O <= circshift(O,ii)
MN = SM(O,1) & SM(O,-1) & SM(O,N) & SM(O,-N) & SM(O, N*N) & SM(O,-N*N);

BG = @(O,ii)O >= circshift(O,ii)
MX = BG(O,1) & BG(O,-1) & BG(O,N) & BG(O,-N) & BG(O, N*N) & BG(O,-N*N);


%plot3(x(MN),y(MN),z(MN), 'b.')
%hold on;
%plot3(x(MX),y(MX),z(MX), 'g.')

R = [x(MX | MN) y(MX | MN) z(MX | MN)];

R = R(all( R * [ 1  1  0; -1 0 1; 0 -1  -1], 2), :);
R2 = cat(2, R, R(:,1), nan(size(R(:,1))));
R2 = R2';
S = pnormalize(P, [cos(R2(:)) sin(R2(:))]);

plot(S(:,1), S(:,2))



