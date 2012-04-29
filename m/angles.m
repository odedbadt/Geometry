function l = angles(edges)
  a = edges;
  b = circshift(a',1)';
  c = circshift(a',2)';
  l = acos((cosh(b).*cosh(c) - cosh(a)) ./ sinh(b)./sinh(c));


