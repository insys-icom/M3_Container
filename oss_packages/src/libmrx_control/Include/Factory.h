/*
 * Controlfactory.h
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#ifndef FACTORIES_CONTROLFACTORY_H_
#define FACTORIES_CONTROLFACTORY_H_

#include "InputReader.h"
#include "OutputSetter.h"
#include "Rebooter.h"
#include "EmailMessageSender.h"
#include "Messages.h"
#include "CliCommander.h"
#include "SMSMessageSender.h"

class Factory {
public:
	virtual InputReader* getInputControl() = 0;
	virtual OutputSetter* getOutputSetter() = 0;

	virtual SMSMessageSender* getSMSMessageSender() = 0;
	virtual EmailMessageSender* getEmailMessageSender() = 0;

	virtual CliCommander* getCliCommander() = 0;

	virtual Rebooter* getRebooter() = 0;

	virtual ~Factory(){}
};

#endif /* FACTORIES_CONTROLFACTORY_H_ */
