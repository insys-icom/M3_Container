/*
 * MRXInputReader.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "MRXInputReader.h"
#include "../Include/Exceptions.h"
#include <regex>

void MRXInputReader::checkInputName() {
	std::regex e("^\\d+.\\d+$");
	if (inputName.empty() || !std::regex_match(inputName, e)) {
		throw InvalidNameException();
	}
}

