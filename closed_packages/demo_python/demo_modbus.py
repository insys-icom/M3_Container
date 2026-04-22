#!/usr/bin/env python
"""Demonstrates reading and writing to Modbus devices via Modbus RTU and TCP"""

from time import sleep
from pymodbus.client import ModbusTcpClient, ModbusSerialClient

def read_temperature():
    """Get a value from a temperature sensor via Modbus TCP"""
    client = ModbusTcpClient("192.168.1.3")
    result = client.read_input_registers(0, count=2)
    client.close()

    temperature = client.convert_from_registers(result.registers, client.DATATYPE.INT32, "big") / 10

    return temperature

def set_display(value):
    """Set a value to be displayed on a Modbus RTU display"""
    client = ModbusSerialClient(port="/devices/2_serial1",
                                baudrate=9600, bytesize=8, parity="N", stopbits=1)

    # set dot in the middle of display
    _ = client.write_register(18, 0, device_id=16)

    # set data type to float
    _ = client.write_register(17, 2, device_id=16)

    # write to register as INT
    payload = client.convert_to_registers(value, client.DATATYPE.FLOAT32, "big")
    _ = client.write_registers(27, payload, device_id=16)

    client.close()

def janitza():
    """Read frequency from a Janitza UMG 96RM-E"""
    client = ModbusTcpClient("192.168.1.100", port=502)
    result = client.read_holding_registers(800, device_id=3, count=2)
    client.close()

    freq = client.convert_from_registers(result.registers, client.DATATYPE.FLOAT32, "big")
    print(f"{freq}")

def main():
    """Demonstrates how to receive data from a temperature sensor (Modbus TCP)
       and send data to a display (Modbus RTU)"""
    while True:
        temp = read_temperature()
        set_display(temp)
        sleep(1)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
