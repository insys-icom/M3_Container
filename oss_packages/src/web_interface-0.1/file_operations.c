#include <grp.h>
#include <pwd.h>
#include "defines.h"

#include "file_operations.h"

int check_file(char *file) {
  return access(file, F_OK);
}

int check_files() {
    if(check_file("/tmp/new_login") != -1)
        return FILE_FOUND_YES;

    if(check_file("/tmp/new_config") != -1)
        return FILE_FOUND_YES;

    if(check_file("/tmp/new_network") != -1)
        return FILE_FOUND_YES;

    return FILE_FOUND_NO;
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

  if(fchown(fildes, pwd->pw_uid, grp->gr_gid) == -1){
<<<<<<< HEAD
      log_entry(LOG_FILE, "Error setting owner");
=======
	  log_entry(LOG_FILE, "Error setting owner");
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16
  }

  close(fildes);
}
