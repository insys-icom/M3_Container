/*
 * MRXCliCliCommander.cpp
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliCliCommander.h"

void MRXCliCliCommander::tryToSendCliCommand(const std::string cliCommand) {
	cliCommandSender.tryToSendCliCommand(cliCommand);
}

std::string MRXCliCliCommander::tryToQueryCliCommand(const std::string cliCommand) {
	return cliCommandSender.tryToQueryCliCommand(cliCommand);
}
