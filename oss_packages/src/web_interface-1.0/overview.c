#include "defines.h"

void *web_s_overview(void) {

    visited("overview");

    start_box();
    fprintf(output, "<h1>%s</h1>", get_text("OVERVIEW"));
    end_box();

    start_box();
	get_text_from_file("overview.html");
    end_box();

	return NULL;
}