/*
 * Forward non-equispaced FT with 
 * NFFT 3.1.3 (http://www-user.tu-chemnitz.de/~potts/nfft/)
 * 
 * Kaveh Vahedipour - Forschungszentrum Jülich
 * November 2011
 */

#include "mex.h"

#include "ClassHandle.hpp"
#include "NFFT.hpp"

size_t rank, *imsz, nr, nw, nk, m;
double alpha, eps, mxit, *b0;

/**
 * @brief  Input variables
 */
enum inputs {
	K_SPACE,
	WEIGHTS,
	IMAGE_SIZE,
	B0,
	NFFT_M,
	NFFT_ALPHA,
	NFFT_EPS,
	NFFT_MXIT
};

static void ImageSpace (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	size_t nb0;

	rank = (size_t)  mxGetNumberOfElements (prhs[IMAGE_SIZE]);
    imsz = (size_t*) mxGetData (prhs[IMAGE_SIZE]); /* Image space matrix sides */
	
	nr = 1;
	for (size_t i = 0; i < rank; i++)
		nr *= imsz[i];

	b0   =           mxGetPr (prhs[B0]);              /* b0 map                   */
	nb0  = (size_t)  mxGetNumberOfElements (prhs[B0]);
	
	if (nr != nb0) {
		char emsg [60];
		sprintf (emsg, "b0 map size (%zu) not matching image size (%zu).", nb0, nr);
		mexErrMsgTxt(emsg);
	}

}

static void FrequencySpace (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    nw     = mxGetNumberOfElements (prhs[WEIGHTS]); /* # of k-space points */
	nk     = mxGetNumberOfElements (prhs[K_SPACE]);

	if (nk != nw*rank) {		
		char emsg [60];
		sprintf (emsg, "K-space size (%zu) not matching weights size * rank size (%zux%zu).", nk,  nw*rank);
		mexErrMsgTxt(emsg);
	}	

}


static void Verbose () {

	if (rank == 2)
		mexPrintf ("Initialising: NFFT (%zu, [%zu %zu], %zu, %zu, %.2e, [], %.2e, %zu)\n", 
				   rank, imsz[0], imsz[1], nw, m, alpha, eps, mxit);
	else
		mexPrintf ("Initialising: NFFT (%zu, [%zu %zu %zu], %zu, %zu, %.2e, [], %.2e, %zu)\n", 
				   rank, imsz[0], imsz[1], imsz[2], nw, m, alpha, eps, mxit);
	
}

/* Initialise NuFFT */
void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	ImageSpace (nlhs, plhs, nrhs, prhs);
	FrequencySpace (nlhs, plhs, nrhs, prhs);
	
	m     =  mxGetScalar (prhs[3]); /* Oversampling factor      */
	alpha =  mxGetScalar (prhs[4]); /* Oversampling margin      */
	eps   =  mxGetScalar (prhs[6]); /* NFFT Epsilon             */
	mxit  =  mxGetScalar (prhs[7]); /* NFFT max iters           */

#ifdef VERBOSE
	Verbose ();
#endif

    /* Initialise nfft plan for forward transform   */
	NFFT<double>* nfft = new NFFT<double> (rank, imsz, nw, m, alpha, b0, eps, mxit);

	nfft->KSpace (mxGetPr(prhs[0]));
	nfft->Weights(mxGetPr(prhs[1]));

	plhs[0] = PointerToMatlab< NFFT<double> > (nfft);
        
}
