#!/usr/bin/env python
"""Demonstrates how to send an SMS via CLI command"""

from insys.cli import Cli

def main():
    """Send a CLI command to the router that sends and SMS"""

    modem = "lte2"
    phone = "+491234"
    text  = "This is the SMS text"

    cli = Cli()
    if cli.get(f'help.debug.sms.modem={modem}') is None:
        return False
    cli.get(f'help.debug.sms.recipient={phone}')
    cli.get(f'help.debug.sms.text=-----BEGIN ...-----{text}-----END ...-----')
    cli.get('help.debug.sms.submit')
    cli.disconnect()

    print("Look at modem log for confirmation that SMS has been sent")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
