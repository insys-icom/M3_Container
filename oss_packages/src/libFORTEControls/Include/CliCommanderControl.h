/*
 * CliCommanderControl.h
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#ifndef CLICOMMANDERCONTROL_H_
#define CLICOMMANDERCONTROL_H_

#include "FORTEControl.h"
#include <CliCommander.h>

class CliCommanderControl: public FORTEControl {
private:
	CliCommander *cliCommander;
public:
	CliCommanderControl(CliCommander* cliCommander);

	void sendCliCommand(const std::string cliCommand);
	std::string queryCliCommand(const std::string cliCommand);

	~CliCommanderControl();
};
#endif /* CLICOMMANDERCONTROL_H_ */
