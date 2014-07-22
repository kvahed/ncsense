#include "ClassHandle.hpp"
#include "NFFT.hpp"

#include "mex.h"
#include "ClassHandle.hpp"
#include "NFFT.hpp"

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	NFFT<double>* nfft = MatlabToPointer < NFFT<double> > (prhs[0]);
	size_t        insz = (size_t) mxGetNumberOfElements (prhs[1]);

	if (insz != nfft->KSize()) {

		char emsg [60];
		sprintf (emsg, "Signal size (%zu) not matching FT size (%zu).", insz, nfft->KSize());
		mexErrMsgTxt(emsg);

	}	

    mwSize odim = nfft->ISize();

    plhs[0] = mxCreateNumericArray (1, &odim, mxDOUBLE_CLASS, mxCOMPLEX);    
	
	nfft->Adjoint (mxGetPr(prhs[1]), mxGetPi(prhs[1]), mxGetPr(plhs[0]), mxGetPi(plhs[0]));
	
}
