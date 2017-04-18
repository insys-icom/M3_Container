/*
 * card_info_provider.h
 *
 *  Created on: 20.12.2016
 *      Author: michael
 */

#ifndef SRC_MODULES_INSYS_CARD_INFO_PROVIDER_H_
#define SRC_MODULES_INSYS_CARD_INFO_PROVIDER_H_

#include <string>

using std::string;

class CardInfoProvider {
private:
	bool get_board_type(int slot_number, std::string &board_type);

public:
	bool get_board_name(int slot_number, string &board_name);
};



#endif /* SRC_MODULES_INSYS_DEVICE_INFO_PROVIDER_H_ */
