#include "defines.h"

/* Convert two hex digits to a value. */
static int htoi(s) unsigned char *s;
{
    int value;
    char    c;

    c = s[0];
    if(isupper(c))
        c = tolower(c);
    value = (c >= '0' && c <= '9' ? c - '0' : c - 'a' + 10) * 16;

    c = s[1];
    if(isupper(c))
        c = tolower(c);
    value += c >= '0' && c <= '9' ? c - '0' : c - 'a' + 10;

    return (value);
}

/* Get rid of all the URL escaping in a string. */
static void url_unescape(str) unsigned char *str;
{
    unsigned char *dest = str;

    while (str[0]) {
        if(str[0] == '+')
            dest[0] = ' ';
        else if(str[0] == '%' && ishex(str[1]) && ishex(str[2])) {
            dest[0] = (unsigned char) htoi(str + 1);
            str += 2;
        }
        else
            dest[0] = str[0];

        str++;
        dest++;
    }

    dest[0] = '\0';
}

/* Stuff a URL-unescaped variable, with the prefix on its name, into environment */
static void stuffenv(var) char *var;
{
    char *buf, *c, *s, *t, *oldval, *newval;
    int despace = 0, got_cr = 0;

    url_unescape((unsigned char *)var);

    /* Allocate enough memory for the variable name and its value. */
    buf = malloc(strlen(var) + 7);

    strcpy(buf, "WWW_");
    if (var[0] == '_') {
        strcpy(buf + 4, var + 1);
        despace = 1;
    }
    else
        strcpy(buf + 4, var);

    /* If, for some reason, there wasn't an = in the query string,
     * add one so the environment will be valid.
     *
     * Also, change periods to underscores so folks can get at "image"
     * input fields from the shell, which has trouble with periods
     * in variable names. */
    for (c = buf; *c != '\0'; c++) {
        if (*c == '.')
            *c = '_';
        if (*c == '=')
            break;
    }
    if (*c == '\0')
        c[1] = '\0';
    *c = '\0';

    /* Do whitespace stripping, if applicable. Since this can only ever
     * shorten the value, it's safe to do in place. */
    if(despace && c[1]) {
        for(s = c + 1; *s && isspace(*s); s++) ;
        t = c + 1;
        while(*s) {
            if (*s == '\r') {
                got_cr = 1;
                s++;
                continue;
            }
            if (got_cr) {
                if (*s != '\n')
                    *t++ = '\n';
                got_cr = 0;
            }
            *t++ = *s++;
        }

        /* Strip trailing whitespace if we copied anything. */
        while(t > c && isspace(*--t)) ;
        t[1] = '\0';
    }

    /* Check for the presence of the variable. */
    if((oldval = getenv(buf))) {
        newval = malloc(strlen(oldval) + strlen(buf) + strlen(c+1) + 3);

        *c = '=';
        sprintf(newval, "%s#%s", buf, oldval);
        *c = '\0';

        /* Set up to free the entire old environment variable -- there
         * really ought to be a library function for this.  It's safe
         * to free it since the only place these variables come from
         * is a previous call to this function; we can never be
         * freeing a system-supplied environment variable. */
        oldval -= strlen(buf) + 1; /* skip past VAR= */
    }
    else {
        *c = '=';
        newval = buf;
    }

    putenv(newval);

    if(oldval) {
        /* Do the actual freeing of the old value after it's not being referred to any more. */
        free(oldval);
        free(buf);
    }
}

/* Scan a query string, stuffing variables into the environment. */
static void scanquery(q) char *q;
{
    char *next = q;

    do {
        next = strchr(next, '&');
        if(next)
            *next = '\0';

        stuffenv(q);
        if(next)
            *next++ = '&';
        q = next;
    } while (q != NULL);
}

/* stores an file which was uploaded, it returns the amount of read bytes, it needs the boundary string and the filetype of the uploaded file */
unsigned long store_file(char *bound, char *filetype)
{
    char *file_buffer, *boundary, c;
    int got, bound_size;
    unsigned int sofar = 0, i;
    FILE *tmp;

    bound_size = strlen(bound + 3);
    boundary = malloc(bound_size);
    sprintf(boundary, "\r\n%s", bound);
    file_buffer = malloc(bound_size);

    /* it is a at list for serge */
    if(strstr(filetype, "dbupdate")) {
        tmp = fopen(TMP_UPLOADED, "w+");
        for(i = 0; ;) {
            got = fread(&c, 1, 1, stdin);
            sofar += got;
            if(got == 0)
                break;
            if(c == boundary[i]) { /* if the end is reached, we read in the boundary */
                file_buffer[i] = (char) c;
                if(i == (bound_size - 3)) /* we read the complete boundary, lets end this */
                    break;
                i++;
                file_buffer[i] = '\0';
            }
            else {
                if(i != 0) {
                    fprintf(tmp, "%s", file_buffer);
                    i = 0;
                }
                fwrite(&c, 1, 1, tmp);
            }
        }
        fclose(tmp);
        sprintf(filetype, "dbupdate");
        
        if(system("/usr/bin/md5sum "TMP_UPLOADED" > "TMP_MD5) == -1) {
            log_entry(LOG_FILE, "Error using /usr/bin/md5sum");
        }
        
        rename(TMP_UPLOADED, TMP_IMAGE);
    } /* end serge at file */

    free(boundary);
    free(file_buffer);
    return sofar;
}

/* Read a POST query from standard input into a dynamic buffer. */
static char *postread(void)
{
    char *p, *buf = NULL, *querry = 0, *content_type = NULL, *content_length = NULL;
    char boundary_finished = 0, boundary[100], filetype[30], nofilename = 0;
    int size = 0, sofar = 0, got, querry_size = 1;
    unsigned int i, input_char;
    FILE *tmp;

    content_type   = getenv("CONTENT_TYPE");
    content_length = getenv("CONTENT_LENGTH");

    if(content_length == NULL)
        return(buf);
    size = atoi(content_length);

    /* we have application/x-www-form-urlencoded or something similar */
    if(content_type == NULL || !strcmp(content_type, "application/x-www-form-urlencoded")) {
        buf = malloc(size + 1);
        do {
            got = fread(buf + sofar, 1, size - sofar, stdin);
            sofar += got;
        } while (got && sofar < size);

        buf[sofar] = '\0';
        return(buf);
    }

    /* we have multipart/form-data */
    size--;
    buf = malloc(size);
    querry = malloc(querry_size);
    boundary[0] = querry[0] = '\0';

    p = index(content_type, (int) '='); /* get the boundary string */
    p++;
    boundary[0] = boundary[1] = '-';
    for(i = 2; i < 102 && *p != '\n'; p++, i++)
        boundary[i] = *p;
    boundary[i] = '\0';

    p = buf;
    /* get all content */
    input_char = fgetc(stdin);
    if(input_char)
        sofar++;
    for(i = 0; sofar < size; i++) {
        if(input_char == '\n') { /* a new line was read */
            if(boundary_finished == 2 || strstr(buf, boundary)) { /* found a boudary */
                input_char = fgetc(stdin); /* get the next line */
                sofar++;
                boundary_finished = 0; /* boundary is not finished */
                for(i = 0; sofar < size && !boundary_finished; i++) {
                    if(input_char == '\n') { /* a new line was read */
                        buf[i] = '\0';
                        if(strstr(buf, "Content-Disposition: form-data;")) { /* get the name of the element */
                            p = index(buf, (int) '"');
                            p++;
                            for(i = 0; i < 500 && *p != '"'; i++, p++)
                                buf[i] = *p; /* buf is reused for this now! */
                            buf[i] = '=';
                            i++;
                            p++;
                            buf[i] = '\0'; /* terminate, just to be sure */

                            if(*p == '\r') { /* This is a normal element */
                                input_char = fgetc(stdin);
                                input_char = fgetc(stdin);
                                input_char = fgetc(stdin);
                                sofar += 3;
                                for(; input_char != '\r'; i++) {
                                    if(input_char == '+') { /* replace a '+' with a %2B */
                                        buf[i] = '%';       /* this will be undone in url_unescape */
                                        i++;
                                        buf[i] = '2';
                                        i++;
                                        buf[i] = 'B';
                                    }
                                    else
                                        buf[i] = input_char;
                                    input_char = fgetc(stdin);
                                    sofar++;
                                }
                                buf[i] = '\0';

                                if(querry_size > 1) /* this is not the first element */
                                    strcat(querry, "&"); /* insert a delimiter */
                                querry_size = querry_size + 1 + strlen(buf);
                                querry = realloc(querry, querry_size);
                                strcat(querry, buf);

                                boundary_finished = 1;
                            } /* end ordinary element */

                            if(*p == ';') { /* This is a file upload */
                                strcpy(filetype, buf); /* remember name, from where has the file been uploaded? */

                                /* go for the filename */
                                for(p++; *p != '"'; p++);
                                for(p++, i = 0; *p != '"'; i++, p++)
                                    buf[i] = *p;
                                buf[i] = '\0'; /* finish the "name" element */

                                /* store the filename in file */
                                unlink("/tmp/uploaded_filename");
                                if(strlen(buf) < 1)
                                    nofilename = 1;
                                else {
                                    nofilename = 0;
                                    tmp = fopen("/tmp/uploaded_filename", "w+");
                                    fprintf(tmp, "%s\n", buf);
                                    fclose(tmp);
                                }

                                /* get the next line and skip it (Content-Type is boring) */
                                input_char = fgetc(stdin);
                                sofar++;
                                for(; input_char != '\n'; ) {
                                    input_char = fgetc(stdin);
                                    sofar++;
                                }

                                input_char = fgetc(stdin); /* get the empty line */
                                input_char = fgetc(stdin);
                                sofar += 2;

                                /* now the uploaded file comes (only if a filename has been given) */
                                if(!nofilename) { /* there is a file uploaded */
                                    i = querry_size; /* do we need a delimiter? */
                                    querry_size = querry_size + 10 + strlen(buf);
                                    querry = realloc(querry, querry_size);
                                    if(i > 1) /* this is not the first element */
                                        strcat(querry, "&"); /* insert a delimiter */
                                    strcat(querry, "filename=");
                                    strcat(querry, buf);
                                    sofar += store_file(boundary, filetype);

                                    /* the store_file function changed the content of the "filetype", so now we can make an variable out of it */
                                    querry_size = querry_size + 10 + strlen(filetype);
                                    querry = realloc(querry, querry_size);
                                    strcat(querry, "&message=");
                                    strcat(querry, filetype);

                                    /* do not proceed for further form elements, otherwise some browsers
                                    do not finish sending the last bytes when uploading huge files like firmware */
                                    if(filetype[1] == '\0' && filetype[0] != '\0')
                                        sofar = size + 1; /* end reading by cheating with size */
                                }
                                else { /* no file was uploaded */
                                    /* get everything until the end of the next boundary */
                                    input_char = fgetc(stdin); /* get the empty line */
                                    input_char = fgetc(stdin);
                                    sofar += 2;
                                    buf[i] = '\0';
                                }
                                boundary_finished = 2;
                            } /* end fileupload */
                            i = 0; /* any way: start reading a new line */

                        } /* end Content-Disposition */
                    }
                    else
                        buf[i] = input_char;

                    input_char = fgetc(stdin);
                    if(input_char)
                        sofar++;
                }
            } /* end boundary */
        }
        else
            buf[i] = input_char;

        input_char = fgetc(stdin);
        if(input_char)
            sofar++;
    }
    return(querry);
}

/* Main program, optionally callable as a library function. */
void uncgi(void)
{
    char *query, *dupquery, *method;

    /* First, get the query string, wherever it is, and stick its
     * component parts into the environment.  Allow combination
     * GET and POST queries, even though that's a bit strange. */
    query = getenv("QUERY_STRING");
    if (query != NULL && strlen(query)) {
        /* Ultrix doesn't have strdup(), so we do this the long way. */
        dupquery = malloc(strlen(query) + 1);
        if (dupquery) {
            strcpy(dupquery, query);
            scanquery(dupquery);
        }
    }

    method = getenv("REQUEST_METHOD");
    if (method != NULL && !strcmp(method, "POST")) {
        query = postread();
        if (query[0] != '\0')
            scanquery(query);
    }
}
