#include <stdio.h>
#include <time.h>
#include <stdarg.h>
#include <syslog.h>

#define MAX_LOG_ENTRY_LENGTH       500

/* print a log entry into the log file */
void log_entry(const char *app_name, const char *text, ...)
{
    char buffer[MAX_LOG_ENTRY_LENGTH + 1];
    va_list argpointer;

    if (app_name == NULL) {
        return;
    }

    va_start(argpointer, text);
    vsnprintf(buffer, MAX_LOG_ENTRY_LENGTH, text, argpointer);
    va_end(argpointer);
    openlog(app_name, LOG_PID | LOG_NDELAY, LOG_DAEMON);
    syslog(LOG_INFO, "%s", buffer);
    closelog();

    return;
}
