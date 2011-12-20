function res = common()

res = struct();

res.dot = @(u,v)sum(u.*v,2);
res.norm2 = @(u)res.dot(u,u);
res.norm = @(u)sqrt(res.norm2(u));
res.dist2 = @(u,v)res.norm2(u-v);
res.dist = @(u,v)res.norm(u-v);
res.cross = @(u,v)cat(2,u(:,2).*v(:,3)-u(:,3).*v(:,2),u(:,3).*v(:,1)-u(:,1).*v(:,3),u(:,1).*v(:,2)-u(:,2).*v(:,1));
res.normalize = @(v)bsxfun(@rdivide,v,res.norm(v));
res.convexSum = @(u,v,d)bsxfun(@times, u, (1-d))+bsxfun(@times, v, d);
res.J = @(u)[u(:,2) -u(:,1)];
res.s1Middle = @s1Middle;
res.s1Dist = @s1Dist;
res.s1MinDist = @s1MinDist;


end

function res = s1Middle(a1, a2) 
  a = mod((a1 + a2) / 2,  pi*2);
  sc = s1Dist(a, a1) > pi/2;
  res = a +  sc .* pi / 2;
end
function res = s1Dist(a1, a2) 
  d = mod(2*pi + a2 - a1, 2*pi);
  v1 = 2*pi - d;
  res = d .* (d <= pi)  + v1 .* (d > pi);
end
function res = s1MinDist(a1, a2) 
  res = min(s1Dist(a1, a2), s1Dist(a2, a1));
end