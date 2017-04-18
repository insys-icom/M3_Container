/*
 * NewMRXCliConnector.h
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#ifndef MRXCLICONNECTOR_H_
#define MRXCLICONNECTOR_H_

#include "../CommandSender/CliCommandSender.h"
#include <string>

class MRXCliCommandSender: public CliCommandSender {
private:
	struct s_m3_cli *cliSocket;
	void tryToInitialiseCliConnection();
public:
	MRXCliCommandSender();

	void tryToSendCliCommand(const std::string cliCommand);
	std::string tryToQueryCliCommand(const std::string cliCommand);

	~MRXCliCommandSender();
};
#endif /* MRXCLICONNECTOR_H_ */
