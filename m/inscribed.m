function r = inscribed(al)
  a = al(:,1);
  b = al(:,2);
  g = al(:,3);
  ca=cos(a);
  cb=cos(b);
  cg=cos(g);
  r = atanh(sqrt((ca.*ca+cb.*cb+cg.*cg+2*ca.*cb.*cg-1)./(2.*(1+ca).*(1+cb).*(1+cg))));


