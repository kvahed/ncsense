#include "ClassHandle.hpp"
#include "NFFT.hpp"

#include "mex.h"
#include "ClassHandle.hpp"
#include "NFFT.hpp"

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	DestroyObject< NFFT<double> > (prhs[0]);
    
}
