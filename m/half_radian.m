function half_radian(fixed)

base = (0:0.01:pi/2)';
[b,c] = meshgrid(base, base);
a = ones(size(b)) .* fixed;

sc = @(x)fanganohyperbolic(x)./sum(edges(x),2);


al1 = [a(:) b(:) c(:)];

al = al1(sum(al1,2) < pi, :);
plot(al(:,2), sc(al));
hold on;

b2 = (0:0.01:((pi-0.0001-fixed)/2))';
M = [fixed*ones(size(b2)) b2 b2];
%plot(b2, sc(M), 'k');

M(maxindex(sc(M)),:)