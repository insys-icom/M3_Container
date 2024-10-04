import socket

class Mcip():
    """MCIP is a minimal protocol, that can transport info like IO status"""

    def __init__(self):
        self._mcip = None
        self._connect()

    def _connect(self):
        """Establish a connection to the MCIP daemon of the router"""
        self._mcip = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self._mcip.connect('/devices/mcip.socket')

        # send "hello" to MCIP server, register with OID 4 (0x4 0x0)
        n = self._mcip.send(b'\x55\x02\x00\x04\x00\x00\x00\x04\x00')
        if n == (5 + 4):
            return True
        return False

    def disconnect(self):
        """Disconnect from MCIP daemon of the router"""
        # send "bye" to MCIP server
        n = self._mcip.send(b'\x55\x03\x00\x00\x00')
        self._mcip.close()
        if n == 5:
            return True
        return False

    def get(self):
        """Wait for a complete MCIP telegram"""
        response = bytearray()
        length = 0
        while True:
            response.append(self._mcip.recv(1)[0])
            if response[0] == 85: # (0x55)
                if (len(response) == 5):
                    length = int.from_bytes(response[3:4], byteorder='little')

                if len(response) == length + 5:
                    break

        return response
