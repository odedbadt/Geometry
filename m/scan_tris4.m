function perimiters = scan_tris4()

figure
%for ii=1:8
  area= pi / 10;


  al0 = 0.1:0.05:pi/2;
  [b,c] = meshgrid(al0,al0);

  a = pi - b - c - area;

  al = [a(:) b(:) c(:)];

  F = fanganohyperbolic(al);
  P = sum(edges(al),2);
  size(P);
  U = unique(al(:,1));


  F(a(:) < 0) = nan;
  FP = F./P;
  FP(a(:) < 0) = nan;
  sum(sum(isnan(F)))
  surface1 = reshape(F, size(a));
  surface2 = reshape(FP, size(a));


  %subplot(4,4,ii);
  mesh(b, c, surface1);
  xlabel('beta');
  ylabel('gamma');
  zlabel('F');
  title(['Fangano orbit length, Area = ' num2str(area)]);

  %subplot(4,4,ii+8);
  figure;
  mesh(b, c, surface2);
  xlabel('beta');
  ylabel('gamma');
  zlabel('F/P');
  title(['(Fangano orbit length) / Perimiter, Area = ' num2str(area)]);

%end
%imwrite(surface1, 's1.png');
%csvwrite('constsum04.csv', );
