/*
 * RebooterControl.cpp
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#include "Include/RebooterControl.h"
#include <Exceptions.h>

RebooterControl::RebooterControl(Rebooter* rebooter) : rebooter(rebooter) {
	if(!rebooter) {
		setControlErrorStatusAndMessage("ERROR: Initialisation failed");
	} else {
		setControlStatusOK();
	}
}

void RebooterControl::reboot() {
	try {
		rebooter->tryToReboot();
		setControlStatusOK();
	} catch (NotInitialisedExcpetion&) {
		setControlErrorStatusAndMessage(
				"ERROR: Connection to CLI not initialised");
	} catch (CommandFailureException& exception) {
		setControlErrorStatusAndMessage(
				"ERROR: " + exception.errorMessage + "[" + exception.cliCommand
						+ "]");
	}
}

RebooterControl::~RebooterControl() {
	// TODO Auto-generated destructor stub
}

