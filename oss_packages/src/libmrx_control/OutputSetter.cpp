/*
 * OutputSetter.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "Include/OutputSetter.h"

OutputSetter::OutputSetter() :
		OutputSetter("") {
}

OutputSetter::OutputSetter(std::string outputName) :
		outputName(outputName) {
}

void OutputSetter::setOutputName(std::string outputName) {
	this->outputName = outputName;
}

OutputSetter::~OutputSetter() {
	// TODO Auto-generated destructor stub
}

