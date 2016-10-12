#include "defines.h"

#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "file_operations.h"

void *web_s_authentication(void) {

<<<<<<< HEAD
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
            username = NULL,
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
    fprintf(output, "%s", get_text("USERNAME"));
    print_input("text", "Username", username, "float: right; margin-right: 500px;", "");
    fprintf(output, "<br><br>");

    /* Password */
    fprintf(output, "%s", get_text("USER_PASSWORD"));
    print_input("password", "Password", password, "float: right; margin-right: 500px;", "");

    end_box();

    /* Submit */
    start_box();
    print_input("submit", "btnSubAuthentication", "OK", "margin-right:10px;", get_text("SAVE_TEXT"));
    end_box();

    fprintf(output, "</form>\n");

    return NULL;
=======
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
			username = NULL,
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
	fprintf(output, "%s", get_text("USERNAME"));
	print_input("text", "Username", username, "float: right; margin-right: 500px;", "");
	fprintf(output, "<br><br>");

	/* Password */
	fprintf(output, "%s", get_text("USER_PASSWORD"));
	print_input("password", "Password", password, "float: right; margin-right: 500px;", "");

	end_box();

	/* Submit */
	start_box();
	print_input("submit", "btnSubAuthentication", "OK", "margin-right:10px;", get_text("SAVE_TEXT"));
	end_box();

	fprintf(output, "</form>\n");

	return NULL;
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16
}

void *web_c_authentication(void) {

<<<<<<< HEAD
    FILE *login;
    char *usr = NULL, *pw = NULL, *forbidden = ".,;:";

    usr = getenv("WWW_Username");
    pw = getenv("WWW_Password");

    /* Check data */
    if(usr == NULL || check_string_empty(usr) == FAIL || pw == NULL || check_string_empty(pw) == FAIL){
        /* Get back */
        log_entry(LOG_FILE, "Error getting username");
        web_s_authentication();
        return NULL;
    } 

    /* Check forbidden characters */
    if(check_forbidden_characters(usr, forbidden) == FAIL || check_forbidden_characters(pw, forbidden) == FAIL) {
        /* Get back */
        log_entry(LOG_FILE, "Forbidden characters in username or password");
        web_s_authentication();
        return NULL;
    }

    /* Change login data */
    login = fopen("/tmp/new_login", "w+");
    if(login == NULL) {
        /* Get back */
        log_entry(LOG_FILE, "Error opening loginfile");
        web_s_authentication();
        return NULL;
    }

    fprintf(login, "%s:%s\n", usr, pw);
    fclose(login);

    sleep(1);

    web_s_authentication();

    return NULL;
=======
	FILE *login;
	char *usr = NULL, *pw = NULL, *forbidden = ".,;:";

	usr = getenv("WWW_Username");
	pw = getenv("WWW_Password");

	/* Check data */
	if(usr == NULL || check_string_empty(usr) == FAIL || pw == NULL || check_string_empty(pw) == FAIL){
		/* Get back */
		log_entry(LOG_FILE, "Error getting username");
		web_s_authentication();
		return NULL;
	} 

	/* Check forbidden characters */
	if(check_forbidden_characters(usr, forbidden) == FAIL || check_forbidden_characters(pw, forbidden) == FAIL) {
		/* Get back */
		log_entry(LOG_FILE, "Forbidden characters in username or password");
		web_s_authentication();
		return NULL;
	}

	/* Change login data */
	login = fopen("/tmp/new_login", "w+");
	if(login == NULL) {
		/* Get back */
		log_entry(LOG_FILE, "Error opening loginfile");
		web_s_authentication();
		return NULL;
	}

	fprintf(login, "%s:%s\n", usr, pw);
	fclose(login);

	sleep(1);

	web_s_authentication();

	return NULL;
>>>>>>> f150bc17286bde169b4dd8c8b7fb73781a2e1e16
}
