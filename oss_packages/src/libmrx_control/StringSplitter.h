/*
 * StringSplitter.h
 *
 *  Created on: 03.01.2017
 *      Author: michael
 */

#ifndef STRINGSPLITTER_H_
#define STRINGSPLITTER_H_

#include <string>
#include <vector>

class StringSplitter {

public:
	std::vector<std::string> splitString(const std::string stringToSplit, const char delimiter);
};

#endif /* STRINGSPLITTER_H_ */
