
angles = rand(10000, 3) * pi/2;
angles = angles(sum(angles,2) < pi, :);

phi2 = 2*prod(cos(angles),2)+sum(cos(angles).*cos(angles), 2) - 1;
taninrad = sqrt(phi2) ./ prod(cos(angles / 2), 2) / 4;

fan = 2  * asinh(sqrt(phi2));
inrad = atanh(taninrad);

rat = fan ./ inrad;
minang = min(angles, [], 2);
maxang = max(angles, [], 2);

figure;
hold on;


P = std(angles,[],2) > std(std(angles,[],2),1)*5;


% for ii=0:9
% 	O = (maxang > (pi/2/10)*ii) & (maxang <= (pi/2/10)*(ii+1));
% 	plot(minang(O), rat(O), 'color', [0,0,ii/10], '.');
% end




[xxx,jjj] = sort(rat);
angles(jjj(1:10),:)
rat(jjj(1:10))

plot(minang, rat, 'color', [0,0,0.5], '.');
plot(maxang, rat, 'color', [0,0.5,0], '.');



%tri = delaunay (minang, maxang);
%trisurf(tri, minang, maxang, rat);


% figure;
% R = 250;
% img = zeros(R,R);
% mask = zeros(R,R);

% i1 = floor(minang(:) / (pi / 2) * R);
% i2 = floor(maxang(:) / (pi / 2) * R);
% %i3 = floor(angles(:,3) / (pi/2) * 5);
% i4 = rat(:)/6;

% img(i1 + R*i2 + 1) = i4;
% mask(i1 + R*i2 + 1) = 1;


% [cx, cy] = meshgrid(1:22, 1:22);
% cx = (cx - 11.5)/22*20;
% cy = (cy - 11.5)/22*20;
% cursor = exp(-cx.*cx-cy.*cy);

% img = convn(img, cursor) ./ convn(mask, cursor);
% img = img(:,:);
% size(img)
% image(repmat(uint8(255*img), [1,1,3]));



