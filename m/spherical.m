% An empirical experiment for testing wheather the triangle connacting the bases of a triangle on the spere is a billiard

% Override operators for proper vectoric behaviour
dot = @(u,v)sum(u.*v,2);
norm2 = @(u)dot(u,u);
norm = @(u)sqrt(norm2(u));
cross = @(u,v)cat(2,u(:,2).*v(:,3)-u(:,3).*v(:,2),u(:,3).*v(:,1)-u(:,1).*v(:,3),u(:,1).*v(:,2)-u(:,2).*v(:,1));
normalize = @(v)bsxfun(@rdivide,v,norm(v));
project = @(u,v)u-bsxfun(@times,v,dot(u,v)./norm2(v));
line = @(u,v)normalize(cross(u,v));
angle1 = @(l1,l2)dot(l1,l2);
angle = @(u,v,w)angle1(line(v,u), line(v,w));
      
v1 = normalize(abs(randn(1000,3)));
v2 = normalize(abs(randn(1000,3)));
v3 = normalize(abs(randn(1000,3)));

v11 = normalize(project(v1, cross(v2, v3)));
v22 = normalize(project(v2, cross(v3, v1)));
v33 = normalize(project(v3, cross(v1, v2)));

%compute billiard angles
b1 = angle(v11, v33, v2);
b2 = angle(v22, v33, v1);
z1 = dot(normalize(cross(v22,v33)), normalize(cross(v1,v2))) - dot(normalize(cross(v11,v33)), normalize(cross(v1,v2)));

plot(b1-b2);

a1 = angle(v1, v2, v3);
a2 = angle(v2, v3, v1);
a3 = angle(v3, v1, v2);
