#include "defines.h"

void tail(FILE *in, int n) {
  int count = 0;

  unsigned long long pos;
  char str[MAX_TEXT_LENGTH];

  if(fseek(in, 0, SEEK_END))
    perror("fseek() failed");
  else {
      pos = ftell(in);

      while(pos) {
	  if(!fseek(in, --pos, SEEK_SET)) {
	      if(fgetc(in) == '\n')

		if(count++ == n)
		  break;
	  } else {
	      perror("fseek() failed");
	  }
      }

      while(fgets(str, sizeof(str), in)) {
	fprintf(output, "%s<br>", str);
      }
    }
}

void get_log(char *log_path, int line_count) {
    FILE * data;

    data = fopen(log_path, "r");

    if(NULL == data) {
         fprintf(output,"No data available..");
    }
    else {
	tail(data, line_count);

        fclose(data);
    }

    return;
}

void *web_s_info(void) {

    visited("info");

    start_box();
    fprintf(output, "<h1>%s</h1>", get_text("SYSTEM_INFO"));
    end_box();

    start_box();
    get_text_from_file("info.html");
    end_box();

    return NULL;
}

void *web_s_log(void) {

    visited("log");

    start_box();
    fprintf(output, "<h1>%s</h1>", get_text("LOGGING"));
    end_box();

    start_box();
    get_log("/var/log/application/current", 200);
    end_box();
    
    return NULL;
}
