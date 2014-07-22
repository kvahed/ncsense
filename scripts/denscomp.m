
function w = weights (k)
% w = weights (k)
%
%  IN: 
%    k  2D kspace trajectory O(Nk,2)
%  OUT:
%    w  Compensation weights
%
%  Kaveh Vahedipour, FZ Juelich


[V,C] = voronoin(k,{'QJ'});
areas = 0;
maxd  = 0;
w     = [];

% compute the surface of the knots
for j = 1:length(k)
    
    x = V(C{j},1);
    y = V(C{j},2);
    lxy = length(x);
    
    if (lxy==0) % a knot exists more than one time
        A=0;
    else
        A = abs(sum(0.5*(x([2:lxy 1])-x(:)) .* (y([2:lxy 1]) + y(:))));
    end
    
    w = [w A];
    mind = min((2*(x-k(j,1))).^2+(2*(y-k(j,2))).^2);
    maxd = max([maxd mind]);
  
end

for j=1:length(w),
    if(isnan(w(j)) || isinf(w(j)) || w(j)>maxd),
        w(j)=maxd;
    end
    areas = areas + w(j);
end

% norm to areas
w = w / areas;


