/*
 * Rebooter.h
 *
 *  Created on: 16.01.2017
 *      Author: Michael Schindler
 */

#ifndef REBOOTER_H_
#define REBOOTER_H_

class Rebooter {
public:
	virtual void tryToReboot() = 0;
	virtual ~Rebooter();
};

#endif /* REBOOTER_H_ */
