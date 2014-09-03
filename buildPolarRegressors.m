function [o, p] = buildPolarRegressors(x, y)

	% build turning regressors using two raw signals:
	% 	x - x signal
	% 	y - y signal
	%	returns model components (o) and parameters (p) 

	% define a convolutional kernel
	p.kernel = mkKernel(2, 1, 5);

	% convolve signals, rescale using a percentile, 
	% and convert to polar coordinates
	xc = conv(x,p.kernel,'same');
	yc = conv(y,p.kernel,'same');
	rescale = prctile(yc, 95);
	xc = xc / rescale;
	yc = yc / rescale;
	[t r] = cart2pol(xc,yc);

	% define window function parameters for theta
	p.nThetas = 20;
	p.thetaTWidth = 0.25*(2*pi)/p.nThetas;
	p.thetaWidth = (2*pi)/p.nThetas - p.thetaTWidth;
	p.thetaCenters = (0:p.nThetas-1)*(p.thetaWidth+p.thetaTWidth)-p.thetaWidth+p.thetaTWidth;
	p.thetaCenters = p.thetaCenters([5,6,7,8]);
	p.nT = length(p.thetaCenters);

	% define window function parameters for radius
	p.mxR = 1.8;
	p.nRs = 4;
	p.centerRad = 0;
	p.rTWidth = 0.25*(p.mxR/p.nRs);
	p.rWidth = (p.mxR/p.nRs) - p.rTWidth;
	p.rCenters = (0:p.nRs-1)*(p.rWidth+p.rTWidth) + p.rWidth/2;
	p.rCenters = p.rCenters(1:3);
	p.nR = length(p.rCenters);

	% make an image to evaluate bases on (for plotting purposes)
	resolution = 500;
	xrng = linspace(-0.8, 0.8,resolution);
	yrng = linspace(0, 1.5,resolution);
	[xtmp ytmp] = meshgrid(xrng,yrng);
	[tt rr] = cart2pol(xtmp,ytmp);

	o = mkBases(t, tt, r, rr, p);

	o.M = o.M3;
	o.X = o.X3;
	o.s_r = repmat(p.rCenters,1,4)';
	o.s_t = vector(repmat(p.thetaCenters,[3 1]));
	o.xc = xc;
	o.yc = yc;

