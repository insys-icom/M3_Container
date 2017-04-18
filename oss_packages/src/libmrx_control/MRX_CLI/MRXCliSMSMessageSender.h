/*
 * MRXCliSMSMessageSenger.h
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRXCLISMSMESSAGESENDER_H_
#define MRXCLISMSMESSAGESENDER_H_

#include "../MRX/MRXSMSMessageSender.h"
#include "../Include/Messages.h"
#include "MRXCliCommandSender.h"

class MRXCliSMSMessageSender: public MRXSMSMessageSender {
private:
	MRXCliCommandSender cliCommandSender;

	void sendSingleSMS(SMSMessage sms);
public:
	MRXCliSMSMessageSender();
	MRXCliSMSMessageSender(SMSMessage sms);

	void tryToSendSMSMessage();
};
#endif /* MRXCLISMSMESSAGESENDER_H_ */
