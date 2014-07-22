function I = intcor (sensitivities)
    I = 1./(sqrt((sum(conj(sensitivities).*sensitivities, ndims(sensitivities)))+1E-9));
end