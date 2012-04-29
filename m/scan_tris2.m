function mx = scan_tris2()
al0 = 0.01:0.02:pi/2;
[a,b,c] = meshgrid(0.01:0.05:pi/2,0.01:0.02:pi/2,0.01:0.02:pi/2);
al1 = [a(:) b(:) c(:)];
al = al1(sum(al1,2) < pi, :);

F = fanganohyperbolic(al);
R = inscribed(al);
P = sum(edges(al),2);
U = unique(al(:,1));
mx = [U ...
        arrayfun(@(x)al(maxindex(F./P.*(al(:,1) == x)), 2), U) ...
        arrayfun(@(x)al(maxindex(F./P.*(al(:,1) == x)), 3), U) ...
        arrayfun(@(x)max(F./P.*(al(:,1) == x)), U) ...        
    ];

%max(F./P)
%plot(mx(:,1), mx(:,2))
%csvwrite('maximums.csv', mx);