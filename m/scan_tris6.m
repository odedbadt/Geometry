function mx = scan_tris6()

al1 = rand(100000, 3)*pi/2;

al = al1(sum(al1,2) < pi, :);



F = fanganohyperbolic(al);


alpha = al(:,1);
beta = al(:,2);
gamma = al(:,3);


R = inscribed(al);
P = sum(edges(al),2);
A = pi - sum(al,2);
S = F./P;


Phi = 2.*cos(alpha).*cos(beta).*cos(gamma) + cos(alpha).*cos(alpha) + cos(beta).*cos(beta) + cos(gamma).*cos(gamma) - 1;
F2 = 2.*asinh(sqrt(Phi));




i1 = find(al(:,1) > 0.94 & al(:,1) < 0.96);
al(i1(maxindex(S(i1))),:)


[s,sm] = sort(- sum(al,2) ./ sqrt(sum(al.*al,2)));
[s,mn] = sort(min(al(:,2), al(:,3)) ./ (pi - al(:,1))  );
[s,mx] = sort(max(al(:,2), al(:,3)));

figure;
%plot(al(:,1), [F F2], 'k.');
plot(sort(log(F) - log(F2)), 'k.');

hold on;

%plot(al(mn(1:300),1), S(mn(1:300)), 'm+');
%plot(al(mn(end-300:end),1), S(mn(end-300:end)), 'r+');

%plot(al(mx(1:300),1), S(mx(1:300)), 'c+');
%plot(al(mx(end-300:end),1), S(mx(end-300:end)), 'g+');

%plot(al(sm(1:600),1), S(sm(1:600)), 'b+');

%a =( 0.01:0.03:pi/2)';

%mx = scan_tris7(a);

%plot (a, real(mx), '.-');
%legend({'all', 'a=b=c', 'b=c=0', 'c=0, min-area', 'b=c,min-area', 'max(b),min-area', 'b=c=pi/3'});

hold off;

