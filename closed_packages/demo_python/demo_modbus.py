#!/usr/bin/env python
"""Demonstrates reading and writing to Modbus devices via Modbus RTU and TCP"""

from time import sleep
from pymodbus.client import ModbusTcpClient, ModbusSerialClient
from pymodbus.constants import Endian
from pymodbus.payload import BinaryPayloadDecoder
from pymodbus.payload import BinaryPayloadBuilder
from pymodbus import ExceptionResponse

def read_temperature():
    """Get a value from a temperature sensor via Modbus RTU"""
    client = ModbusTcpClient("192.168.1.3")
    res = client.read_input_registers(0, 2)
    client.close()

    data_encoded = BinaryPayloadDecoder.fromRegisters(res.registers[0:2],
                                                      byteorder=Endian.BIG,
                                                      wordorder=Endian.BIG)
    data_decoded = data_encoded.decode_32bit_uint()
    temperature = data_decoded / 10
    return temperature

def set_display(value):
    """Set a value to be displayed on a Modbus RTU display"""
    client = ModbusSerialClient(port="/devices/2_serial1",
                                baudrate=9600,
                                bytesize=8, parity="N",
                                stopbits=1)

    # set dot in the middle of display
    _ = client.write_registers(18, 0, 16)

    # set data type to float
    _ = client.write_registers(17, 2, 16)

    builder = BinaryPayloadBuilder(byteorder=Endian.BIG, wordorder=Endian.BIG)
    builder.add_32bit_float(value)
    payload = builder.build()

    # write value in INT register
    _ = client.write_registers(27, payload, 16, skip_encode=True)

    client.close()

def janitza():
    """Read frequency from a Janitza UMG 92RM-E"""
    client = ModbusTcpClient("192.168.200.34", port=502)
    res = client.read_holding_registers(800, 4)
    if isinstance(res, ExceptionResponse):
        print(f"Received Modbus library exception ({res})")
    client.close()

    data_encoded = BinaryPayloadDecoder.fromRegisters(res.registers[0:3], byteorder=Endian.BIG, wordorder=Endian.BIG)
    data_decoded = data_encoded.decode_32bit_float()
    print(f"{data_decoded}")

def main():
    """Demonstrates how to receive data from a temperature sensor (Modbus TCP)
       and send data to a display (Modbus RTU)"""
    while True:
        temp = read_temperature()
        set_display(temp)
        sleep(3)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
