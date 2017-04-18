/*
 * InsysFunctionBlock.h
 *
 *  Created on: 10.01.2017
 *      Author: Michael Schindler
 */

#ifndef SRC_MODULES_INSYS_INSYSFUNCTIONBLOCK_H_
#define SRC_MODULES_INSYS_INSYSFUNCTIONBLOCK_H_

#include <MRXCliFactory.h>
#include <memory>

class InsysFunctionBlock {
private:
	bool initialised;
protected:
	static std::unique_ptr<Factory> factory;

	void setInitialised();
	void resetInitialised();
	bool isInitialised();

	InsysFunctionBlock();
	~InsysFunctionBlock();
};
#endif /* SRC_MODULES_INSYS_INSYSFUNCTIONBLOCK_H_ */
