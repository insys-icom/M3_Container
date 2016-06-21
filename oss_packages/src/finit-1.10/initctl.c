/* ioctl for finit
 *
 * Copyright (c) 2014 Michael Kress <m-kress@m-kress.de>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#include "finit.h"

/* This small user space program needs the plugin "initctl.so" to be loaded. It can be used to
   start, stop or restart (by simply killing) services defined in finit.conf

   initctl <action> <service>
       <action> is "start", "stop" or "restart"
       <service> must be given with full path (as configured in finit.conf) */

int main (int argc, char **argv)
{
    int ret = 0;
    int fd = -1;
    struct init_request rq;

    if (argc < 3) {
        printf("Too few parameters\n");
        return -1;
    }

    if (strstr(argv[1], "restart")) {
        rq.cmd = INIT_CMD_RESTART;
    }
    else if (strstr(argv[1], "start")) {
        rq.cmd = INIT_CMD_START;
    }
    else if (strstr(argv[1], "stop")) {
        rq.cmd = INIT_CMD_STOP;
    }
    else {
        printf("Unknown action\n");
        return -1;
    }

    rq.magic = INIT_MAGIC;
    sprintf(rq.data, "%s", argv[2]);

    fd = open("/dev/initctl", O_WRONLY);
    if (fd < 0) {
        printf("Failed to open /dev/initctl\n");
        return -1;
    }

    if (write(fd, &rq, sizeof(rq)) < 0) {
        printf("Failed to write to /dev/initctl\n");
        ret = -1;
    }

    close(fd);

    return ret;
}

/**
 * Local Variables:
 *  version-control: t
 *  indent-tabs-mode: t
 *  c-file-style: "linux"
 * End:
 */
