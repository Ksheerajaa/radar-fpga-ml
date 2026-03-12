import numpy as np
from uart_interface import UART


uart = UART()   # No port → simulation mode


def send_features(features):

    features = np.array(features)

    print("Sending feature vector:")
    print(features)

    uart.send(features)