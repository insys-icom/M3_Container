/*
 * CliCommanderControl.cpp
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#include "Include/CliCommanderControl.h"
#include <Exceptions.h>
using std::string;

CliCommanderControl::CliCommanderControl(CliCommander* cliCommander) : cliCommander(cliCommander) {
	if(!cliCommander) {
		setControlErrorStatusAndMessage("ERROR: Initialisation failed");
	} else {
		setControlStatusOK();
	}
}

void CliCommanderControl::sendCliCommand(const std::string cliCommand) {
	queryCliCommand(cliCommand);
}

string CliCommanderControl::queryCliCommand(const string cliCommand) {
	string cliResponse { };
	try {
		cliResponse = cliCommander->tryToQueryCliCommand(cliCommand);
		setControlStatusOK();
	} catch (NotInitialisedExcpetion&) {
		setControlErrorStatusAndMessage("ERROR: Connection to CLI not initialised");
	} catch (InvalidRecipientException&) {
		setControlErrorStatusAndMessage("ERROR: Invalid recipient of sms");
	} catch (CommandFailureException& exception) {
		setControlErrorStatusAndMessage("ERROR: " + exception.errorMessage + "[" + exception.cliCommand + "]");
	}
	return cliResponse;
}

CliCommanderControl::~CliCommanderControl() {
	delete cliCommander;
}
