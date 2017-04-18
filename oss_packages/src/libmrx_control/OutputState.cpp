/*
 * outputState.cpp
 *
 *  Created on: 02.01.2017
 *      Author: michael
 */


#include "Include/OutputState.h"

#include "Exceptions.h"

OutputState::OutputState(string state) : stateOfOutput(state) {}

bool OutputState::isClose() {
	return stateOfOutput == "close";
}

bool OutputState::isOpen() {
	return stateOfOutput == "open";
}

bool OutputState::isToggle() {
	return stateOfOutput == "toggle";
}

void OutputState::setOutputState(string outputState) {
	stateOfOutput = outputState;
}
