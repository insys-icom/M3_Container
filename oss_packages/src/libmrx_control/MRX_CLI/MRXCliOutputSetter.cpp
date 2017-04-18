/*
 * MRXCliOutputSetter.cpp
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliOutputSetter.h"
#include "../Include/Exceptions.h"
#include "MRXCliCommandSender.h"

using std::string;

MRXCliOutputSetter::MRXCliOutputSetter() :
		MRXCliOutputSetter("") {
}

MRXCliOutputSetter::MRXCliOutputSetter(string nameOfOutput) : MRXOutputSetter(nameOfOutput) { }

void MRXCliOutputSetter::tryToSetOutputState(const OutputState &outputState) {

	sendOutputNameCommand(outputState);

	sendChangeCommand(outputState);

	sendSubmitCommand();
}

void MRXCliOutputSetter::sendOutputNameCommand(const OutputState& outputState) {
	string cliResponse { }, cliCommand { };

	cliCommand = "help.debug.output.output=";
	cliCommand.append(this->outputName);

	cliResponse = cliCommandSender.tryToQueryCliCommand(cliCommand);

	if(!cliResponse.empty()) {
		throw CommandFailureException("Sending Outputname returned error(" + cliResponse + ")", cliCommand);
	}
}

void MRXCliOutputSetter::sendChangeCommand(const OutputState& outputState) {
	string cliCommand { }, cliResponse { };

	cliCommand = getOutputChangeCliCommand(outputState);
	cliCommandSender.tryToSendCliCommand(cliCommand);

	if(!cliResponse.empty()) {
		throw CommandFailureException("Sending Submit returned error(" + cliResponse + ")", cliCommand);
	}
}

string MRXCliOutputSetter::getOutputChangeCliCommand(OutputState outputState) {
	string outputChangeCliCommand = "help.debug.output.change=";

	if (outputState.isOpen()) {
		return outputChangeCliCommand.append("open");
	} else if (outputState.isClose()) {
		return outputChangeCliCommand.append("close");
	} else if (outputState.isToggle()) {
		return outputChangeCliCommand.append("toggle");
	} else {
		throw InvalidOutputStateException();
	}

	return outputChangeCliCommand;
}

void MRXCliOutputSetter::sendSubmitCommand() {
	string cliResponse { }, cliCommand { };

	cliCommand = "help.debug.output.submit";

	cliResponse = cliCommandSender.tryToQueryCliCommand(cliCommand);

	if(!cliResponse.empty()) {
		throw CommandFailureException("Sending Submit returned error(" + cliResponse + ")", cliCommand);
	}
}
