/*
 * mrx_exceptions.h
 *
 *  Created on: 02.01.2017
 *      Author: michael
 */

#ifndef SRC_MODULES_INSYS_MRX_EXCEPTIONS_H_
#define SRC_MODULES_INSYS_MRX_EXCEPTIONS_H_

#include <string>

class CommandFailureException {
public:
	std::string errorMessage;
	std::string cliCommand;

	CommandFailureException() {};

	CommandFailureException(std::string errorMessage):CommandFailureException(errorMessage, "") {}

	CommandFailureException(std::string errorMessage, std::string cliCommand) : errorMessage(errorMessage), cliCommand(cliCommand){};
};

class InitialisationFailureException {};

class NotInitialisedExcpetion {};

class InvalidOutputStateException {};

class InvalidNameException {};

class InputReadingException {
private:
	std::string errorMessage;
public:
	InputReadingException() {};
	InputReadingException(std::string errorMessage) : errorMessage(errorMessage){};

	std::string getErrorMessage() {
		return errorMessage;
	}
};

class InvalidInputStateException {

private:
	std::string invalidInputState;

public:
	std::string getInvalidState() {
		return invalidInputState;
	}

	InvalidInputStateException(std::string inputState) : invalidInputState(inputState) {}
};

class InvalidRecipientException {};

#endif /* SRC_MODULES_INSYS_MRX_EXCEPTIONS_H_ */
