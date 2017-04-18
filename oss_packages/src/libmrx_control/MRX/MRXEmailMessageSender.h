/*
 * MRXEmailMessageSender.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRX_MRXEMAILMESSAGESENDER_H_
#define MRX_MRXEMAILMESSAGESENDER_H_

#include "../Include/EmailMessageSender.h"
#include <vector>

class MRXEmailMessageSender : public EmailMessageSender {
protected:
	void checkEmailMessage();

	std::vector<std::string> getRecipients();
public:
	MRXEmailMessageSender();
	MRXEmailMessageSender(EmailMessage email);
};
#endif /* MRX_MRXEMAILMESSAGESENDER_H_ */
