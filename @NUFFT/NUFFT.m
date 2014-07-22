function  res = NUFFT (k, is, opts)

%FT = NUFFT(k, w, is, b0, varargin)
%	  Convenience interface to NFFT 3
%
%	Inputs:
%		k  - K-space nodes (complex normalised to [-0.5 .. 0.5])
%`		w  - K-space weights (w = 1 for no weighting)
%		is - Image space size
%		b0 - b0 map for correction (b0 = 0 for no correction)
%
%	Outputs:
%		FT = the NUFFT operator
%
%	example:
%		% This example computes the ifft of a 2d sinc function
%		[x,y] = meshgrid([-64:63]/128);
%		k = [x(:) y(:)]';
%		w = 1;
%		phase = 1;
%		imSize = [128,128];
%		shift = [0,0];
%		FT = NUFFT(k,w,phase,shift,imSize);
%
%		data = sinc(x*32).*sinc(y*32);
%		im = FT'*data;
%		figure, subplot(121),imshow(abs(im),[]);
%		subplot(122), imshow(abs(data),[]);
%
    
    %% Weights specified if not: Educated guess?
    if (~isreal(k))
        k = [real(k(:))';imag(k(:))'];
    end
    
    if nargin==2 
        opts = [];
    end
    
    if ~isfield (opts, 'w'); 
        [tmp,it,~] = unique (double(k)','rows','stable');
        j = denscomp(tmp); tmp = j;
        %j = zeros (size(kx,1),1);
        j(it) = tmp;
        j(j==0)=min(j(j>0));
        j = j./max(j(:));
        d = diff(j);
        j(d>1e-2) = 0;
        j(j==1)=0;
        j(j==0) = max(j(:));
        h = hann_k(k);
        res.w = j(:).*h(:);
    else
        res.w = opts.w;
    end
    
    %% Off-resonance map specified?
    if ~isfield (opts,'b0'); 
        res.b0 = 0.0; 
    else
        res.b0 = opts.b0;
    end
    
    %% Phase correction map specified?
    if isfield (opts,'pc')
        res.pc = opts.pc; 
    else
        res.pc = 1.;
    end
    
    if isfield (opts,'m')
        res.m = opts.m; 
    else 
        res.m = 1;  
    end
    
    if isfield (opts,'alpha')
        res.alpha = opts.alpha;  
    else
        res.alpha = 1.0;
    end
    
    if isfield (opts,'iter')
        res.iter = opts.iter; 
    else
        res.iter = 3;
    end
    
    if isfield (opts,'eps')
        res.eps = opts.eps;  
    else
        res.eps = 1.e-6;
    end
    
    if numel(res.w) == 1
        res.w = ones (size(k,2),1) .* res.w;
    end
    if numel(res.b0) == 1 
        res.b0 = ones (is) .* res.b0;
    end
    
    res.k       = k;
    res.is      = is;
    res.nk      = size(k);
    
    res.st      = nfft_initialise (double(res.k), double(res.w), uint64(res.is), ...
        double(res.b0), double(res.m), res.alpha, res.eps, res.iter);

    res.adjoint = 0;
    
    res         = class(res,'NUFFT');
    

end
