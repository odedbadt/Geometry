function l = edges(al)
  bet = circshift(al',1)';
  gam = circshift(al',2)';
  l = acosh((cos(bet).*cos(gam) + cos(al)) ./ sin(bet)./sin(gam));


