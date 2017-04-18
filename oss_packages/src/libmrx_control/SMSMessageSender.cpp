/*
 * SMSMessageSender.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/SMSMessageSender.h"

SMSMessageSender::SMSMessageSender() {}
SMSMessageSender::SMSMessageSender(SMSMessage smsMessage) :	smsMessage(smsMessage) {}

void SMSMessageSender::setSMSMessage(const SMSMessage smsMessage) {
	this->smsMessage = smsMessage;
}
