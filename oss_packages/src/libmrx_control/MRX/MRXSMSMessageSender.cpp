/*
 * MRXSMSMessageSender.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "MRXSMSMessageSender.h"

#include "../StringSplitter.h"
#include "../Include/Exceptions.h"
using std::vector;
using std::string;

void MRXSMSMessageSender::checkSMSMessage() {
	//TODO: implement checking routine
	return;
}

std::vector<string> MRXSMSMessageSender::getRecipients() {
	vector<string> allRecipients { };
	StringSplitter splitter { };
	if (smsMessage.recipient.empty()) {
		throw InvalidRecipientException();
	}
	allRecipients = splitter.splitString(smsMessage.recipient, ';');
	if (allRecipients.size() == 0) {
		throw InvalidRecipientException();
	}
	return allRecipients;
}
