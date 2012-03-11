function hyperaaa
  a = (1:10)';

  alpha = acos((cosh(a).*cosh(a) - cosh(a)) ./ sinh(a)./sinh(a))


  

  A = i .* ones(size(a));
  B = i .* exp(a);

  y = (exp(a) + 1) ./ (2 .* cosh(a));
  x = sqrt(exp(a) - y.*y);
  C = x + i * y;
  
  [a hdist(A,B) hdist(B,C) hdist(C,A)];


  CC = i .*  exp(a / 2);  
  BB = midpoint(A,C);
  
  
  d = x ./ (y - 1) + (x.*x + y.*y - 1) ./ 2 ./ x;
  h2 = power((x.*x + y.*y - 1) ./ 2 ./ x, 2) + 1;

  [h2 power(exp(a./2).*2.*sinh(a./2) ./ exp(a./2)./sqrt(1 - power(cosh(a/2),2) ./ cosh(a)./cosh(a)) ./ 2, 2)+1];
  [h2 power(sinh(a./2) .* cosh(a), 2) ./ (cosh(a).*cosh(a) - cosh(a/2).*cosh(a/2))+1];



  cha = cosh(a);
  cha2 = cha.*cha;
  cha3 = cha.*cha.*cha;
  [h2 (cha3-cha2 +2*cha2 - cha - 1)./ (2*cosh(a).*cosh(a) - cha - 1)];

  [h2 (cha3 + cha2 - cha - 1)./(2*cha2 - cha - 1)];


  [d x ./ (y - 1) + sqrt((cha3 - cha2)./(2*cha2 - cha - 1))];
  [d exp(a/2).*sqrt((2.*cha2 - cha - 1)./2./cha2)./(exp(a/2).*cosh(a/2)./cha - 1) + sqrt((cha3 - cha2)./(2*cha2 - cha - 1))];
  [d exp(a/2).*sqrt((2.*cha2 - cha - 1)./2)./(exp(a/2).*cosh(a/2)-cha) + sqrt((cha3 - cha2)./(2*cha2 - cha - 1))];;
  [d exp(a/2).*sqrt((2.*cha2 - cha - 1))./(exp(a/2).*sqrt((cha+1))-cha.*sqrt(2)) + sqrt((cha3 - cha2)./(2*cha2 - cha - 1))];


  v = sqrt(h2 - power(h2 ./ d, 2));
%  [imag(BB)v] 
  
%  [y exp(a./2).*cosh(a./2)./cosh(a) x sqrt(exp(a./2).*sinh(a./2))./cosh(a./2)]

 % [x exp(a./2)./cosh(a).*sqrt(cosh(a).*cosh(a) - 0.5.*cosh(a) - 0.5)]



  [hdist(BB,CC) acosh(1.5 - 1./(1+cosh(a)))]

  [cosh(a/2) cosh(a)./(sqrt((2.*cha3 - 2.*cha2) ./ sinh(a)./sinh(a)))];
end




function res = hdist(a,b)
res = acosh(1 + nrm2(a - b)./ (2 .* imag(a).*imag(b)));
end

function res = nrm2(a)
res = a .* conj(a);
end


function res = dbg(a,b)

r3_2 = nrm2(a - b) .* imag(b) .* imag(a) ./ imag(b - a) ./ imag(b - a);

c1 = (b + a) ./ 2 - i.*(b - a).* imag((b + a) ./ 2) ./ imag(i.*(b - a));
r4 = sqrt(nrm2(b - c1));

r6 = abs(real(b-a) ./ 2 - real(a-b) ./ imag(a-b) .* imag(b) - imag(a-b)./real(a-b).*imag((a+b)/2));
cosA = -(r3_2 - r4.*r4 - r6.*r6) ./ (2 .* r4 .*r6);

res = c1 - cosA.*r4 + sqrt(1-cosA.*cosA).* r4.*i;

end

function res = midpoint(a,b)

r3_2 = nrm2(a - b) .* imag(b) .* imag(a) ./ imag(b - a) ./ imag(b - a);

c1 = (b + a) ./ 2 - i.*(b - a).* imag((b + a) ./ 2) ./ imag(i.*(b - a));
r4 = sqrt(nrm2(b - c1));

r6 = abs(real(b-a) ./ 2 - real(a-b) ./ imag(a-b) .* imag(b) - imag(a-b)./real(a-b).*imag((a+b)/2));
cosA = -(r3_2 - r4.*r4 - r6.*r6) ./ (2 .* r4 .*r6);

res = c1 - cosA.*r4 + sqrt(1-cosA.*cosA).* r4.*i;

end

