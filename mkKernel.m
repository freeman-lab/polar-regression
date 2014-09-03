function kernel = mkKernel(ts,t1,t2)

	% make a linear kernel given a sampling rate, rise time, and decay time

	kernel = zeros(1,(t1+t2)*ts+1);
	for i = 1:size(kernel,2)
		if i <=t1*ts
		    kernel(i) = i/(t1*ts);
		else
		    kernel(i) = 1 - (i-t1*ts)/(t2*ts);
		end
	end
	kernel = [zeros(1,size(kernel,2)),kernel];
	kernel = kernel(1:end-1);
