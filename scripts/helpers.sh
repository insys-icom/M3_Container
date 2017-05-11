#!/bin/sh

# print error message and exit
exit_failure()
{
    echo $*

    # execute a notifying script in case it exists
    [ -e ~/m3_email.sh ] && ~/m3_email.sh $*

    exit 1
}
