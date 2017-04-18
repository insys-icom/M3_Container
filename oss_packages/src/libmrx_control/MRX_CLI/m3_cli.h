#pragma once

#include <stdbool.h>

struct s_m3_cli {
    char *socket_path;          /* socket path (gets allocated and copied on initialisation) */
    int fd;                     /* file descriptor */
    char *prompt;               /* prompt that got read */
    int waittime_ms;            /* default waittime for send commands to retrieve the new prompt */
};

/* send a command to the cli without caring about the answer
    if the socket is not open, it will be initialised
    if the send or read fails, the socket will be closed, so it can be opened by the next call
    on error, false is returned and errno set approriately */
bool m3_cli_send(struct s_m3_cli *cli, char *command);

/* send a command to the cli and retrieve the answer
    if the socket is not open, it will be initialised
    if the send or read fails, the socket will be closed, so it can be opened by the next call
    on error, false is returned and errno set approriately */
bool m3_cli_query(struct s_m3_cli *cli, char *command, char **answer, int waittime_ms);

/* initialises a cli struct container socket, fd and prompt
    this struct is used to automatically reopen a broken socket in the query or send functions
    open the cli socket and get the prompt
    returns a struct containing all cli information
    on error, NULL is returned and errno set appropriately */
struct s_m3_cli *m3_cli_initialise(const char *socket_path, int default_waittime_ms);

/* close the socket and free the struct */
void m3_cli_shutdown(struct s_m3_cli **cli);
