/*
 * MRXCliRebooter.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRX_MRXCLIREBOOTER_H_
#define MRX_MRXCLIREBOOTER_H_

#include "../MRX/MRXRebooter.h"
#include "MRXCliCommandSender.h"

class MRXCliRebooter: public MRXRebooter {
private:
	MRXCliCommandSender cliCommandSender;
public:
	void tryToReboot();
};
#endif /* MRX_MRXCLIREBOOTER_H_ */
