#ifndef FILE_OPERATIONS_H
#define FILE_OPERATIONS_H

#define FILE_NOT_EXIST	-1

#define BUF_SIZE	200

int check_file(char *file);
void move_file(char *source_file, char *destination_file);
void change_owner(char *file, char *user, char *group);

#endif
