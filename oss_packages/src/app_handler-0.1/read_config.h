/*
 * read_config.h
 *
 *  Created on: 13.09.2016
 *      Author: michael
 */

#ifndef READ_CONFIG_H_
#define READ_CONFIG_H_

/* Get Functions */
int getIntFromFile(char *file, char *name);

int getStringFromFile_n(char *file, char *name, char buffer[], int size_buffer);

#endif /* READ_CONFIG_H_ */
