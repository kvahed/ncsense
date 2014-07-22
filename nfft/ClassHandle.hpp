#ifndef _CLASS_HANDLE_
#define _CLASS_HANDLE_

#include "mex.h"

#include <stdlib.h>
#include <stdint.h>

#include <string>
#include <string.h>
#include <typeinfo>

#define CLASSHANDLE_SIGNATURE 0xFF00F0A5

template<class T> 
class ClassHandle {

public:

	/**
	 * @brief       Construct with pointer
	 */
    ClassHandle (T *ptr) : 
        m_ptr  (ptr), 
		m_name (typeid(T).name()) { 
		m_sign = CLASSHANDLE_SIGNATURE; 
	}
	

	/**
	 * @brief       Destruct
	 */
    ~ClassHandle () { 
		m_sign = 0; 
		delete m_ptr; 
	}


	/**
	 * @brief       Sanity check
	 */
    bool IsValid () { 
		return (m_sign == CLASSHANDLE_SIGNATURE && !strcmp(m_name.c_str(), typeid(T).name())); 
	}
    
	/**
	 * @brief       Get pointer
	 */
	T* Pointer () { 
		return m_ptr; 
	}
    

private:

    uint32_t    m_sign; /**< @brief Signature */
    std::string m_name; /**< @brief Name */
    T*          m_ptr;  /**< @brief T Pointer */ 

};


/**
 * @brief           T pointer to MATLAB pointer
 */
template<class T> static inline mxArray*
PointerToMatlab (T* ptr) {

    mexLock();

    mxArray *out = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
    *((uint64_t *)mxGetData(out)) = reinterpret_cast<uint64_t>(new ClassHandle<T>(ptr));

    return out;

}


/**
 * @brief           MATLAB pointer to ClassHandle pointer
 */
template<class T> inline ClassHandle<T>* 
MatlabToHandlePointer (const mxArray* in) {

    if (mxGetNumberOfElements (in) != 1 || mxGetClassID(in) != mxUINT64_CLASS || mxIsComplex(in))
        mexErrMsgTxt("MatlabToHandlePointer: Expecting real uint64 scalar as input");

    ClassHandle<T>* ptr = reinterpret_cast<ClassHandle<T>*> (*((uint64_t *) mxGetData(in) ));

    if (!ptr->IsValid())
        mexErrMsgTxt("Handle not valid.");

    return ptr;

}


/**
 * @brief           MATLAB pointer to T pointer
 */
template<class T> inline T*
MatlabToPointer (const mxArray* in) {

    return MatlabToHandlePointer<T>(in)->Pointer();

}


/**
 * @brief           Destroy referenced object
 */
template<class T> inline void 
DestroyObject (const mxArray* in) {

    delete MatlabToHandlePointer<T>(in);
    mexUnlock();

}

#endif
