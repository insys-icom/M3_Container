/*
 * MRXCliInputControl.cpp
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliInputReader.h"

#include "../Include/InputReader.h"
#include "../Include/Exceptions.h"
#include "../StringSplitter.h"
#include "../CardInfoProvider.h"

#include <regex>
using std::regex;
using std::vector;
using std::string;

MRXCliInputReader::MRXCliInputReader() : MRXCliInputReader("") {}
MRXCliInputReader::MRXCliInputReader(string inputName) : MRXInputReader(inputName) {}

std::__cxx11::string MRXCliInputReader::tryToReadInputState() {
	string inputState { };
	string cliCommand { }, responseFromCli { };
	InputInfo info { };

	checkInputName();

	info = getInputInfo();

	cliCommand = "status.";
	cliCommand.append(info.boardName);
	cliCommand.append(info.slotNumber);
	cliCommand.append(".input_");
	cliCommand.append(info.inputNumber);

	responseFromCli = cliCommandSender.tryToQueryCliCommand(cliCommand);

	if (responseFromCli != "high" && responseFromCli != "low") {
		throw InvalidInputStateException(inputState);
	}

	return responseFromCli;
}

InputInfo MRXCliInputReader::getInputInfo() {
	InputInfo info { };
	vector<string> numbers { };
	int slotNumberAsInt { };

	numbers = getNumbersOutOfInputName();
	slotNumberAsInt = atoi(numbers.at(0).c_str());

	info.slotNumber = numbers.at(0);
	info.boardName = getBoardName(slotNumberAsInt);
	info.inputNumber = numbers.at(1);

	return info;
}

std::vector<std::string> MRXCliInputReader::getNumbersOutOfInputName() {
	vector<string> numbers = splitInputNameIntoNumbers();

	if (numbers.size() != 2) {
		throw InvalidNameException();
	}

	return numbers;
}

std::vector<string> MRXCliInputReader::splitInputNameIntoNumbers() {
	StringSplitter splitter { };

	return splitter.splitString(inputName, '.');
}

std::__cxx11::string MRXCliInputReader::getBoardName(int slotNumber) {
	CardInfoProvider info { };
	string boardName { };

	if (!info.get_board_name(slotNumber, boardName)) {
		throw CommandFailureException("Could not read board name from CLI");
	}

	return boardName;
}

void MRXCliInputReader::checkInputName() {
	std::regex e("^\\d+.\\d+$");

	if (!regex_match(inputName, e)) {
		throw InvalidNameException();
	}

	return;
}
