CXX  = /Applications/MATLAB_R2014a.app/bin/mex
CXXFLAGS = CFLAGS="$$CFLAGS -Ofast -mavx2 -msse -msse2 -mssse3" -I/usr/local/include 
LDFLAGS = /usr/local/lib/libnfft3.a  /usr/local/lib/libfftw3.a
SOURCES = nfft_initialise nfft_adjoint nfft_trafo nfft_isize nfft_ksize nfft_finalise
OBJECTS = $(SOURCES:.cpp=.mexmaci64)

.cpp.mexmaci64:
	$(MEXCXX) $(OPTS) $< $(LIBS) -o $@

all : $(OBJECTS)

clean : 
	rm -f *.mexmaci64

