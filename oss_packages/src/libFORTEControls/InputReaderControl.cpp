/*
 * InputReaderControl.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/InputReaderControl.h"
using std::string;

InputReaderControl::InputReaderControl(InputReader* inputReader) : inputReader(inputReader) {
	if(!inputReader) {
		setControlErrorStatusAndMessage("ERROR: Initialisation failed");
	} else {
		setControlStatusOK();
	}
}

void InputReaderControl::setInputName(std::string inputName) {
	if (!inputReader) {
		setControlErrorStatusAndMessage("ERROR: Could not set inputname");
		return;
	}
	inputReader->setInputName(inputName);
}

std::__cxx11::string InputReaderControl::readInputState() {
	string inputState { };
	if (!inputReader) {
		setControlErrorStatusAndMessage("ERROR: Not initialised");
		return "ERROR: Not initialised";
	}

	try
	{
		inputState = inputReader->tryToReadInputState();
		setControlStatusOK();
	}
	catch (NotInitialisedExcpetion&) {
		setControlErrorStatusAndMessage("ERROR: connection to CLI not initialised");
	}
	catch (InvalidNameException&) {
		setControlErrorStatusAndMessage("ERROR: Name of Input is invalid");
	}
	catch (InvalidInputStateException& exception) {
		setControlErrorStatusAndMessage("ERROR: Invalid input state(" + exception.getInvalidState() + ")");
	}
	catch (InputReadingException& exception) {
		setControlErrorStatusAndMessage(exception.getErrorMessage());
	}
	catch (CommandFailureException& exception) {
		setControlErrorStatusAndMessage("ERROR: " + exception.errorMessage);
	}

	return inputState;
}

InputReaderControl::~InputReaderControl() {
	delete inputReader;
}

