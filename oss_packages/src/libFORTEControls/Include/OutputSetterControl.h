/*
 * OutputSetterControl.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef OUTPUTSETTERCONTROL_H_
#define OUTPUTSETTERCONTROL_H_

#include <FORTEControl.h>
#include <OutputSetter.h>

class OutputSetterControl: public FORTEControl {
private:
	OutputSetter *outputSetter;

public:
	OutputSetterControl(OutputSetter* outputSetter);

	void setOutputState(const string outputState);

	void setOutputName(std::string outputName);

	virtual ~OutputSetterControl();
};
#endif /* OUTPUTSETTERCONTROL_H_ */
