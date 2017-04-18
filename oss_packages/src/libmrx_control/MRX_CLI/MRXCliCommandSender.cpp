/*
 * MRXCliCommandSender.cpp
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#include "MRXCliCommandSender.h"
#include <array>
#include "../Include/Exceptions.h"

extern "C" {
#include "m3_cli.h"
}

using std::string;

constexpr auto SOCKET = "/devices/cli_no_auth/cli.socket";
constexpr auto DEFAULT_WAITTIME_MS = 100;

MRXCliCommandSender::MRXCliCommandSender() {
	try
	{
		tryToInitialiseCliConnection();
		setConnectionSuccessfull();
	}
	catch (InitialisationFailureException &) {
		setConnectionError();
		throw;
	}
}

void MRXCliCommandSender::tryToInitialiseCliConnection() {

	cliSocket = m3_cli_initialise(SOCKET, DEFAULT_WAITTIME_MS);

	if(cliSocket == NULL) {
		throw InitialisationFailureException();
	}
}

void MRXCliCommandSender::tryToSendCliCommand(const string cliCommand) {
	if (!this->isConnectedSuccessfully()) {
		throw NotInitialisedExcpetion();
	}

	if (!m3_cli_send(this->cliSocket, (char*) ((cliCommand.c_str())))) {
		throw CommandFailureException("Sending command [" + cliCommand + "] to CLI failed");
	}
}

string MRXCliCommandSender::tryToQueryCliCommand(
	const string cliCommand) {
	char* answer[10];

	if (!this->isConnectedSuccessfully()) {
		throw NotInitialisedExcpetion();
	}

	if (!m3_cli_query(this->cliSocket, (char*) ((cliCommand.c_str())), answer, DEFAULT_WAITTIME_MS)) {
		throw CommandFailureException("Error queriing command [" + cliCommand + "]");
	}

	return *answer;
}

MRXCliCommandSender::~MRXCliCommandSender() {
	m3_cli_shutdown(&this->cliSocket);
}
