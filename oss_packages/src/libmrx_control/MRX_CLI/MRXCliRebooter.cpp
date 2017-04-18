/*
 * MRXCliRebooter.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliRebooter.h"

void MRXCliRebooter::tryToReboot() {
	cliCommandSender.tryToSendCliCommand("administration.reset.reset");
}
