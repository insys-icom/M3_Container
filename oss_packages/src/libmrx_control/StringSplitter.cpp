/*
 * StringSplitter.cpp
 *
 *  Created on: 03.01.2017
 *      Author: michael
 */

#include "StringSplitter.h"

#include <sstream>
using std::getline;
using std::string;
using std::vector;

vector<string> StringSplitter::splitString(const string stringToSplit, const char delimiter) {
	vector<string> splitStrings;

    std::stringstream stringStream;
    string partOfString;

    stringStream.str(stringToSplit);

    while (getline(stringStream, partOfString, delimiter)) {
    	splitStrings.push_back(partOfString);
    }

    return splitStrings;
}
