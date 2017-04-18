/*
 * EmailMessageSender.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/EmailMessageSender.h"

EmailMessageSender::EmailMessageSender(EmailMessage email) :
		emailMessage(email) {
}

EmailMessageSender::EmailMessageSender() {}

void EmailMessageSender::setMessage(EmailMessage email) {
	this->emailMessage = email;
}
