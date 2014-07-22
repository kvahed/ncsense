function res = mtimes(a,b)
    if a.adjoint
        res = nfft_adjoint (a.st, double(b));
        res = reshape (res, a.is);
        res = res .* conj (a.pc);
    else
        res = nfft_trafo (a.st,double(b) .* a.pc);
    end
end
