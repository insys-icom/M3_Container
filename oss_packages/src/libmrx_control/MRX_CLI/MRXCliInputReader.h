/*
 * MRXCliInputControl.h
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRXCLIINPUTCONTROL_H_
#define MRXCLIINPUTCONTROL_H_

#include "../MRX/MRXInputReader.h"
#include "MRXCliCommandSender.h"

#include <vector>

class MRXCliInputReader: public MRXInputReader {
private:
	MRXCliCommandSender cliCommandSender;

	void checkInputName();
	InputInfo getInputInfo();
	std::vector<std::string> getNumbersOutOfInputName();
	std::vector<std::string> splitInputNameIntoNumbers();
	std::string getBoardName(int slotNumber);

public:
	MRXCliInputReader();
	MRXCliInputReader(std::string inputName);

	std::string tryToReadInputState();
};
#endif /* MRXCLIINPUTCONTROL_H_ */
