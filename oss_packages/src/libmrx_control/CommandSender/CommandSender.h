/*
 * Connector.h
 *
 *  Created on: 09.01.2017
 *      Author: Michael Schindler
 */

#ifndef CONNECTOR_H_
#define CONNECTOR_H_

class CommandSender {
private:
	bool connectedSuccessfully;

protected:
	CommandSender();
	void setConnectionSuccessfull();
	void setConnectionError();
public:
	bool isConnectedSuccessfully();
};
#endif /* CONNECTOR_H_ */
