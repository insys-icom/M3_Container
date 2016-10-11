#include "defines.h"
#include "settings_defines.h"
#include "file_operations.h"

/* this function stuffs the variables into the environment */
int setenv_cgi(struct web_get_struct *get_table)
{
    int i;

    for(i = 0; get_table[i].www_name != NULL; i++) {
        sprintf(text_line, "WWW_%s_old", get_table[i].www_name);
        if(setenv(text_line, get_table[i].val, 1) < 0)
            return 1;
    }
    return 0;
}

/* Print the html for the beginning of a grey box */
void start_box()
{
    fprintf(output, "<div class=\"box\">\n");
}

/* Print the html for the end of a grey box */
void end_box()
{
    fprintf(output, "</div>\n");
}

/* Gets the used language and whether help is required */
void get_lang(void)
{
    FILE *tmp;
    tmp = fopen(LANGUAGE, "r");
    if(tmp == NULL)
        language = 'd';
    else {
        language = fgetc(tmp);
        fclose(tmp);
    }
    return;
}

/* Get a text from the external textfile */
char *get_text(char text[MAX_TEXT_LENGTH])
{
    int cmp, i, n;
    long left, right, x;
    char *p, buffer[MAX_TEXT_LENGTH], textfile_path[50] = {LANGUAGE_TEXTS"/"};
    FILE *textfile;

    strncat(textfile_path, &language, 1);
    textfile = fopen(textfile_path, "r");
    if(textfile == NULL)
        return "\0";

    left = ftell(textfile);
    if(fseek(textfile, 0, SEEK_END))
        return "\0";
    right = ftell(textfile);

    for(; right >= left;) {
        x = (left + right ) / 2;
        fseek(textfile, x, SEEK_SET);
        for(; fgetc(textfile) != '\n';) {
             if(fseek(textfile, -2, SEEK_CUR) == -1) {
                 fseek(textfile, -1, SEEK_CUR);
                 break;
             }
        }
        if(feof(textfile))
            break;
        fgets(buffer, MAX_TEXT_LENGTH, textfile);
        p = index(buffer, '=');
        *p = '\0';
        cmp = strcmp(text, buffer);

        if(cmp == 0) {
            i = p - buffer;
            for(i++, n = 0; i != (MAX_TEXT_LENGTH) && buffer[i] != '\0' && buffer[i] != '\n'  ; i++, n++)
                text_line[n] = buffer[i];
            text_line[n] = ' ';
            text_line[n + 1] = '\0';
            fclose(textfile);
            return (char*) text_line;
        }
        else if(cmp < 0)
            right = x - 1;
        else
            left = x + 1;
    }
    fclose(textfile);
    return "(null)";
}

void get_text_from_file(char *filename) {
    FILE * data;
    char buff[MAX_TEXT_LENGTH];
    char textfile_path[100] = {LANGUAGE_TEXTS"/"};

    strncat(textfile_path, &language, 1);
    strncat(textfile_path, "_", 1);
    strcat(textfile_path, filename);

    data = fopen(textfile_path, "r");

    if(data == NULL) {
         fprintf(output,"No text available..");
    }
    else {
        while(fgets(buff, MAX_TEXT_LENGTH, data)) {
             fprintf(output,"%s<br>", buff);
        }

        fclose(data);
    }
}

void print_input(char *type, char *name, char *text, char *style, char *description) {
    fprintf(output, "<input type=\"%s\" name=\"%s\" value=\"%s\" style=\"%s\">%s\n", type, name, text, style, description);
}

void print_option(char *text, char *value, char *selected_value) {
    fprintf(output, "<option ");

    if(strncmp(value, selected_value, 1) == 0) {
        fprintf(output, "selected=\"selected\" ");
    }

    fprintf(output, "value=\"%s\">%s</option>\n", value, text); 
}

/* Print a HTML-End */
void print_html_end(void) {
    if(menu != MENU_EMPTY)
        fprintf(output, "\n</div></div>\n");
    fprintf(output, "</body></html>\n");
    return;
}

/* Print a Error-Message */
void print_error(const char *err)
{
    start_box();
    fprintf(output, "<br><h2>%s</h2>\n", err);
    end_box();
    return;
}

/* Print HTML spaces */
void print_spaces(int amount)
{
    int i;
    for(i = 0; i < amount; i++)
        fprintf(output, "&nbsp;");
    return;
}

/* Print a HTML-Head */
void print_html_head(void)
{
    fprintf(output, "\n<html><head><title>%s</title>\n", get_text("HTML_TITLE"));
    fprintf(output, "<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">");
    fprintf(output, "<meta http-equiv=\"expires\" content=\"0\">\n");
    fprintf(output, "<meta http-equiv=\"cache-control\" content=\"no-cache\">\n");
    fprintf(output, "<meta http-equiv=\"pragma\" content=\"no-cache\">\n");
    //if(refresh_string[0] != '\0')
    //    fprintf(output, "<meta http-equiv=\"refresh\" content=\"%s\">\n", refresh_string);
    fprintf(output, "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">\n");
    fprintf(output, "<link rel=\"stylesheet\" type=\"text/css\" href=\"style_fw.css\">\n");
    fprintf(output, "<link rel=\"icon\" type=\"image/png\" href=\"icons/favicon.png\">");

    fprintf(output, "</head><body>\n");

    if(menu == MENU_EMPTY)
        return;

    fprintf(output, "<div class=\"sheet\"><div class=\"head\">\n");
    fprintf(output, "<img src=\"icons/top_bar.jpg\" alt=\"\">");

    /* Home link is actually the company logo */
    fprintf(output, "<div id=\"button_home\"><a href=\"web_s_overview.cgi\" target=\"_parent\" ");
    fprintf(output, "title=\"Home\"></a></div>\n");

    /* If multilanguage is activated show flags to change language */
    if(LANGUAGE_SWITCH_ON) {
        fprintf(output, "<div id=\"button_de\"><a href=\"web_c_lang_de.cgi\" target=\"_parent\">\n");
        fprintf(output, "<img src=\"icons/de.png\" border=\"0\" ");
        //fprintf(output, "alt=\"deutsch\">&nbsp;%s</a></div>\n", get_text("GERMAN"));
        fprintf(output, "alt=\"deutsch\">%s</a></div>\n", "");

        fprintf(output, "<div id=\"button_gb\"><a href=\"web_c_lang_en.cgi\" target=\"_parent\">\n");
        fprintf(output, "<img src=\"icons/gb.png\" border=\"0\" ");
        //fprintf(output, "alt=\"english\">&nbsp;%s</a></div>\n", get_text("ENGLISH"));
        fprintf(output, "alt=\"english\">%s</a></div>\n","");
    }

    /* If a new config file was found in /tmp show gear-wheel */
    if(check_files() == FILE_FOUND_YES) {
        fprintf(output, "<div id=\"profile\">\n");
        fprintf(output, "<a href=\"web_c_new_config.cgi\" title=\"%s\">\n", get_text("ACTIVATE_SETTINGS"));
        fprintf(output, "<img src=\"icons/gear_wheel.gif\" style=\"margin-top: -4px; vertical-align: middle; border: 0px\" alt=\"%s\" height=\"20px\"></img>\n&nbsp;%s\n", get_text("ACTIVATE_SETTINGS"), get_text("ACTIVATE_SETTINGS"));
        fprintf(output, "</a>\n");
        fprintf(output, "</div>\n");
    }

    fprintf(output, "</div>\n\n");
    return;
}

/* Store the last visited page (store its script name */
void visited(char *script)
{
    FILE *tmp;

    tmp = fopen(VISITED, "w+");
    fputs(script, tmp);
    fputc('\n', tmp);
    fclose(tmp);
    return;
}

/* Paint the HTML for the tree frame */
void print_navigation(char menu)
{
    if(menu == MENU_EMPTY)
        return;

    fprintf(output, "<div class=\"navi\">");

    if(menu == MENU_OVERVIEW) {
        fprintf(output, "<div class=\"menuactive\">\n");
        fprintf(output, "<a href=\"web_s_overview.cgi\" target=\"_parent\">\n");
        print_spaces(2);
        fprintf(output, "%s</a></div>\n", get_text("OVERVIEW"));

        fprintf(output, "<div class=\"submenuactive\">\n");
        fprintf(output, "<a href=\"web_s_overview.cgi\" target=\"_parent\">\n");
        print_spaces(3);
        fprintf(output, "%s</a></div>\n", get_text("OVERVIEW"));
    }
    else {
        fprintf(output, "<div class=\"menu\">\n");
        fprintf(output, "<a href=\"web_s_overview.cgi\" target=\"_parent\">\n");
        print_spaces(2);
        fprintf(output, "%s</a></div>\n", get_text("OVERVIEW"));
    }

    if(menu == MENU_CONFIG) {
        fprintf(output, "<div class=\"menuactive\">\n");
        fprintf(output, "<a href=\"web_s_configuration.cgi\" target=\"_parent\">\n");
        print_spaces(2);
        fprintf(output, "%s</a></div>\n", get_text("APPLICATION"));

        fprintf(output, "<div class=\"submenuactive\">\n");
        fprintf(output, "<a href=\"web_s_configuration.cgi\" target=\"_parent\">\n");
        print_spaces(3);
        fprintf(output, "%s</a></div>\n", get_text("CONFIGURATION"));
    }
    else {
        fprintf(output, "<div class=\"menu\">\n");
        fprintf(output, "<a href=\"web_s_configuration.cgi\" target=\"_parent\">\n");
        print_spaces(2);
        fprintf(output, "%s</a></div>\n", get_text("APPLICATION"));
    }

    if(menu == MENU_INFO || menu == MENU_LOG || menu == MENU_NET || menu == MENU_AUTH || menu == MENU_RESTART) {
        fprintf(output, "<div class=\"menuactive\">\n");
        fprintf(output, "<a href=\"web_s_info.cgi\" target=\"_parent\">\n");
        print_spaces(2);
        fprintf(output, "%s</a></div>\n", get_text("ADMINISTRATION"));

        if(menu == MENU_INFO) {
            fprintf(output, "<div class=\"submenuactive\">\n");
            fprintf(output, "<a href=\"web_s_info.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", "Info");
        }
        else {
            fprintf(output, "<div class=\"submenu\">\n");
            fprintf(output, "<a href=\"web_s_info.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", "Info");
        }

        if(menu == MENU_NET) {
            fprintf(output, "<div class=\"submenuactive\">\n");
            fprintf(output, "<a href=\"web_s_network.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", get_text("IP_NETWORK"));
        }
        else {
            fprintf(output, "<div class=\"submenu\">\n");
            fprintf(output, "<a href=\"web_s_network.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", get_text("IP_NETWORK"));
        }

        if(menu == MENU_AUTH) {
            fprintf(output, "<div class=\"submenuactive\">\n");
            fprintf(output, "<a href=\"web_s_authentication.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", get_text("AUTHENTICATION"));
        }
        else {
            fprintf(output, "<div class=\"submenu\">\n");
            fprintf(output, "<a href=\"web_s_authentication.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", get_text("AUTHENTICATION"));
        }

        if(menu == MENU_LOG) {
            fprintf(output, "<div class=\"submenuactive\">\n");
            fprintf(output, "<a href=\"web_s_log.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", "Logging");
        }
        else {
            fprintf(output, "<div class=\"submenu\">\n");
            fprintf(output, "<a href=\"web_s_log.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", "Logging" );
        }

        if(menu == MENU_RESTART) {
            fprintf(output, "<div class=\"submenuactive\">\n");
            fprintf(output, "<a href=\"web_s_restart.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", get_text("RESTART"));
        }
        else {
            fprintf(output, "<div class=\"submenu\">\n");
            fprintf(output, "<a href=\"web_s_restart.cgi\" target=\"_parent\">\n");
            print_spaces(3);
            fprintf(output, "%s</a></div>\n", get_text("RESTART"));
        }
    }
    else {
        fprintf(output, "<div class=\"menu\">\n");
        fprintf(output, "<a href=\"web_s_info.cgi\" target=\"_parent\">\n");
        print_spaces(2);
        fprintf(output, "%s</a></div>\n", get_text("ADMINISTRATION"));
    }

    fprintf(output, "</div><div class=\"main\">");
    return;
}

/* Write temporary html-file to browser */
void print_to_browser(void)
{
    unsigned int size_head, size_html;
    int i;
    char c;
    struct stat st;

    if(stat(HTML_OUTPUT_FILE, &st))
        return;

    size_html = (int)st.st_size;

    if(stat(HTTP_OUTPUT_FILE, &st))
        return;
    size_head = (int)st.st_size;

    printf("cache-control: no-cache\n");
    printf("content-type: text/html; charset=UTF-8\n");
    printf("content-length: %d\r\n\r\n", size_html + size_head);

    output = fopen(HTTP_OUTPUT_FILE, "r");
    if(output == NULL)
        return;
    for(i = 0; i < size_head; i++) {
        c = fgetc(output);
        printf("%c", c);
    }
    fclose(output);

    output = fopen(HTML_OUTPUT_FILE, "r");
    if(output == NULL)
        return;
    for(i = 0; i < size_html; i++) {
        c = fgetc(output);
        printf("%c", c);
    }
    fclose(output);

    unlink(HTML_OUTPUT_FILE);
    unlink(HTTP_OUTPUT_FILE);

    return;
}

/* get strings for the device name (welcome) and the location for printing the HTML title */
void get_welcome(void)
{
    FILE *tmp;

    welcome[0] = '\0';
    tmp = fopen(WELCOME_TEXT, "r");
    if(tmp != NULL) {
        fgets(welcome, MAX_TEXT_LENGTH, tmp);
        fclose(tmp);
    }
    return;
}
