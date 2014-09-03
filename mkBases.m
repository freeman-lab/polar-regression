function out = mkBases(t, tt, r, rr, p)

	% build basis function parameterization of space using
	% parameters in p, apply it to one-dimensional and two-dimensional
	% signals t, tt (theta) and r, rr (radius)

	dur = length(t);
	resolution = 500;

	nT = p.nT;
	nR = p.nR;
	thetaCenters = p.thetaCenters;
	thetaWidth = p.thetaWidth;
	thetaTWidth = p.thetaTWidth;
	rCenters = p.rCenters;
	rWidth = p.rWidth;
	rTWidth = p.rTWidth;
	mxR = p.mxR;

	X1 = zeros(dur,nT);
	X2 = zeros(dur,nR);
	X3 = zeros(dur, nT*nR);
	M1 = zeros(resolution, resolution, nT);
	M2 = zeros(resolution, resolution, nR);
	M3 = zeros(resolution, resolution, nT*nR);

	for itheta=1:nT
		[xThetaWin yThetaWin] = mkWinFunc(thetaCenters(itheta),thetaWidth,thetaTWidth,[0 2*pi],1);
		X1(:,itheta) = interp1(xThetaWin,yThetaWin,t);
		F1(:,itheta) = yThetaWin;
		M1(:,:,itheta) = interp1(xThetaWin,yThetaWin,tt);
	end
	X1(isnan(X1)) = 0;

	for ir=1:nR
		[xRWin yRWin] = mkWinFunc(rCenters(ir),rWidth,rTWidth,[0 mxR],0);
		X2(:,ir) = interp1(xRWin,yRWin,r);
		F2(:,ir) = yRWin;
		M2(:,:,ir) = interp1(xRWin,yRWin,rr);
	end
	X2(isnan(X2)) = 0;

	for itheta=1:length(thetaCenters)
		for ir=1:length(rCenters)
			ind = ir+(itheta-1)*length(rCenters);
			X3(:,ind) = X1(:,itheta) .* X2(:,ir);
			M3(:,:,ind) = M1(:,:,itheta) .* M2(:,:,ir);
		end
	end

	for i=1:size(X3,2)
		X3(:,i) = conv(X3(:,i),p.kernel,'same');
	end

	out.X1 = X1;
	out.X2 = X2;
	out.X3 = X3;
	out.M1 = M1;
	out.M2 = M2;
	out.M3 = M3;
	out.F1 = F1;
	out.F2 = F2;
	out.xR = xRWin;
	out.xT = xThetaWin;