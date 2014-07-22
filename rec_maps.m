load ~/Downloads/HR85_1;

fov = 192;
sl = 96; 
res = fov/sl;

is = [sl,sl,sl];

nk = size(rawdata,1);
nl = size(rawdata,2);
nc = size(rawdata,3);
n  = nk;

k = reshape(crd(:,1:n,:),3,n*nl);
data = reshape(rawdata(1:n,:),n*nl,8);


sensitivities = zeros ([is nc]);

% Weights
opts.w = reshape(dcf(1:n,:),n*nl,1);
opts.w = opts.w./max(opts.w);
filt   = hamming_k(k);
figure; plot (filt(1:n),'r-.'); hold 'on'; plot (opts.w(1:n),'b-.'); drawnow;
%opts.w = opts.w .* hann_k(k)';
opts.w = hamming_k(k);
plot (opts.w(1:n),'k'); drawnow;
opts.w = opts.w./max(opts.w);
opts.eps = 1e-6;
opts.m = 2;
opts.alpha = 1.5;
opts.iter = 3;

ftop = NUFFT (k*res, is, opts);
for i = 1:nc; 
    tic; sensitivities (:,:,:,i) = ftop' * (nl*nk*data(:,i)); toc
end
clear ftop;
combined = sqrt(sum(conj(sensitivities).*sensitivities,4));
combined = combined./max(combined(:));
combined (combined==0) = 1e-3;
msk = zeros (size(combined));
msk(combined>2e-1*max(combined(:)))=1;
for i=1:8; 
    sensitivities(:,:,:,i) = sensitivities(:,:,:,i)./combined.*msk; 
end
vis_fields (sensitivities, [sl/2 0 0]);
