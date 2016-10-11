#ifndef APP_HANDLER_H
#define APP_HANDLER_H

#define CONFIG_FILE 	"/etc/app_handler.conf"

#define EVENT_SIZE  	(sizeof (struct inotify_event))
#define EVENT_BUF_LEN   (1024 * (EVENT_SIZE + 16))

#define BUFFER_SIZE	255

#endif
