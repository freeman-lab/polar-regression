function plotBinnedRegression(mat, weights, cmap, lims, xrng, yrng)

	if ~exist('lims','var')
		lims = [min(weights),max(weights)];
	end

	if ~exist('xrng','var')
		xrng = 1:size(mat,2);
	end

	if ~exist('yrng','var')
		yrng = 1:size(mat,1);
	end

	if ~exist('cmap','var')
		clrs = squeeze(colormap_helper(jet, weights, lims));
	else
		clrs = squeeze(colormap_helper(cmap, weights,lims));
	end

	hold on
	for i=1:size(mat,3)
		[c h] = contour(xrng, yrng, mat(:,:,i), 0.9, 'Color', clrs(i,:));
		set(h,'Fill','on');
		hh = get(h, 'Children');
		set(hh, 'FaceColor',clrs(i,:));
		set(hh, 'EdgeColor','none');
	end
	hold off