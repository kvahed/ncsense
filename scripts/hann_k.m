function wnd = hann_k (k)
    absk = sqrt(sum(k.^2));
    mxabsk = max(absk);
    wnd = 0.5*(1-cos(pi+absk*.5*pi/mxabsk));
    wnd = wnd(:);
end