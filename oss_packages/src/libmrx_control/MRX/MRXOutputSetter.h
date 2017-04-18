/*
 * MRXOutputSetter.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRX_MRXOUTPUTSETTER_H_
#define MRX_MRXOUTPUTSETTER_H_

#include "../Include/OutputSetter.h"

class MRXOutputSetter: public OutputSetter {
protected:
	MRXOutputSetter(std::string outputName);

	void checkOutputName();
};
#endif /* MRX_MRXOUTPUTSETTER_H_ */
