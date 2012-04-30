

norm = @(v,p)power(sum(power(abs(v),p), 2), 1/p);
normal = @(v,p)power(abs(v),p-1).*sign(v);

normalize = @(v,p)bsxfun(@rdivide, v, norm(v, p));
dual = @(p)1/(1 - (1/p));

dcomp = @(v1,v2)sum(v1.*v2,2) ./ sqrt(sum(v1.*v1,2) .* sum(v2.*v2,2));

N = 250;
s1 = ((1:N)/N * 2 * pi)';


P = 3.0;
Q = dual(P);


V = normalize([cos(s1) sin(s1)], P);
U = normalize([cos(s1) sin(s1)], Q);

NV = normal(V, P);
NU = normal(U, Q);

[ii, jj] = meshgrid(1:N, 1:N);

ii = ii(:);
jj = jj(:);

A = V(ii,:);
B = V(jj,:);

D1 = B - A;
D2 = -A - B;

S = normal(normalize(-D1, P), P);
T = normal(normalize(-D2, P), P);


D = reshape(norm(normal(B, P) -  (T - S), 2), [N, N]);


figure;
imagesc(D);

%subplot(2,2,2);



% plot([-2; nan; 2], [-2; nan; 2]);
% hold on;
% plot(V(:,1), V(:,2));
% I = floor(rand()*N*N)+1;
% plot([0; A(I,1); B(I,1); -A(I,1)], [0; A(I,2); B(I,2); -A(I,2)]);

% plot(U(:,1), U(:,2), 'g');


% plot([0; S(I,1); T(I,1)], [0; S(I,2); T(I,2)], 'g');
% plot([S(I,1); S(I,1)-D1(I,1)], [S(I,2); S(I,2)-D1(I,2)], 'k');

% plot([S(I,1); S(I,1)+D1(I,2)], [S(I,2); S(I,2)-D1(I,1)], 'k');
% plot([S(I,1); S(I,1)-D1(I,2)], [S(I,2); S(I,2)+D1(I,1)], 'k');


% plot([T(I,1); T(I,1)-D2(I,1)], [T(I,2); T(I,2)-D2(I,2)], 'k');
% plot([T(I,1); T(I,1)+D2(I,2)], [T(I,2); T(I,2)-D2(I,1)], 'k');
% plot([T(I,1); T(I,1)-D2(I,2)], [T(I,2); T(I,2)+D2(I,1)], 'k');

