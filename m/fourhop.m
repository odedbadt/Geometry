pnorm = @(p,v)power(sum(power(abs(v), p), 2), 1/p);
pnormalize = @(p,v)bsxfun(@rdivide, v, pnorm(p, v));
pnormal = @(p, v)power(abs(pnormalize(p, v)), p - 1) .* sign(v);
pdist = @(p,u,v)pnorm(p,u-v);

N = 32;


I = (1:(N*N*N*N))';
x1 =       mod(I,N);
y1 = floor(mod(I,N*N)/N);
z1 = floor(mod(I,N*N*N)/N/N);
w1 = floor(mod(I,N*N*N*N)/N/N/N);

x = x1(:)/N*pi*2;
y = y1(:)/N*pi*2;
z = z1(:)/N*pi*2;
w = w1(:)/N*pi*2;

P = 4.0;
X = pnormalize(P, [cos(x) sin(x)]);
Y = pnormalize(P, [cos(y) sin(y)]);
Z = pnormalize(P, [cos(z) sin(z)]);
W = pnormalize(P, [cos(w) sin(w)]);
O = pdist(P, X, Y) + pdist(P,Y,Z) + pdist(P,Z,W)+ pdist(P,W,X);

SM = @(O,ii)O < circshift(O,ii);
MN = SM(O,1) & SM(O,-1) & SM(O,N) & SM(O,-N) & SM(O, N*N) & SM(O,-N*N) & SM(O, N*N*N) & SM(O,-N*N*N);

BG = @(O,ii)O >= circshift(O,ii);
MX = BG(O,1) & BG(O,-1) & BG(O,N) & BG(O,-N) & BG(O, N*N) & BG(O,-N*N) & BG(O, N*N*N) & BG(O,-N*N*N);


%plot3(x(MN),y(MN),z(MN), 'b.')
%hold on;
%plot3(x(MX),y(MX),z(MX), 'g.')

RMX = [x(MX) y(MX) z(MX) w(MX)];
RMN = [x(MN) y(MN) z(MN) w(MN)];

target = @(X)pdist(P, toP(X(:,1)), toP(X(:,2)))+pdist(P, toP(X(:,2)), toP(X(:,3)))+pdist(P, toP(X(:,3)), toP(X(:,4)))+pdist(P, toP(X(:,4)), toP(X(:,1)));


RMX = RMX(all( RMX * [ 1  1  1  0  0  0; -1  0  0  1  1  0; 0 -1  0 -1  0  1; 0  0 -1  0 -1 -1], 2), :);
RMN = RMN(all( RMN * [ 1  1  1  0  0  0; -1  0  0  1  1  0; 0 -1  0 -1  0  1; 0  0 -1  0 -1 -1], 2), :);

RMXP = annealing(RMX, target);
RMNP = annealing(RMN, @(A)-target(A));

RMXP = RMXP(all( floor(RMXP/0.1) * [ 1  1  1  0  0  0; -1  0  0  1  1  0; 0 -1  0 -1  0  1; 0  0 -1  0 -1 -1], 2), :);
RMNP = RMNP(all( floor(RMNP/0.1) * [ 1  1  1  0  0  0; -1  0  0  1  1  0; 0 -1  0 -1  0  1; 0  0 -1  0 -1 -1], 2), :);

%R = R(all( R * [ 1  1  1  0  0  0; -1  0  0  1  1  0; 0 -1  0 -1  0  1; 0  0 -1  0 -1 -1]), :);

%[XXX,UR] = unique(prod(R,2)*17 + sum(R,2)*19 + min(R,[],2)*117);

%R = [R(UR, :) R(UR, 1) nan(size(XXX))];

RMXP2 = cat(2, RMXP, RMXP(:,1), nan(size(RMXP(:,1))))';
RMNP2 = cat(2, RMNP, RMNP(:,1), nan(size(RMNP(:,1))))';




SMX = pnormalize(P, [cos(RMXP2(:)) sin(RMXP2(:))]);
SMN = pnormalize(P, [cos(RMNP2(:)) sin(RMNP2(:))]);

figure;
plot(SMN(:,1) + floor((1:size(SMN,1))'/6/10) * 2.5  , SMN(:,2) + mod(floor((1:size(SMN,1))'/6),10) * 2.5  );
figure;
plot(SMX(:,1) + floor((1:size(SMX,1))'/6/10) * 2.5  , SMX(:,2) + mod(floor((1:size(SMX,1))'/6),10) * 2.5  );


figure;
plot(SMN(:,1), SMN(:,2));
figure;
plot(SMX(:,1), SMX(:,2));