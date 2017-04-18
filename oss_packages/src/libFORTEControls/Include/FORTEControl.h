/*
 * FORTEControl.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef FORTECONTROL_H_
#define FORTECONTROL_H_

#include <string>

class FORTEControl {
private:
	std::string statusMessage;
	bool isStatusOK;

protected:
	FORTEControl();
	void setControlStatusOK();
	void setControlErrorStatusAndMessage(std::string errorMessage);

public:
	bool isControlStatusOK();
	std::string getControlStatusMessage();

};
#endif /* FORTECONTROL_H_ */
