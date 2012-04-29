function l = fanganohyperbolic(al)
  if nargin < 1
    al = rand(1000,3) * pi/2;  
    al = al(sum(al,2) < pi, :);
  end

  bet = circshift(al',1)';
  gam = circshift(al',2)';
  
  
  a = acosh((cos(bet).*cos(gam) + cos(al)) ./ sin(bet)./sin(gam));
  b = circshift(a',1)';
  c = circshift(a',2)';

  fangano = acosh((1 - power(cos(bet),3).*tanh(a).*tanh(c))./sqrt((1 - power(cos(bet).*tanh(a),2)).*(1 - power(cos(bet).*tanh(c),2))));
	

  l = sum(fangano,2);
  l(~all(imag(fangano) == 0, 2), :) = nan;

