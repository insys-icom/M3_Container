/*
 * MRXCliControlFactory.cpp
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#include "../Include/MRXCliFactory.h"
#include "MRXCliInputReader.h"
#include "MRXCliOutputSetter.h"
#include "MRXCliEmailMessageSender.h"
#include "MRXCliSMSMessageSender.h"
#include "MRXCliRebooter.h"
#include "MRXCliCliCommander.h"
#include "Exceptions.h"

InputReader* MRXCliFactory::getInputControl() {
	try
	{
		return new MRXCliInputReader { };
	}
	catch(InitialisationFailureException&){
		return nullptr;
	}
}

OutputSetter* MRXCliFactory::getOutputSetter() {
	try
	{
		return new MRXCliOutputSetter { };
	}
	catch(InitialisationFailureException&){
		return nullptr;
	}
}

SMSMessageSender* MRXCliFactory::getSMSMessageSender() {
	try
	{
		return new MRXCliSMSMessageSender { };
	}
	catch(InitialisationFailureException&){
		return nullptr;
	}
}

EmailMessageSender* MRXCliFactory::getEmailMessageSender() {
	try
	{
		return new MRXCliEmailMessageSender { };
	}
	catch(InitialisationFailureException&){
		return nullptr;
	}
}

CliCommander* MRXCliFactory::getCliCommander() {
	try {
		return new MRXCliCliCommander { };
	} catch (InitialisationFailureException&) {
		return nullptr;
	}
}

Rebooter* MRXCliFactory::getRebooter() {
	try
	{
		return new MRXCliRebooter { };
	}
	catch(InitialisationFailureException&){
		return nullptr;
	}
}
