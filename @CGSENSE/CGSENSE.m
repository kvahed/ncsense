function  res = CGSENSE (k, is, sm, opts)

    res.FT = NUFFT (k, is, opts);
    res.sm = sm;
    res.adjoint = 0;
    
    if ~isfield (opts,'mask');    opts.mask = 1.0; end
    if ~isfield (opts,'mxit');    opts.mxit = 10; end   % SENSE iters
    if ~isfield (opts,'cgeps');  opts.cgiter = 3; end; % FT iters
    if ~isfield (opts,'cgeps');  opts.cgeps = 1.e-3; end; % FT iters
    if ~isfield (opts,'lambda');  opts.lambda = 0.; end; % Tikh reg
    
    res.mask = opts.mask;
    res.mxit = opts.mxit;
    res.cgiter = opts.cgiter;
    res.cgeps = opts.cgeps;
    res.lambda = opts.lambda;
    
res  = class (res,'CGSENSE');
