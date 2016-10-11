#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/inotify.h>
#include <sys/reboot.h>
#include <unistd.h>

#include "app_handler.h"
#include "file_operations.h"
#include "networking.h"
#include "read_config.h"

char appname[BUFFER_SIZE];

/* kill process by its name */
void kill_process(char *name){
  char command[200] = "kill -9 $(pidof ";

  strcat(command, name);
  strcat(command, ")");

  system(command);
}

/* restart the application on the container */
void restart_app() {
  /* killing the application is enough because it is automatically restarted by finit */
  if(NULL != appname)
    kill_process(appname);
}

void handle_config() {
  if(check_file("/tmp/new_config") != FILE_NOT_EXIST) {
    /* Move new config data */
    move_file("/tmp/new_config", "/usr/application/configuration.config");
    change_owner("/usr/application/configuration.config", "user", "users");

    /* Restart application */
    restart_app();
  }
}

void handle_login() {
  if(check_file("/tmp/new_login") != FILE_NOT_EXIST) {
    /* Move new login data */
    move_file("/tmp/new_login", "/usr/application/lighttpd_login");
    change_owner("/usr/application/lighttpd_login", "www-data", "www-data");
  }
}

void handle_network_settings() {
  char line[100], dns[100], gw[100], route[100] = "ip route add default via ";
  FILE *net;

  if(check_file("/tmp/new_network") != FILE_NOT_EXIST) {
    net = fopen("/tmp/new_network", "r");
    if(net != NULL) {

      /* Gateway */
      fgets(line, 100, net);
      strtok(line, " ");
      strcpy(gw, line);

      /* Nameserver */
      fgets(line, 100, net);
      strtok(line, "");
      strcpy(dns, line);

      /* Write data to files */
      setGateway(gw);
      setDNS(dns);


      /* Make changes active */
      system("ip route delete default");	// Delete current default route
      strcat(route, gw);
      system(route);			// Set new default route

      /* Close and delete file */
      fclose(net);
    }
    remove("/tmp/new_network");
  }
}

void handle_event(int length, char buffer[]) {
  int i = 0;
  struct inotify_event *event;

  /*actually read return the list of change events happens. Here, read the change event one by one and process it accordingly.*/
  while (i < length) {

    event = (struct inotify_event *) &buffer[i];

    if (event->len) {

      /* if it is a file */
      if (!(event->mask & IN_ISDIR)) {

	/* reboot */
	if(strcmp(event->name, "reboot") == 0) {
	  /* wait a second before reboot, so the wait-page can be shown */
	  sleep(1);
	  reboot(RB_AUTOBOOT);
	}

	/* restart application */
	if(strcmp(event->name, "restart_app") == 0) {
	  restart_app();
	  /* delete temporary file */
	  remove("/tmp/restart_app");
	}

	/* activate_config */
	if(strcmp(event->name, "activate_config") == 0) {
	  /* Check for new config */
	  handle_config();

	  /* Check for new login data */
	  handle_login();

	  /* Check for new network data */
	  handle_network_settings();

	  remove("/tmp/activate_config");
	}
      }
    }
    i += EVENT_SIZE + event->len;
  }
}

int main(void) {
  int length;
  int fd;
  int wd;
  char buffer[EVENT_BUF_LEN];

  /* get app name from config file */
  if(getStringFromFile_n(CONFIG_FILE, "app_name", appname, BUFFER_SIZE) == -1 || appname == NULL) {
      perror("Error getting name of application");
      return EXIT_FAILURE;
  }

  /*creating the INOTIFY instance*/
  fd = inotify_init();

  /*checking for error*/
  if (fd == -1) {
    perror("inotify_init");
    return EXIT_FAILURE;
  }

  /*adding the “/tmp” directory into watch list. Here, the suggestion is to validate the existence of the directory before adding into monitoring list.*/
  wd = inotify_add_watch(fd, "/tmp", IN_CREATE);

  if(wd == -1) {
      perror("Error adding watch");
      return EXIT_FAILURE;
  }

  while(1) {
    /*read to determine the event change happens on “/tmp” directory. Actually this read blocks until the change event occurs*/
    length = read(fd, buffer, EVENT_BUF_LEN);

    /*checking for error*/
    if (length < 0 ) {
	  perror("Error reading events");
	  continue;
    }

    /* handle event */
    handle_event(length, buffer);
  }

  /*removing the “/tmp” directory from the watch list.*/
  if(inotify_rm_watch(fd, wd) == -1) {
      perror("Error removing watch");
      return EXIT_FAILURE;
  }

  /*closing the INOTIFY instance*/
  if(close(fd) == -1) {
      perror("Error closing file descriptor");
      return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
