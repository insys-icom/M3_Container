#!/bin/sh

# this is executed at the end of every build script

# print the usage of a build script
print_help()
{
    echo "Possible actions are:"
    echo "  all (means \"download check_source del_working unpack configure compile install_staging\")"
    echo "  download"
    echo "  check_source"
    echo "  del_working"
    echo "  unpack"
    echo "  configure"
    echo "  compile"
    echo "  install_staging"
    echo "  uninstall_staging"
}

if [ $# -eq 0 ]
then
    print_help
    exit 1
fi

while [ $# -gt 0 ]
do
    # call the desired function
    ${1} || (print_help ; exit_failure "${1} failed")
    shift
done
