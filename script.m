% get the signals from the existing turn detection code results
xx = frame_turn(61:end,6);
yy = frame_turn(61:end,10);

% build the regressors
[o, p] = buildPolarRegressors(xx, yy);

% o contains all components neccessary for regression
% o.X is the regression matrix
% o.s_t is the center of each bin in theta
% o.s_r is the center of each bin in radius

% do a regression on an example time series
y = ts(2,:)';
Xc = [ones(7140,1) o.X];
b = regress(y, Xc);
r = corrcoef(y, Xc*b);
plotBinnedRegression(o.M, b(2:end)); axis square off;
title(sprintf('r2 = %.02g',r(1,2)^2))
