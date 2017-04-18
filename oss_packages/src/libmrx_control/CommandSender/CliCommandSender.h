/*
 * NewCliConnector.h
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#ifndef CLICONNECTOR_H_
#define CLICONNECTOR_H_

#include <string>

#include "../CommandSender/CommandSender.h"

class CliCommandSender : public CommandSender{
public:
	virtual void tryToSendCliCommand(const std::string cliCommand) = 0;
	virtual std::string tryToQueryCliCommand(const std::string cliCommand) = 0;

	virtual ~CliCommandSender(){}
};

#endif /* CLICONNECTOR_H_ */
