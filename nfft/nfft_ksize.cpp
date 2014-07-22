#include "ClassHandle.hpp"
#include "NFFT.hpp"

#include "mex.h"
#include "ClassHandle.hpp"
#include "NFFT.hpp"

static mxArray* mxCreateScalar (const size_t& s) {

	mwSize   z = 1;
    mxArray* m = mxCreateNumericArray (1, &z, mxUINT64_CLASS, mxREAL);
    size_t*  p = (size_t*) mxGetData (m);
    p[0]       = s;
    return   m;

}

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	NFFT<double>* nfft = MatlabToPointer < NFFT<double> > (prhs[0]);

    plhs[0] = mxCreateScalar (nfft->KSize());    
	
}
