#ifndef FILE_OPERATIONS_H
#define FILE_OPERATIONS_H

#define FILE_NOT_EXIST      -1

#define FILE_FOUND_YES      1
#define FILE_FOUND_NO       0

<<<<<<< HEAD
#define BUF_SIZE            200
=======
#define BUF_SIZE			200
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16

int check_file(char *file);
int check_files();
void move_file(char *source_file, char *destination_file);
void change_owner(char *file, char *user, char *group);

#endif
