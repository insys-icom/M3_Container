#!/usr/bin/env python3
"""Demonstrate how to set outputs via CLI"""

import argparse
from insys.cli import Cli

def main():
    """set an output via CLI"""
    parser = argparse.ArgumentParser(description='Set output')
    parser.add_argument('output', nargs=1, help='Name of output, e.g. "2.1"')
    parser.add_argument('direction', nargs=1, help='Direction to switch: "open" or "close"')
    args = parser.parse_args()

    output = ''.join(args.output)
    direction = ''.join(args.direction)

    if direction != "open" and direction != "close":
        print('Unknown direction, use eighter "open" or "close"')
        return

    # open and start a CLI session
    cli = Cli()

    print(f"Setting output {output} to {direction}")
    cli.get(f'help.debug.output.change={direction}')
    cli.get(f'help.debug.output.output={output}')
    cli.get('help.debug.output.submit')

if __name__ == "__main__":
    main()
