/*
 * MRXSMSMessageSender.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRX_MRXSMSMESSAGESENDER_H_
#define MRX_MRXSMSMESSAGESENDER_H_

#include "../Include/SMSMessageSender.h"
#include <vector>
#include <string>

class MRXSMSMessageSender: public SMSMessageSender {
protected:
	void checkSMSMessage();

	std::vector<std::string> getRecipients();
public:
	MRXSMSMessageSender() {}
	MRXSMSMessageSender(SMSMessage sms) : SMSMessageSender(sms){}
};
#endif /* MRX_MRXSMSMESSAGESENDER_H_ */
