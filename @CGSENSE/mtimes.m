function res = mtimes (a,b)

    if isreal(b) 
        b = b+1i*ones(size(b))*1e-16;
    end

    if a.adjoint
        ic     = intcor(a.sm);    
        iw     = a.mask .* ic;
        %% Initialise CG arrays
        am  = eh (a, b) .* iw;
        bm  = zeros(size(am)); % Start image = 0
        p   = am;         
        r   = am;
        res = []; 
        %% CG loop
        for i=1:a.mxit
            %% Convergence criterium
            delta = (norm(r(:))/norm(am(:)));
            if (delta < a.cgeps), break, end  
            %% EhE
            q = eh(a, e(a, p.*iw));
            q = q.*iw + a.lambda*p;
            %% New gradient
            rt = r(:)'*r(:);
            tp = rt/(p(:)'*q(:));
            bm = bm + tp*p;
            rn = r - tp*q;
            p  = rn + rn(:)'*rn(:)/rt*p;
            r  = rn;
        end
        res = bm.*iw;
    else
        res = e (a,b);
    end

end

function sig = e (params, img)
    nc    = size(params.sm,ndims(params.sm));
    nk    = ksize(params.FT);
    sig   = zeros (nk,nc);
    dim   = ndims (params.sm) - 1;
    for c = 1:nc
        if (dim == 2)
            sm = params.sm(:,:,c);
        elseif (dim == 3)
            sm = params.sm(:,:,:,c);
        else
            error ('Supporting 2D and 3D only');
        end
        sig (:,c) = params.FT * (img.*sm);
    end
end

function img = eh (params, sig)
    nc    = size(params.sm,ndims(params.sm));
    img   = zeros (isize(params.FT));
    dim   = ndims (img);
    for c = 1:nc
        if (dim == 2)
            csm = conj(params.sm(:,:,c));
        elseif (dim == 3)
            csm = conj(params.sm(:,:,:,c));
        else
            error ('Supporting 2D and 3D only');
        end
        img = img + (params.FT' * sig(:,c)) .* csm;
    end    
end
