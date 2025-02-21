import socket
import os.path

class Cli():
    """CLI uses an UDS (Unix Domain Socket) to communicate with the device similar to ssh"""
    def __init__(self):
        self._cli = None
        self._prompt = None
        self.connect()

    def connect(self):
        """Establish a CLI connection to the router without authentication"""
        uds = '/devices/cli_no_auth/cli.socket'
        if os.path.exists(uds) is False:
            print("Error: You have to enable authorized access to the CLI for this container in the router")
            return False
        self._cli = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self._cli.connect(uds)

        # remember prompt configuration
        self._prompt = self._cli.recv(1024).decode('utf-8')
        return True

    def disconnect(self):
        """Disconnect from CLI connection to the router"""
        self._cli.close()
        return True

    def get(self, command):
        """Send a CLI command and return the answer"""
        if self._cli is None:
            return None

        # append eventually missing new line character
        if command.endswith('\n') is False:
            command = command + '\n'

        self._cli.send(bytes(command, 'utf-8'))
        response = ""
        while True:
            response = response + (self._cli.recv(1024).decode('utf-8'))
            if len(response) >= len(self._prompt):
                if response.endswith(self._prompt):
                    break
        return response[:len(response) - len(self._prompt)]
