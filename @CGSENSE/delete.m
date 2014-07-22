function delete(a)

    clear a.b0;
    clear a.is;
    clear a.nk;
    clear a.w;
    clear a.k;
    clear a.fteps;
    clear a.mxit;
    clear a.eps;
    nfft_finalise (a.st);
    clear a.st;

end
