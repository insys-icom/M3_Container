/*
 * card_info_provider.cpp
 *
 *  Created on: 20.12.2016
 *      Author: Michael Schindler
 */

#include <string>
#include <iostream>
#include <sstream>

#include "CardInfoProvider.h"

#include "CommandSender/CliCommandSender.h"
#include "MRX_CLI/MRXCliCommandSender.h"

bool CardInfoProvider::get_board_name(int slot_number, string &board_name) {
	string board_type;

	if(get_board_type(slot_number, board_type) == false) {
		std::cout << "Getting board type failed\n";
		return false;
	}

	if(board_type == "M3CPU") {
			board_name="ethernet";
	} else if(board_type == "M3PWL") {
			board_name = "lte";
	} else if(board_type == "M3SIO") {
			board_name = "sio";
	} else {
		std::cout << "Unknown board type: " << board_type << std::endl;
		return false;
	}

	return true;
}

bool CardInfoProvider::get_board_type(int slot_number, string &board_type) {
	CliCommandSender* con = new MRXCliCommandSender();
	std::ostringstream convert;
	string cmd;

	convert << slot_number;

	if(!con) {
		return false;
	}

	cmd = "status.device_info.slot[" + convert.str() + "].board_type";

	board_type = con->tryToQueryCliCommand(cmd);

	delete(con);

	return true;
}

