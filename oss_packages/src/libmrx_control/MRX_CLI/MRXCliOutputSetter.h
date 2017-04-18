/*
 * MRXCliOutputSetter.h
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRXCLIOUTPUTSETTER_H_
#define MRXCLIOUTPUTSETTER_H_

#include "../MRX/MRXOutputSetter.h"
#include "MRXCliCommandSender.h"

class MRXCliOutputSetter: public MRXOutputSetter {
private:
	MRXCliCommandSender cliCommandSender;

	void sendOutputNameCommand(const OutputState& outputState);
	void sendChangeCommand(const OutputState& outputState);
	std::string getOutputChangeCliCommand(OutputState outputState);
	void sendSubmitCommand();

public:
	MRXCliOutputSetter();
	MRXCliOutputSetter(const std::string outputname);

	void tryToSetOutputState(const OutputState &outputState);
};
#endif /* MRXCLIOUTPUTSETTER_H_ */
