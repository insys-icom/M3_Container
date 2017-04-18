/*
 * SMSMessageSenderControl.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef SMSMESSAGESENDERCONTROL_H_
#define SMSMESSAGESENDERCONTROL_H_

#include "FORTEControl.h"
#include <SMSMessageSender.h>
#include <Exceptions.h>

class SMSMessageSenderControl: public FORTEControl {
private:
	SMSMessageSender *smsMessageSender;
public:
	SMSMessageSenderControl(SMSMessageSender* smsMessageSender);

	void setSMSMessage(SMSMessage sms);
	void sendSMSMessage();

	virtual ~SMSMessageSenderControl();
};
#endif /* SMSMESSAGESENDERCONTROL_H_ */
