/*
 * InputReaderControl.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef INPUTREADERCONTROL_H_
#define INPUTREADERCONTROL_H_

#include "FORTEControl.h"
#include <InputReader.h>
#include <Exceptions.h>

class InputReaderControl: public FORTEControl {
private:
	InputReader *inputReader;

public:
	InputReaderControl(InputReader* inputReader);

	void setInputName(std::string inputName);

	std::string readInputState();

	virtual ~InputReaderControl();
};
#endif /* INPUTREADERCONTROL_H_ */
