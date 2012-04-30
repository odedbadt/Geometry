

norm = @(v,p)power(sum(power(abs(v),p), 2), 1/p);


normalize = @(v,p)bsxfun(@rdivide, v, norm(v, p));
dual = @(p)1/(1 - (1/p));

N = 250;
s1 = ((1:N)/N * 2 * pi)';


P = 14.0;
Q = dual(P);


V = normalize([cos(s1) sin(s1)], P);
[ii, jj] = meshgrid(1:N, 1:N);

ii = ii(:);
jj = jj(:);


D = reshape(norm(V(ii,:) - V(jj,:), P) + norm(V(ii,:) + V(jj,:), P), [N, N]);


figure;
subplot(2,2,1);
imagesc(D);


DX = conv2(D(:,2:end), [1  -1]);
DY = conv2(D(2:end,:), [1; -1]);
Z = ones(N,N) * 255;
subplot(2,2,2);

image(uint8(cat(3, 120 + 120*sign(DX) ,120 + 120*sign(DY),  Z)));
title('DX vx DY');

subplot(2,2,3);
image(uint8(cat(3, 120 + 120*sign(DX) ,Z,Z )));
title('DX');

subplot(2,2,4);
image(uint8(cat(3, Z ,120 + 120*sign(DY), Z )));
title('DY');
