/*
 * OutputSetter.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef OUTPUTSETTER_H_
#define OUTPUTSETTER_H_

#include <string>
#include "OutputState.h"

class OutputSetter {
protected:
	OutputSetter();
	OutputSetter(std::string outputName);
	std::string outputName;

	virtual void checkOutputName() = 0;

public:
	void setOutputName(std::string outputName);

	virtual void tryToSetOutputState(const OutputState &outputState) = 0;

	virtual ~OutputSetter();
};
#endif /* OUTPUTSETTER_H_ */
