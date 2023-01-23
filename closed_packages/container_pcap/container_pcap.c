/* The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#define _GNU_SOURCE /* For memmem */
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <errno.h>
#include <time.h>
#include <stdlib.h>
#include <sys/select.h>

/* Please be aware: this is a simple Proof of Concept, error handling is largely missing!
 * This can be used to let the router trace a network interface and store it in a pcap file.
 * Do not forget to allow the container unautorized READ and WRITE access to the CLI (container config within router)! */

const char *cli_uds_socket = "/devices/cli_no_auth/cli.socket";
const char *pcap_header = "\xD4\xC3\xB2\xA1\0";
enum {
    buffersize = 4096,
};

int main(int argc, char *argv[])
{
    int uds_fd = socket(AF_UNIX, SOCK_STREAM, 0);

    if (uds_fd > 0) {
        int ret;
        struct sockaddr_un un = {0};

        if (argc < 4) {
            printf("%s <filename> <seconds> [tcpdump options]\n", argv[0]);
            return -1;
        }

        un.sun_family = AF_UNIX;
        strncpy(un.sun_path, cli_uds_socket, strlen(cli_uds_socket));
        ret = connect(uds_fd, (struct sockaddr *)&un, sizeof(un));

        if (ret >= 0) {
            int filesize = 0;
            int pcap_fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (pcap_fd > 0) {
                char cmdline[buffersize] = "help.debug.tool=tcpdump ";
                for (int i = 3; i < argc ; ++i) {
                    strcat(cmdline, argv[i]);
                    strcat(cmdline, " ");
                }
                // "-U" is unbuffered, "-w -" is write to stdout
                strcat(cmdline, "-U -w -\n");
                if (write(uds_fd, cmdline, strlen(cmdline)) == 0) {
                    printf("No bytes written");
                }
                int pcap_header_found = 0;
                int ret = 0;
                struct timeval tv;
                // the linux implementation of select will decrement the timeout
                tv.tv_sec = strtoul(argv[2], NULL, 10);

                do {
                    fd_set rfds = {};
                    FD_ZERO(&rfds);
                    FD_SET(uds_fd, &rfds);
                    ret = select(uds_fd + 1, &rfds, NULL, NULL, &tv);
                    if (ret == 0) {
                        // timeout, send a single escape to stop tcpdump
                        if (write(uds_fd, "\e", 1) == 0) {
                            printf("No bytes written");
                        }
                    }
                    if (FD_ISSET(uds_fd, &rfds) || (ret == 0)) {
                        char buffer[buffersize];
                        int bytes = 0;
                        bytes = read(uds_fd, buffer, buffersize);
                        if (bytes > 0) {
                            if (pcap_header_found == 0) {
                                // NOTE: this does NOT work if the header is not complete
                                char *payload_start = memmem(buffer, bytes, pcap_header, strlen(pcap_header));
                                if (payload_start) {
                                    if (write(pcap_fd, payload_start, bytes - (payload_start - buffer)) == 0) {
                                        printf("No bytes written");
                                    }
                                    pcap_header_found = 1;
                                    filesize += bytes - (payload_start - buffer);
                                }
                            }
                            else {
                                if (write(pcap_fd, buffer, bytes) == 0) {
                                    printf("No bytes written");
                                }
                                filesize += bytes;
                            }
                        }
                    }
                }
                while (ret > 0);

                close(pcap_fd);
            }
            else {
                printf("Failed to open %s: %s\n", argv[1], strerror(errno));
            }
            close(uds_fd);
        }
        else {
            printf("Failed to open cli socket\n");
        }
    }
}
