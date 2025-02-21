#!/usr/bin/env python
"""Demonstrates how to use a serial interface"""

from serial import Serial

def main():
    # open the first serial interface in slot 2 (2_serial1)
    s = Serial('/devices/2_serial1', baudrate=115200,
                                     bytesize=8,
                                     parity="N",
                                     stopbits=1)
    s.write(b'hello')
    s.close()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
