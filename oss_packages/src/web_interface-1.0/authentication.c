#include "defines.h"

#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "file_operations.h"

void *web_s_authentication(void) {

    /* Read username and password from login_file */
    char line[200 + 1];
    char *username = NULL, *password = NULL;
    char *file = "/usr/application/lighttpd_login";

    FILE *login;

    visited("authentication");

    /* Check if new logindata are available */
    if(check_file("/tmp/new_login") != FILE_NOT_EXIST) {
        file = "/tmp/new_login";
    }

    login = fopen(file, "r");

    if(login != NULL) {
        if(fgets(line, 200, login) == NULL) {
            username = NULL;
            password = NULL;
        } else {
            /* Split line for username and password */
            username = strtok(line, ":");
            password = strtok(NULL, ":");

            /* If something is wrong with this file, don´t show username and password */
            if(strtok(NULL, ":") != NULL) {
                username = NULL;
                password = NULL;
            }
        }

        fclose(login);
    }

    /* Print out page */
    fprintf(output, "<form action=\"web_c_authentication.cgi\" method=post>\n");

    /* Network */
    start_box();
    fprintf(output, "<h1>%s</h1>", get_text("AUTHENTICATION"));
    end_box();

    start_box();
    /* Username */
    fprintf(output, "<table><tr><td>%s</td><td>", get_text("USERNAME"));
    print_input("text", "Username", username, "float: right; margin-right: 500px;", "");
    fprintf(output, "</td></tr>");

    /* Password */
    fprintf(output, "<tr><td>%s</td><td>", get_text("USER_PASSWORD"));
    print_input("password", "Password", password, "float: right; margin-right: 500px;", "");
    fprintf(output, "</td></tr></table>");
    end_box();

    /* Submit */
    start_box();
    print_input("submit", "btnSubAuthentication", "OK", "margin-right:10px;", get_text("SAVE_TEXT"));
    end_box();

    fprintf(output, "</form>\n");

    return NULL;
}

void *web_c_authentication(void) {

    FILE *login;
    char *usr = NULL, *pw = NULL, *forbidden = ".,;:";

    usr = getenv("WWW_Username");
    pw = getenv("WWW_Password");

    /* Check data */
    if(usr == NULL || check_string_empty(usr) == FAIL || pw == NULL || check_string_empty(pw) == FAIL){
        /* Get back */
        perror("Error getting username");
        web_s_authentication();
        return NULL;
    }

    /* Check forbidden characters */
    if(check_forbidden_characters(usr, forbidden) == FAIL || check_forbidden_characters(pw, forbidden) == FAIL) {
        /* Get back */
        perror("Forbidden characters in username or password");
        web_s_authentication();
        return NULL;
    }

    /* Change login data */
    login = fopen("/tmp/new_login", "w+");
    if(login == NULL) {
        /* Get back */
        perror("Error opening loginfile");
        web_s_authentication();
        return NULL;
    }

    fprintf(login, "%s:%s\n", usr, pw);
    fclose(login);

    sleep(1);

    web_s_authentication();

    return NULL;
}
