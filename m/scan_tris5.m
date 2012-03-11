function mx = scan_tris5()


base = (0.01:0.05:pi/2)';
ibase = (1:length(base))';

[a,b,c] = meshgrid(base,base,base);
[i1,i2,i3] = meshgrid(ibase,ibase,ibase);
al1 = [a(:) b(:) c(:)];

iii = [i1(:) i2(:) i3(:)];
al = al1(sum(al1,2) < pi, :);
iii = iii(sum(al1,2) < pi, :);


F = fanganohyperbolic(al);
P = sum(edges(al),2);
R = inscribed(al);
U = unique(al(:,1:2), 'rows');
FoR = F./P;

if length(U) > 1
  grps = iii(:,1) + iii(:,2)*10000;
else
  grps = ones(size(al(:,1)));
end
size(grps)
size(FoR)
MX = accumarray(grps, FoR, [], @max);
MN = accumarray(grps, FoR, [], @min);


surf(base, base, reshape(MX, [size(base,1), size(base,1)]));

mx = [U ...
        arrayfun(@(x)al(maxindex(FoR.*(al(:,1) == x)), 2), U) ...
        arrayfun(@(x)al(maxindex(FoR.*(al(:,1) == x)), 3), U) ...
        arrayfun(@(x)max(FoR.*(al(:,1) == x)), U) ...     
        arrayfun(@(x)al(minindex(FoR./(al(:,1) == x)), 2), U) ...
        arrayfun(@(x)al(minindex(FoR./(al(:,1) == x)), 3), U) ...
        arrayfun(@(x)FoR(minindex(FoR./(al(:,1) == x))), U)...
    ];

%mx = [al FoR R];  

%max(F./P)
%plot(mx(:,1), mx(:,2))
%csvwrite('FanDivInscribed.csv', mx);