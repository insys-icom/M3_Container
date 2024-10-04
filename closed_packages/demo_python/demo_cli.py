#!/usr/bin/env python3
"""Demonstrate how to use the CLI"""

from insys.cli import Cli

def main():
    # open and start a CLI session
    cli = Cli()

    # get serial number of device
    serial = cli.get('status.device_info.slot[1].serial_number')
    print(f"Serial number: {serial}")

    # create an array from the multi line answer of CLI
    device_info = cli.get('status.device_info').split('\n')
    for i in device_info:
        if '=' in i:
            print(f"{i}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
