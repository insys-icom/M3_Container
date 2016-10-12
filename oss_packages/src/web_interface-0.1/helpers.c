#include "defines.h"
#include "file_operations.h"

void getGateway(char *gw, int buff_size) {
    char buf[BUF_SIZE], *tmp;
    FILE *net;

    if(check_file("/tmp/new_network") != FILE_NOT_EXIST) {
        net = fopen("/tmp/new_network", "r");

        if(NULL == net) {
            gw = "";
            return;
        }

        /* Gateway */
        if(fgets(buf, BUF_SIZE, net) != NULL) {
<<<<<<< HEAD
            strtok(buf, " ");
            strncpy(gw, buf, buff_size);
        }
=======
			strtok(buf, " ");
			strncpy(gw, buf, buff_size);
		}
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16
    } else {
        net = fopen("/bin/start_net.sh", "r");

        if(NULL == net) {
            gw = "";
            return;
        }

        while(fgets(buf, sizeof(buf), net)) {
            if(buf[0] == '\0' || buf[0] == '#')
                continue;

            if(strstr(buf, "route") && strstr(buf, "default")) {
                strtok(buf, " ");

                while((tmp = strtok(NULL, " ")) != NULL) {
                    strncpy(gw, tmp, buff_size);
                }

                break;
            }
        }

        fclose(net);
    }
    return;
}

void getDNS(char *dns, int buff_size) {
    char buf[BUF_SIZE];
    FILE *resolv;

    if(check_file("/tmp/new_network") != FILE_NOT_EXIST) {
        resolv = fopen("/tmp/new_network", "r");

        if(NULL == resolv) {
            dns = "";
            return;
        }

        /* Nameserver */
        // read first line
        if(fgets(buf, 100, resolv) == NULL) {
<<<<<<< HEAD
            log_entry(LOG_FILE, "Error reading new_network file");
            return;
        }
        
        // read second line
        if(fgets(buf, 100, resolv) == NULL) {
            log_entry(LOG_FILE, "Error reading new_network file");
            return;
        }
=======
			log_entry(LOG_FILE, "Error reading new_network file");
			return;
		}
		
        // read second line
        if(fgets(buf, 100, resolv) == NULL) {
			log_entry(LOG_FILE, "Error reading new_network file");
			return;
		}
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16
        strtok(buf, " ");
        strncpy(dns, buf, buff_size);

    } else {
        resolv = fopen("/etc/resolv.conf", "r");

        if(NULL == resolv) {
            dns = "";
            return;
        }

        while(fgets(buf, sizeof(buf), resolv)) {
            if(strstr(buf, "nameserver")) {
                strtok(buf, " ");
                strncpy(dns, strtok(NULL, " "), buff_size);
                break;
            }
        }
    }

    fclose(resolv);

    return;
}

/* print a log entry into the log file */
void log_entry(char *logfile, char *text, ...)
{
    time_t now = 0;
    struct tm *p_now_tm;
    FILE *tmp;
    char buffer[MAX_TEXT_LENGTH + 1];
    va_list argpointer;

    tmp = fopen(logfile, "a+");
    if(tmp == NULL)
        return;

    time(&now); /* get current time */
    p_now_tm = localtime(&now);
    strftime(buffer, sizeof(buffer), "%a %b %e %H:%M:%S %Z %Y", p_now_tm);
    fprintf(tmp, "%s", buffer);
    fprintf(tmp, " | ");
    va_start(argpointer, text);
    vfprintf(tmp, text, argpointer);
    va_end(argpointer);
    fprintf(tmp, "\n");
    fclose(tmp);

    return;
}

/* check if it is a valid telephone number */
int is_sms_number(char *number)
{
    int i, count = strlen(number);
    if(!isdigit(number[0]) && number[0] != '+')
        return 0;
    for(i = 1; i < count; i++) {
        if(!isdigit(number[i]))
            return 0;
    }
    return 1;
}

/**     Brief:  
*           Function for checking an ip address
*       Parameters:
*           ip          string containing the ip address
*       Return:
*           SUCCESS     only digits and 3 points
*           FAIL        else
*/
int check_ip(const char *ip) {
    int count_points = 0, i;

    if(check_string_empty(ip) != SUCCESS) 
        return FAIL;

    for(i = 0; i < strlen(ip); i++) {
        if(ip[i] == '.')
            count_points++;

        if(!isdigit(ip[i]) && ip[i] != '.') {
            return FAIL;
        }
    }

    if(count_points != 3) 
        return FAIL;

    return SUCCESS;
}

/**     Brief:  
*           Function for strings for emptyness
*       Parameters:
*           str         string to check
*       Return:
*           SUCCESS     string not empty
*           FAIL        else
*/
int check_string_empty(const char *str) {
    /* Check if empty or NULL */
    if(NULL == str || strlen(str) == 0 || str[0] == '\0') {
        return FAIL;
    } else {
        return SUCCESS;
    }
}

/**     Brief:  
*           Function for strings to check forbidden characters
*       Parameters:
*           str         string to check
*           forbidden   contains forbidden characters
*       Return:
*           SUCCESS     string contains no forbidden characters
*           FAIL        else
*/
int check_forbidden_characters(const char *str, const char *forbidden) {
    if(strpbrk(str, forbidden) != NULL) {
        return FAIL;
    } else {
        return SUCCESS;
    }
}

/* copys the lines of a text file into another and sets it to the rights */
int cp(char *source, char *destination, mode_t mode)
{
    FILE *src, *dst;
    char line[MAX_TEXT_LENGTH + 1];
    int input_char;

    src = fopen(source, "r");
    if(src == NULL)
        return 1;

    unlink(destination);
    dst = fopen(destination, "w+");
    if(dst == NULL) {
        fclose(src);
        return 1;
    }

    if(fgets(line, MAX_TEXT_LENGTH, src)) {
        input_char = (int) line;
        for(; input_char != EOF; ) {
            fputs(line, dst);
            if(!fgets(line, MAX_TEXT_LENGTH, src))
                break;
            input_char = (int) &line[strlen(line) - 1];
        }
    }
    fclose(src);
    fclose(dst);
    chmod(destination, mode);

    return 0;
}

/* prints the string to "output" but replaces " with &quot; */
void quot_escape(char *string)
{
    int i;
    for(i = 0; i < strlen(string); i++) {
        if(string[i] == '"')
            fputs("&quot;", output);
        else
            fputc(string[i], output);
    }
    return;
}

/* checks wheater given string is a valid port number */
int check_port(char *port)
{
    int i;
    if(port == NULL)
        return 1;
    if(strlen(port) == 0)
        return 1;
    if(port[0] == '\0' || strtol(port, &end, 10) > 65535 || strtol(port, &end, 10) < 1 || end == port)
        return 1;
    for(i = 0; i < strlen(port); i++) {
        if(port[i] < 0x30 || port[i] > 0x39)
            return 1;
     }
    return 0;
}
