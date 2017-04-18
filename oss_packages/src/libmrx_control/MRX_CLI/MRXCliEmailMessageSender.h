/*
 * MRXCliEmailMessageSender.h
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRXCLIEMAILMESSAGESENDER_H_
#define MRXCLIEMAILMESSAGESENDER_H_

#include "../MRX/MRXEmailMessageSender.h"
#include "MRXCliCommandSender.h"

class MRXCliEmailMessageSender: public MRXEmailMessageSender {
private:
	MRXCliCommandSender cliCommandSender;
	void sendSingleEmail(EmailMessage email);

public:
	MRXCliEmailMessageSender();
	MRXCliEmailMessageSender(EmailMessage email);

	void tryToSendEmailMessage();
};
#endif /* MRXCLIEMAILMESSAGESENDER_H_ */
