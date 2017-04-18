/*
 * MRXEmailMessageSender.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "MRXEmailMessageSender.h"

#include "../Include/Exceptions.h"
#include "../StringSplitter.h"
using std::vector;
using std::string;

MRXEmailMessageSender::MRXEmailMessageSender() {}
MRXEmailMessageSender::MRXEmailMessageSender(EmailMessage email) : EmailMessageSender(email) {}

void MRXEmailMessageSender::checkEmailMessage() {
	//TODO: implement checking routine
	return;
}

std::vector<string> MRXEmailMessageSender::getRecipients() {
	vector<string> allRecipients { };
	StringSplitter splitter { };

	if (emailMessage.recipient.empty()) {
		throw InvalidRecipientException();
	}

	allRecipients = splitter.splitString(emailMessage.recipient, ';');

	if (allRecipients.size() == 0) {
		throw InvalidRecipientException();
	}

	return allRecipients;
}
