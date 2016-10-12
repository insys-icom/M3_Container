#ifndef __DEFINES_H
#define __DEFINES_H   1

#include <arpa/inet.h>
#include <crypt.h>
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <net/if.h>
#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/klog.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/timeb.h>
#include <sys/types.h>
#include <sys/un.h>
#include <termio.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>

#define LANGUAGE_TEXTS      "/var/www/localhost/htdocs/doc"

#define LANGUAGE            "/usr/application/settings/lang"
#define HTTP_CONFIG         "/etc/thttpd.conf"
#define VISITED             "/tmp/visited"
#define TMP_FILE            "/tmp/copyfile"
#define TMP_CGI             "/tmp/config_switcher_web"
#define HTTP_OUTPUT_FILE    "/tmp/web_interface_head.html"  /* File where head and navi are temporarily stored */
#define HTML_OUTPUT_FILE    "/tmp/web_interface_output.html"
#define WELCOME_TEXT        "/var/web/welcome.txt"  /* Text with the product name */
#define TMP_UPLOADED        "/tmp/update/file"
#define TMP_IMAGE           "/tmp/update/image"
#define TMP_MD5             "/tmp/md5"
<<<<<<< HEAD
#define LOG_FILE            "/var/log/web_interface/web_interface.log"
=======
#define LOG_FILE			"/var/log/web_interface/web_interface.log"
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16

#define MAX_TEXT_LENGTH     1000
#define MAX_CONFIGS         5
#define VALUE_TYPE_INT      1
#define VALUE_TYPE_STRING   2
<<<<<<< HEAD
#define NETWORK_BUFFER      25
=======
#define NETWORK_BUFFER		25
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16

#define ishex(x)        (((x) >= '0' && (x) <= '9') || ((x) >= 'a' && (x) <= 'f') || ((x) >= 'A' && (x) <= 'F'))
#define CHMOD_755       (S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH)
#define CHMOD_644       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)
#define CHMOD_600       (S_IRUSR | S_IWUSR)

#define MENU_VISITED        0x00
#define MENU_OVERVIEW       0x01
#define MENU_NET        0x02
#define MENU_AUTH       0x03
#define MENU_CONFIG     0x04
#define MENU_INFO       0x05
#define MENU_LOG        0x06
#define MENU_NEW_CONFIG     0x07
#define MENU_RESTART        0x08
#define MENU_EMPTY      0x09

#define MODE_NONE       0x00

#define SUCCESS 0
#define FAIL    1

/* Files */
#define FILE_REBOOT         "/tmp/reboot"
#define FILE_NEW_CONFIG     "/tmp/new_config"

FILE *output;                /* stream to the output file */
char language;               /* stores the used language */
char mode;
char menu;                   /* stores what menu should be printed in navivigation */
char refresh_string[200];
char *end;                   /* pointer for strtol */
char text_line[MAX_TEXT_LENGTH + 1];
char welcome[MAX_TEXT_LENGTH + 1];

typedef struct {            /* struct for starting the right cgi */
        char *func_name;
        void *(*p_func)(void);
        unsigned char menu;
        unsigned char mode;
} func_tab;

struct envlist {        /* struct to exchange configuration using environment variables */
    char *html_post;
    char *value;
};

struct web_get_struct {
    char            *www_name;
    char            *val;
};

/* in web_main.c */
void web_main(char *cmdline);

/* in crc32.c */
unsigned long crc32file(char *, int, unsigned int);

/* in html.c */
int setenv_cgi(struct web_get_struct *get_table);
void start_box(void);
void end_box(void);
void get_lang(void);
char *get_text(char text[MAX_TEXT_LENGTH]);
void get_text_from_file(char *url);
void print_input(char *type, char *name, char *text, char *style, char *description);
void print_html_end(void);
void print_error(const char *err);
void print_option(char *text, char *value, char *selected_value);
void print_spaces(int amount);
void print_html_head(void);
void print_navigation(char menu);
void print_to_browser(void);
void visited(char *script);
void get_welcome(void);

/* in uncgi.c */
void uncgi(void);

/* in helpers.c */
void log_entry(char *logfile, char *text, ...);
int cp(char *source, char *destination, mode_t mode);
int is_sms_number(char *number);
void quot_escape(char *string);
int check_port(char *port);
int check_ip(const char *ip);
int check_string_empty(const char *str);
int check_forbidden_characters(const char *str, const char *forbidden);
void reboot();
void getGateway(char *gw, int buff_size);
void getDNS(char *dns, int buff_size);

/* overview page */
void *web_s_overview(void);

/* network settings */
void *web_s_network(void);
void *web_c_network(void);

/* authentication settings */
void *web_s_authentication(void);
void *web_c_authentication(void);

/* application-configuration */
void *web_s_configuration(void);
void *web_c_configuration(void);

/* system */
void *web_s_info(void);
void *web_s_log(void);

/* new configuration file */
void *web_c_new_config(void);

/* reset */
void *web_s_restart(void);
void *web_c_restart_app(void);
void *web_c_restart_device(void);

#endif
