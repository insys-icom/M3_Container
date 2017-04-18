/*
 * MRXOutputSetter.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "MRXOutputSetter.h"
#include "../Include/Exceptions.h"

MRXOutputSetter::MRXOutputSetter(std::string outputName) :
		OutputSetter(outputName) {
}

void MRXOutputSetter::checkOutputName() {
	if (this->outputName.empty()) {
		throw InvalidNameException();
	}
}
