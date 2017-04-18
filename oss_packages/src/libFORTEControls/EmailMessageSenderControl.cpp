/*
 * EmailMessageSenderControl.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/EmailMessageSenderControl.h"
#include <Exceptions.h>

EmailMessageSenderControl::EmailMessageSenderControl(EmailMessageSender* emailMessageSender) : emailMessageSender(emailMessageSender) {
	if(!emailMessageSender) {
		setControlErrorStatusAndMessage("ERROR: Initialisation failed");
	} else {
		setControlStatusOK();
	}
}

void EmailMessageSenderControl::setEmailMessage(const EmailMessage email) {
	if (!emailMessageSender) {
		setControlErrorStatusAndMessage("ERROR: Not initialised");
		return;
	}

	emailMessageSender->setMessage(email);
}

void EmailMessageSenderControl::sendEmailMessage() {
	try {
		emailMessageSender->tryToSendEmailMessage();
		setControlStatusOK();
	} catch (NotInitialisedExcpetion&) {
		setControlErrorStatusAndMessage("ERROR: Connection to CLI not initialised");
	} catch (InvalidRecipientException&) {
		setControlErrorStatusAndMessage("ERROR: Invalid recipient of email");
	} catch (CommandFailureException& exception) {
		setControlErrorStatusAndMessage("ERROR: " + exception.errorMessage + "[" + exception.cliCommand + "]");
	}
}

EmailMessageSenderControl::~EmailMessageSenderControl() {
	delete emailMessageSender;
}

