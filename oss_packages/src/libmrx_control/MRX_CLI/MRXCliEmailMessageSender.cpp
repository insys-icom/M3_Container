/*
 * MRXCliEmailMessageSender.cpp
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliEmailMessageSender.h"
#include "../Include/Exceptions.h"
#include "MRXCliCommandSender.h"

using std::string;

MRXCliEmailMessageSender::MRXCliEmailMessageSender() : MRXCliEmailMessageSender(EmailMessage("", "", "")) {}
MRXCliEmailMessageSender::MRXCliEmailMessageSender(EmailMessage email) : MRXEmailMessageSender(email){}

void MRXCliEmailMessageSender::tryToSendEmailMessage() {
	for (string recipient : getRecipients()) {
		EmailMessage singleEmail { };

		singleEmail.recipient = recipient;
		singleEmail.subject = emailMessage.subject;
		singleEmail.text = emailMessage.text;

		sendSingleEmail(singleEmail);
	}
}

void MRXCliEmailMessageSender::sendSingleEmail(EmailMessage email) {
	string cliCommand { };

	cliCommand = "help.debug.email.recipient=" + email.recipient;
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "help.debug.email.subject=" + email.subject;
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "help.debug.email.text=-----BEGIN mail-----" + email.text;
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "-----END mail-----";
	cliCommandSender.tryToSendCliCommand(cliCommand);

	cliCommand = "help.debug.email.submit";
	cliCommandSender.tryToSendCliCommand(cliCommand);
}
