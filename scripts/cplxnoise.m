function [noise] = cplxnoise (nstd, sz)

    rnoise = nstd .* randn(sz);        % Real white noise
    rng('shuffle');
    inoise = nstd .* randn(sz);        % Imaginary white noise
    noise = rnoise + 1i * inoise;

end