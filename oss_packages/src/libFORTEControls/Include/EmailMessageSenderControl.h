/*
 * EmailMessageSenderControl.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef EMAILMESSAGESENDERCONTROL_H_
#define EMAILMESSAGESENDERCONTROL_H_

#include "FORTEControl.h"
#include <EmailMessageSender.h>
#include <Exceptions.h>

class EmailMessageSenderControl: public FORTEControl {
private:
	EmailMessageSender *emailMessageSender;
public:
	EmailMessageSenderControl(EmailMessageSender* emailMessageSender);

	void setEmailMessage(const EmailMessage email);
	void sendEmailMessage();

	virtual ~EmailMessageSenderControl();
};
#endif /* EMAILMESSAGESENDERCONTROL_H_ */
