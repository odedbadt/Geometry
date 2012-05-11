function a = KT4
	norm = @(v,p)power(sum(power(abs(v),p), 2), 1/p);
	normal = @(v,p)power(abs(v),p-1).*sign(v);

	normalize = @(v,p)bsxfun(@rdivide, v, norm(v, p));
	dual = @(p)1/(1 - (1/p));
	tocar = @(alpha)[cos(alpha) sin(alpha)];

	wedge = @(u,v)u(:,2).*v(:,1)-u(:,1).*v(:,2);
	inner = @(u,v)u(:,1).*v(:,1)+u(:,2).*v(:,2);
	directed_angle = @(u,v)atan2(wedge(u, v), inner(u,v));

	lambda = 5/6;

	P = 4;
	Q = 1 / (1 - 1/P);

	N = 50;

	a = [0:1000]';
	L = length(a);
	b = zeros(L, 1);

	log = [a zeros(L, N)];
	index_compacter = @(I)I;
	index_compacter(N)

	F = 2;
	V = zeros(L-F, 1);

	offset = zeros(L-F, 1);



	for jj = F+1:L
        v1 = tocar(a(jj-2));
        v2 = tocar(a(jj-1));

		u1 = -normal(normalize(v2 - v1, P), P);


		d1 = normal(v2, P);
		u2 = fsolve(@(X)[directed_angle(X - u1, d1)*1000, norm(X, Q) - 1], -u1*2);

		d2 = normal(u2, Q);
		v3 = fsolve(@(X)[directed_angle(X - v2, -d2)*1000, norm(X, P) - 1], -v2*2);
		
		a(jj) = atan2(v3(:,2), v3(:,1));
		b(jj) = directed_angle(d1, v3 - v2);
	end

	figure;
	hold on;
	U = normalize(tocar((0:0.1:7)'), P);
	plot(U(:, 1), U(:, 2), 'k');
	U = normalize(tocar((0:0.1:7)'), P)*2;
	plot(U(:, 1), U(:, 2), 'k');

	U2 = normalize(tocar(a), P);
	plot(U2(:, 1), U2(:, 2), 'Color', [1, 0, 0]);
	hold off;

	figure;
	plot(mod(a, 2*pi), mod(b, 2*pi), 'o');

	figure;
	plot(a, 'o');