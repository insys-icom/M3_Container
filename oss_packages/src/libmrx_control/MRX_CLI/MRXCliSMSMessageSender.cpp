/*
 * MRXCliSMSMessageSenger.cpp
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliSMSMessageSender.h"
#include "../Include/Exceptions.h"
#include "MRXCliCommandSender.h"

using std::string;

MRXCliSMSMessageSender::MRXCliSMSMessageSender() : MRXCliSMSMessageSender(SMSMessage("", "", "")) {}
MRXCliSMSMessageSender::MRXCliSMSMessageSender(SMSMessage sms) {}

void MRXCliSMSMessageSender::tryToSendSMSMessage() {
	for (string recipient : getRecipients()) {
		SMSMessage singleSMS { };

		singleSMS.recipient = recipient;
		singleSMS.text = smsMessage.text;

		sendSingleSMS(singleSMS);
	}
}

void MRXCliSMSMessageSender::sendSingleSMS(SMSMessage sms) {
	string cliCommand { };

	cliCommand = "help.debug.sms.recipient=" + sms.recipient;
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "help.debug.sms.modem=" + sms.modem;
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "help.debug.sms.text=-----BEGIN sms-----" + sms.text;
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "-----END sms-----";
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommandSender.tryToSendCliCommand("help.debug.sms.submit");
}
