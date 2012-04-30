
angles = rand(20000, 3) * pi/2;
angles = angles(sum(angles,2) < pi, :);

phi2 = 2*prod(cos(angles),2)+sum(cos(angles).*cos(angles), 2) - 1;
taninrad2 = phi2 ./ sum(4.*cos(angles/2),2);

inrad = atanh(sqrt(taninrad2));
fan = 2  * asinh(sqrt(phi2));
rat = fan ./ inrad;
minang = min(angles, [], 2);
maxang = max(angles, [], 2);

O = abs(maxang-minang) < std(maxang-minang)/2;
P = std(angles,[],2) > std(std(angles,[],2),1)*5;

figure;
hold on;
plot(minang, rat, 'color', [0,0,0.5], '.');
plot(minang(O), rat(O), 'color', [1,0,0.6], '.');
plot(minang(P), rat(P), 'color', [0,0,0.3], '.');
plot(maxang, rat, 'color', [0,0.5,0], '.');
plot(maxang(O), rat(O), 'color', [1,0.6,0], '.');
plot(maxang(P), rat(P), 'color', [0,0.3,0], '.');
