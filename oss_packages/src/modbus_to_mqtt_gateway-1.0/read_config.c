#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "logging.h"
#include "main.h"

/* Get string from configurationfile (without "\n" at the end of the line!) */
int getStringFromFile_n(char *file, char *name, char buffer[], int size_buffer)
{
    FILE *ptr_file;
    char temp_buf[size_buffer];

    /* Open file */
    ptr_file =fopen(file,"r");

    /* Check file */
    if (!ptr_file)
    {
        log_entry(APP_NAME, "Error: Configuration-File not found");
        printf("Error: Configuration-File not found!\n");
        return -1;
    }

    /* Read file line by line*/
    while (fgets(temp_buf, size_buffer, ptr_file)!=NULL)
    {
        /* If it is no comment, it has the correct format (key=value) and the right name, read the value */
        if(temp_buf[0] != '#' && strchr(temp_buf, '=') != NULL && strstr(temp_buf, name))
        {
            sprintf(temp_buf, "%s", strtok(temp_buf, "="));
            sprintf(temp_buf, "%s", strtok(NULL, "="));
            break;
        }
    }

    /* close file */
    fclose(ptr_file);

    sprintf(buffer, strtok(temp_buf, "\n"));

    return 0;
}

/* Get int from configurationfile using getStringFromFile-function above */
int getIntFromFile(char *file, char *name)
{
    int val = 0;

    /* Get value as string */
    char value_string[BUFFER_SIZE];

    if(getStringFromFile_n(file, name, value_string, BUFFER_SIZE) == -1 || value_string == NULL)
        return -1;

    /* Convert string to int and return */
    val = strtol(value_string, NULL, 10);

    return val;
}
