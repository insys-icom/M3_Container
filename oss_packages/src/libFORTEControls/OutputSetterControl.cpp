/*
 * OutputSetterControl.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/OutputSetterControl.h"
#include <Exceptions.h>
#include <OutputState.h>

#include <iostream>

OutputSetterControl::OutputSetterControl(OutputSetter* outputSetter) {

	if(this->outputSetter) {
		delete this->outputSetter;
	}

	if(!outputSetter) {
		std::cout << "outputsetter is null!!\n";
		setControlErrorStatusAndMessage("ERROR: Initialisation failed");
	} else {
		this->outputSetter = outputSetter;
		setControlStatusOK();
	}
}

void OutputSetterControl::setOutputState(string outputState) {
	if (!outputSetter) {
		setControlErrorStatusAndMessage("ERROR: Not initialised");
		return;
	}

	try {
		outputSetter->tryToSetOutputState(OutputState(outputState));
		setControlStatusOK();
	}
	catch (NotInitialisedExcpetion&) {
		setControlErrorStatusAndMessage("ERROR: Connection to CLI no initialised");
	}
	catch (InvalidNameException&) {
		setControlErrorStatusAndMessage("ERROR: Invalid Outputname");
	}
	catch (CommandFailureException& exception) {
		setControlErrorStatusAndMessage("ERROR: Sending CLI command failed [" + exception.errorMessage + "]");
	}
	catch (InvalidOutputStateException&) {
		setControlErrorStatusAndMessage("Invalid value for CHANGE");
	}
}

void OutputSetterControl::setOutputName(std::string outputName) {
	if (!outputSetter) {
		setControlErrorStatusAndMessage("ERROR: Could not set outputname");
		return;
	}
	outputSetter->setOutputName(outputName);
}

OutputSetterControl::~OutputSetterControl() {
	delete outputSetter;
}
