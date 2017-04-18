/*
 * EmailMessageSender.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef EMAILMESSAGESENDER_H_
#define EMAILMESSAGESENDER_H_

#include "Messages.h"

class EmailMessageSender {
protected:
	EmailMessage emailMessage;

	EmailMessageSender();
	EmailMessageSender(EmailMessage email);
public:
	void setMessage(EmailMessage email);

	virtual void tryToSendEmailMessage() = 0;
	virtual ~EmailMessageSender(){}
};
#endif /* EMAILMESSAGESENDER_H_ */
