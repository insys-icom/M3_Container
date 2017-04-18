#include "m3_cli.h"

#include <libmcip.h>
#include <unistd.h>
#include <stdbool.h>
#include <errno.h>
#include <string.h>

/* free wrapper function to avoid dangling pointers */
void safefree(void **pp)
{
    if (pp != NULL) {
        free(*pp);
        *pp = NULL;
    }
    return;
}

/* generic read from the cli socket
    fd          is needed
    answer      if given, the answer is written into the buffer (careful, allocated)
    prompt      if given, the reading of the answer stops on receipt of the prompt (and the prompt is trimmed from the ansawer)
    waittime_ms maximum amount of time (in milliseconds) to wait for an answer (use 0 to simply read and discard present data on the socket) */
bool m3_cli_read_socket(int fd, char **answer, char *prompt, int waittime_ms)
{
    char buffer[100];
    fd_set read_fds;
    struct timeval tv;
    int ret, read_bytes, current_size = 0;
    char *cli_reply = NULL, *p;

    for (;;) {
        FD_ZERO(&read_fds);
        FD_SET(fd, &read_fds);
        /* use the correct waittime */
        if (waittime_ms) {
            tv.tv_sec = waittime_ms / 1000;
            tv.tv_usec = waittime_ms * 1000;
        }
        else {
          tv.tv_sec = 0;
          tv.tv_usec = 0;
        }
        ret = select(fd + 1, &read_fds, NULL, NULL, &tv);
        /* on timeout always return */
        if (ret == 0) {
            break;
        }
        if (ret == -1) {
            safefree((void **) &cli_reply);
            return false;
        }
        /* the socket is ready */
        if (FD_ISSET(fd, &read_fds)) {
            read_bytes = read(fd, buffer, 100);
            /* if there are no bytes any more (EOF) return */
            if (read_bytes == 0) {
                break;
            }
            if (read_bytes == -1) {
                safefree((void **) &cli_reply);
                return false;
            }

            /* append to the internal reply */
            cli_reply = realloc(cli_reply, current_size + read_bytes + 1);
            memcpy(cli_reply + current_size, buffer, read_bytes);
            current_size += read_bytes;
            cli_reply[current_size] = '\0';

            /* detect a prompt (if given) */
            if (prompt != NULL) {
                p = strstr(cli_reply, prompt);
                if (p != NULL) {
                    *p = '\0';
                    break;
                }
            }
        }
    }

    /* if the answer is queried, sotre it in the given buffer */
    if (answer != NULL) {
        *answer = calloc(1, current_size + 1);
        memcpy(*answer, cli_reply, current_size);
    }

    safefree((void **) &cli_reply);

    return true;
}

/* close the socket */
void m3_cli_close(struct s_m3_cli *cli)
{
    if (cli->fd != -1) {
        close(cli->fd);
    }
    return;
}

/* read the cli prompt */
bool m3_cli_read_prompt(struct s_m3_cli *cli)
{
    if (cli->fd == -1) {
        errno = EBADF;
        return false;
    }

    /* discard all data on the socket */
    if (!m3_cli_read_socket(cli->fd, NULL, NULL, cli->waittime_ms) ||
        write(cli->fd, "\n", 1) != 1 ||
        !m3_cli_read_socket(cli->fd, &(cli->prompt), NULL, cli->waittime_ms)) {
            m3_cli_close(cli);
            errno = EIO;
            return false;
    }

    return true;
}

/* open UDS connection and read prompt */
bool m3_cli_open(struct s_m3_cli *cli)
{
	struct sockaddr_un address;
	
    /* open UDS connection */
    cli->fd = socket(PF_LOCAL, SOCK_STREAM, 0);
    //cli->fd = mcip_open_uds_socket(cli->socket_path);
    if (cli->fd < 0) {
        return false;
    }
    
    address.sun_family = AF_LOCAL;
	strcpy(address.sun_path, cli->socket_path);
    
    if(connect (cli->fd, (struct sockaddr *) &address, sizeof(address)) != 0) {
		return false;
	}
	
    /* read prompt */
    return m3_cli_read_prompt(cli);
}

/* function that send a command to the socket and retrieves the answer */
bool m3_cli_command(struct s_m3_cli *cli, char *command, char **answer, int waittime_ms)
{
    /* if the socket is down, open it (and read prompt) */
    if (cli->fd == -1) {
        if (!m3_cli_open(cli)) {
            errno = EIO;
            return false;
        }
    }
    /* clear the socket from not fetched data, send command, send \n and get the answer */
    if (!m3_cli_read_socket(cli->fd, NULL, NULL, 0) ||
        write(cli->fd, command, strlen(command)) != strlen(command) ||
        write(cli->fd, "\n", 1) != 1 ||
        !m3_cli_read_socket(cli->fd, answer, cli->prompt, waittime_ms)) {
            m3_cli_close(cli);
            errno = EIO;
            return false;
    }

    return true;
}

/* warpper to send a command to the cli without caring about the answer */
bool m3_cli_send(struct s_m3_cli *cli, char *command)
{
    /* discard data on the socket */
    if (cli == NULL || command == NULL) {
        errno = EINVAL;
        return false;
    }

    return m3_cli_command(cli, command, NULL, cli->waittime_ms);
}

/* wrapper to send a command to the cli but read back the answer */
bool m3_cli_query(struct s_m3_cli *cli, char *command, char **answer, int waittime_ms)
{
    /* discard data on the socket */
    if (cli == NULL || command == NULL || answer == NULL) {
        errno = EINVAL;
        return false;
    }

    if (waittime_ms == 0) {
        waittime_ms = cli->waittime_ms;
    }

    return m3_cli_command(cli, command, answer, waittime_ms);
}

/* close cli socket and free the struct */
void m3_cli_shutdown(struct s_m3_cli **cli)
{
    if ( cli == NULL || (*cli) == NULL) {
        return;
    }
    m3_cli_close(*cli);
    safefree((void **)&((*cli)->socket_path));
    safefree((void **)&((*cli)->prompt));
    safefree((void **)cli);
    return;
}

/* open the cli socket and get the prompt
    returns a struct containing all cli information
    on error, NULL is returned and errno set appropriately */
struct s_m3_cli *m3_cli_initialise(const char *socket_path, int default_waittime_ms)
{
    struct s_m3_cli *cli;

    if (socket_path == NULL || default_waittime_ms == 0) {
        errno = EINVAL;
        return NULL;
    }

    if (access(socket_path, F_OK)) {
        errno = ENODEV;
        return NULL;
    }

    cli = calloc(1, sizeof(struct s_m3_cli));
    cli->fd = -1;
    cli->waittime_ms = default_waittime_ms;
    cli->socket_path = calloc(1, strlen(socket_path) + 1);
    strcpy(cli->socket_path, socket_path);

    if (!m3_cli_open(cli)) {
        m3_cli_shutdown(&cli);
        errno = EIO;
        return NULL;
    }

    return cli;
}


