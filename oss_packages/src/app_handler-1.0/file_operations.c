#include <fcntl.h>
#include <grp.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#include "file_operations.h"

int check_file(char *file) {
  return access(file, F_OK);
}

void move_file(char *source_file, char *destination_file) {
  char command[BUF_SIZE];

  snprintf(command, BUF_SIZE,"mv %s %s", source_file, destination_file);

  system(command);
}

void change_owner(char *file, char *user, char *group) {
  struct passwd *pwd;
  struct group  *grp;
  int            fildes;

  fildes = open(file, O_RDWR);

  if(fildes == -1){
      perror("Error openning file");
      return;
  }

  pwd = getpwnam(user);
  grp = getgrnam(group);

  fchown(fildes, pwd->pw_uid, grp->gr_gid);

  close(fildes);
}
