#!/usr/bin/env python3
"""Demonstrate how to set outputs via CLI and receive input status via MCIP"""

from insys.cli import Cli
from insys.mcip import Mcip

def main():
    """Read device name via MCIP and read input 2.1 state to set output 2.1 via CLI"""
    # open and start a CLI session
    cli = Cli()

    # open a MCIP session and listen for changes on input state
    mcip = Mcip()

    # read the device type via CLI
    device = cli.get('status.device_info.device_type')
    print(f"Device type: {device}")

    while True:
        # wait in blocking mode for a message from MCIP
        response = mcip.get().decode('utf-8')

        if "2.1" in response:
            if "HIGH" in response:
                print("Input 2.1 is HIGH -> set output 2.1 to open")
                cli.get('help.debug.output.change=open')
            elif "LOW" in response:
                print("Input 2.1 is LOW  -> set output 2.1 to closed")
                cli.get('help.debug.output.change=close')

            cli.get('help.debug.output.output=2.1')
            cli.get('help.debug.output.submit')

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
