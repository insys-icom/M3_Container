#ifndef READ_CONFIG_H_
#define READ_CONFIG_H_

#include <stdint.h>

/* Get Functions */
int getIntFromFile(char *file, char *name);

int getStringFromFile_n(char *file, char *name, char buffer[], int size_buffer);

#endif /* READ_CONFIG_H_ */
