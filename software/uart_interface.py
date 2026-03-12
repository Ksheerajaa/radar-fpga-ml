import serial


class UART:

    def __init__(self, port=None, baud=115200):

        # If no port is given → simulation mode
        if port is None:
            self.simulation = True
            print("UART running in simulation mode (no hardware)")
        else:
            self.simulation = False
            self.ser = serial.Serial(port, baud)
            print(f"UART connected to {port}")

    def send(self, data):

        message = ",".join(map(str, data)) + "\n"

        if self.simulation:
            print("Simulated send:", message.strip())
        else:
            self.ser.write(message.encode())

    def receive(self):

        if self.simulation:
            return "SIMULATED_RESPONSE"
        else:
            return self.ser.readline().decode().strip()