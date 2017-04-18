/*
 * MRXInputReader.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRX_MRXINPUTREADER_H_
#define MRX_MRXINPUTREADER_H_

#include "../Include/InputReader.h"

class MRXInputReader: public InputReader {
protected:
	MRXInputReader() : MRXInputReader(""){}
	MRXInputReader(std::string inputName) : InputReader(inputName) {}

	void checkInputName();
};
#endif /* MRX_MRXINPUTREADER_H_ */
