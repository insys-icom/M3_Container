/*
 * outputInfo.h
 *
 *  Created on: 02.01.2017
 *      Author: michael
 */

#ifndef SRC_MODULES_INSYS_OUTPUTINFO_H_
#define SRC_MODULES_INSYS_OUTPUTINFO_H_

#include <string>
using std::string;

class OutputState {
private:
	string stateOfOutput;

public:
	OutputState() {}
	OutputState(string state);

	bool isClose();
	bool isOpen();
	bool isToggle();

	void setOutputState(string outputState);
};
#endif /* SRC_MODULES_INSYS_OUTPUTSTATE_H_ */
