/*
 * SMSMessageSenderControl.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/SMSMessageSenderControl.h"
#include <Exceptions.h>

SMSMessageSenderControl::SMSMessageSenderControl(SMSMessageSender* smsMessageSender) : smsMessageSender(smsMessageSender) {
	if(!smsMessageSender) {
		setControlErrorStatusAndMessage("ERROR: Initialisation failed");
	} else {
		setControlStatusOK();
	}
}

void SMSMessageSenderControl::setSMSMessage(SMSMessage sms) {
	if (!smsMessageSender) {
		setControlErrorStatusAndMessage("ERROR: Not initialised");
		return;
	}
	smsMessageSender->setSMSMessage(sms);
}

void SMSMessageSenderControl::sendSMSMessage() {
	try {
		smsMessageSender->tryToSendSMSMessage();
		setControlStatusOK();
	} catch (NotInitialisedExcpetion&) {
		setControlErrorStatusAndMessage("ERROR: Connection to CLI not initialised");
	} catch (InvalidRecipientException&) {
		setControlErrorStatusAndMessage("ERROR: Invalid recipient of sms");
	} catch (CommandFailureException& exception) {
		setControlErrorStatusAndMessage("ERROR: " + exception.errorMessage + "[" + exception.cliCommand + "]");
	}
}

SMSMessageSenderControl::~SMSMessageSenderControl() {
	delete smsMessageSender;
}

