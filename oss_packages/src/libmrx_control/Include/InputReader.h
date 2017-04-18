/*
 * input_reader.h
 *
 *  Created on: 02.01.2017
 *      Author: michael
 */

#ifndef INPUTREADER_H_
#define INPUTREADER_H_

#include <string>
#include <vector>

struct InputInfo {
public:
	std::string slotNumber;
	std::string boardName;
	std::string inputNumber;
};

class InputReader {

protected:
	std::string inputName;

	InputReader();
	InputReader(std::string inputName);

	virtual void checkInputName() = 0;

public:
	void setInputName(std::string inputName);
	virtual std::string tryToReadInputState() = 0;

	virtual ~InputReader(){}
};
#endif /* INPUTREADER_H_ */
