/*
 * SendCliCommandControl.h
 *
 *  Created on: 11.01.2017
 *      Author: Michael Schindler
 */

#ifndef INCLUDE_SENDCLICOMMANDCONTROL_H_
#define INCLUDE_SENDCLICOMMANDCONTROL_H_

#include "Control.h"

class SendCliCommandControl: public Control {
public:
	virtual void sendCliCommand(string cliCommand) = 0;
	virtual string queryCliCommand(string cliCommand) = 0;

	virtual ~SendCliCommandControl() {}
};
#endif /* INCLUDE_SENDCLICOMMANDCONTROL_H_ */
