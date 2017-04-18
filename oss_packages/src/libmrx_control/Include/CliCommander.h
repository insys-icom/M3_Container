/*
 * CliCommander.h
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#ifndef CLICOMMANDER_H_
#define CLICOMMANDER_H_

#include <string>

class CliCommander {
public:
	virtual void tryToSendCliCommand(const std::string cliCommand) = 0;
	virtual std::string tryToQueryCliCommand(const std::string cliCommand) = 0;

	virtual ~CliCommander(){}
};

#endif /* CLICOMMANDER_H_ */
