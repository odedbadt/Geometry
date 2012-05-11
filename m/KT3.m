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

N = 1500;

al = [0.1 0.1+pi 0.1 5:100]';

index_compacter = @(I)I;
index_compacter(N)

a = zeros(size(al, 1), index_compacter(N));
b = zeros(size(al, 1), index_compacter(N));

F = 2;
V = zeros(size(al, 1)-F, 1);

offset = zeros(size(al, 1)-F, 1);

for ii = 2:N


	v = normalize(tocar(al(F-1:end)), P);
	n1 = normal(v, P);
	n2 = -normal(normalize(diff(v), P), P); 

	dn2 = diff(n2);

	offset0 = offset;
	offset = directed_angle(dn2, n1(2:end-1, :));

	V = -cumsum(sign(offset) * exp(-ii/N));
	
	i1 = index_compacter(ii);

	a(1:F, i1) = al(1:F);
	a((F+1):end, i1) = al((F+1):end) + V;

	b(1:end-1, i1) = directed_angle(n1(1:end-1, :), diff(v));
	b(end, i1) = nan;

	al = a(:,i1);
	bl = b(:,i1);
	
	if (offset' * offset < 0.000001)
		disp(ii);
		break;
	end
	% J = find(abs(offset) >= 0.00001, 1, 'first');
	% if isempty(J)
	% 	break;
	% end
	
	% F = F + J - 1;
	% if J > 1
	% 	disp([N ii F]);
	% end
end

figure;
hold on;
U = normalize(tocar((0:0.1:7)'), P);
plot(U(:, 1), U(:, 2), 'k');
U = normalize(tocar((0:0.1:7)'), P)*2;
plot(U(:, 1), U(:, 2), 'k');

U2 = normalize(tocar(al), P);
plot(U2(:, 1), U2(:, 2), 'Color', [1, 0, 0]);
hold off;

figure;
plot(mod(al, 2*pi), mod(bl, 2*pi));