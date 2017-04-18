/*
 * MRXCliControlFactory.h
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#ifndef FACTORIES_MRXCLICONTROLFACTORY_H_
#define FACTORIES_MRXCLICONTROLFACTORY_H_

#include "Factory.h"

class MRXCliFactory: public Factory {
public:
	InputReader* getInputControl();

	OutputSetter* getOutputSetter();

	SMSMessageSender* getSMSMessageSender();

	EmailMessageSender* getEmailMessageSender();

	CliCommander* getCliCommander();

	Rebooter* getRebooter();
};
#endif /* FACTORIES_MRXCLICONTROLFACTORY_H_ */
