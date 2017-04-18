/*
 * FORTEControl.cpp
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#include "FORTEControl.h"

FORTEControl::FORTEControl() {
	this->statusMessage = "OK";
	this->isStatusOK = true;
}

void FORTEControl::setControlStatusOK() {
	this->statusMessage = "OK";
	this->isStatusOK = true;
}

void FORTEControl::setControlErrorStatusAndMessage(std::string errorMessage) {
	this->statusMessage = errorMessage;
	this->isStatusOK = false;
}

bool FORTEControl::isControlStatusOK() {
	return isStatusOK;
}

std::__cxx11::string FORTEControl::getControlStatusMessage() {
	return statusMessage;
}
