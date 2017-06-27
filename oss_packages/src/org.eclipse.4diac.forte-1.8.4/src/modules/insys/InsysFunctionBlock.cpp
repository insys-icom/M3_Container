/*
 * InsysFunctionBlock.cpp
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#include "InsysFunctionBlock.h"

#include <iostream>

std::unique_ptr<Factory> InsysFunctionBlock::factory = 0;

void InsysFunctionBlock::setInitialised() {
	initialised = true;
}

void InsysFunctionBlock::resetInitialised() {
	initialised = false;
}

bool InsysFunctionBlock::isInitialised() {
	return initialised;
}

InsysFunctionBlock::InsysFunctionBlock() {
	if(factory == 0) {
		factory = std::make_unique<MRXCliFactory>();
	}

	initialised = factory == 0 ? false : true;
}

InsysFunctionBlock::~InsysFunctionBlock() {}
