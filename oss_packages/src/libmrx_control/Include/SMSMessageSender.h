/*
 * SMSMessageSender.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef SMSMESSAGESENDER_H_
#define SMSMESSAGESENDER_H_

#include "Messages.h"

class SMSMessageSender {
protected:
	SMSMessage smsMessage;
public:
	SMSMessageSender();
	SMSMessageSender(SMSMessage smsMessage);

	void setSMSMessage(const SMSMessage smsMessage);

	virtual void tryToSendSMSMessage() = 0;
	virtual ~SMSMessageSender() {}
};
#endif /* SMSMESSAGESENDER_H_ */
