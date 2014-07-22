function delete(a)

    clear a.b0;
    clear a.is;
    clear a.nk;
    clear a.w;
    clear a.k;
    clear a.cgeps;
    nfft_finalise (a.st);
    clear a.st;

end
