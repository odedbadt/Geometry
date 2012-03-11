function l = fanganohyperbolic_eee(edges)
  a = edges;
  b = circshift(edges', 1)';
  c = circshift(edges', 2)';
  
  bet = acos((cosh(a).*cosh(c) - cosh(b)) ./ sinh(a)./sinh(c));

  fangano = acosh((1 - power(cos(bet),3).*tanh(a).*tanh(c))./sqrt((1 - power(cos(bet).*tanh(a),2)).*(1 - power(cos(bet).*tanh(c),2))));
	

  l = sum(fangano,2);
  l(~all(imag(fangano) == 0, 2), :) = nan;

