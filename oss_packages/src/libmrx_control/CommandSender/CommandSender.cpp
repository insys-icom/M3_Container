/*
 * Connector.cpp
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#include "../CommandSender/CommandSender.h"

CommandSender::CommandSender() {
	this->connectedSuccessfully = false;
}

void CommandSender::setConnectionSuccessfull() {
	this->connectedSuccessfully = true;
}

void CommandSender::setConnectionError() {
	this->connectedSuccessfully = false;
}

bool CommandSender::isConnectedSuccessfully() {
	return this->connectedSuccessfully;
}
