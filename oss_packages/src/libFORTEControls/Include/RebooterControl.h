/*
 * RebooterControl.h
 *
 *  Created on: 17.01.2017
 *      Author: Michael Schindler
 */

#ifndef REBOOTERCONTROL_H_
#define REBOOTERCONTROL_H_

#include "FORTEControl.h"
#include <Rebooter.h>

class RebooterControl: public FORTEControl {
private:
	Rebooter *rebooter;
public:
	RebooterControl(Rebooter* rebooter);

	void reboot();
	virtual ~RebooterControl();
};
#endif /* REBOOTERCONTROL_H_ */
