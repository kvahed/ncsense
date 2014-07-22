function wnd = hamming_k (k)
    absk = sqrt(sum(k.^2));
    mxabsk = max(absk(:));
    wnd = 0.54 + 0.46 * cos(pi * absk/mxabsk);
end