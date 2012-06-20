function [dat] = annealing(initial, target)
	dat = initial;	
	%scores = zeros(100, size(dat,1));
	for ii = 1:10000
		%scores(floor(ii/10+1),:) = target(dat)';
		perturbed = dat + randn(size(dat)) * exp(-3-ii*0.01);
		better = target(dat) < target(perturbed);
		dat(better, :) = perturbed(better, :);
	end

	%plot(scores);
end