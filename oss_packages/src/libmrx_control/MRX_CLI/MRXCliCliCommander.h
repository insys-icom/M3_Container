/*
 * MRXCliCliCommander.h
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRX_CLI_MRXCLICLICOMMANDER_H_
#define MRX_CLI_MRXCLICLICOMMANDER_H_

#include "MRXCliCommandSender.h"
#include "../MRX/MRXCliCommander.h"

class MRXCliCliCommander: public MRXCliCommander {
private:
	MRXCliCommandSender cliCommandSender;
public:
	void tryToSendCliCommand(const std::string cliCommand);
	std::string tryToQueryCliCommand(const std::string cliCommand);
};
#endif /* MRX_CLI_MRXCLICLICOMMANDER_H_ */
