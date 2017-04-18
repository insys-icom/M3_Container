/*
 * MRXMessages.h
 *
 *  Created on: 03.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRXMESSAGES_H_
#define MRXMESSAGES_H_

#include <string>

struct Message {
public:
	std::string text;
	std::string recipient;

	Message(){}
	Message(std::string text, std::string recipient) : text(text), recipient(recipient){}
};


struct EmailMessage : Message {
public:
	std::string subject;

	EmailMessage(){}
	EmailMessage(std::string recipient, std::string text, std::string subject) : Message(text,recipient), subject(subject){}
};


struct SMSMessage : Message {
public:
	std::string modem;

	SMSMessage(){}
	SMSMessage(std::string recipient, std::string text, std::string modem) : Message(text,recipient), modem(modem){}
};

#endif /* MRXMESSAGES_H_ */
