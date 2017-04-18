/*
 * input_reader.cpp
 *
 *  Created on: 02.01.2017
 *      Author: michael
 */


#include <stdlib.h>
#include <sstream>

#include "Include/InputReader.h"
#include "CardInfoProvider.h"
#include "StringSplitter.h"

#include "CommandSender/CliCommandSender.h"
#include "Include/Exceptions.h"
#include "MRX_CLI/MRXCliCommandSender.h"

using std::string;
using std::vector;

InputReader::InputReader(string inputName) : inputName(inputName) {}

InputReader::InputReader() :
		InputReader("") {
}

void InputReader::setInputName(std::string inputName) {
	this->inputName = inputName;
}
