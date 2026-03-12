import numpy as np
from software.feature_sender import send_features

labels = ["benign","constant","random","reactive"]

sample = np.random.rand(12)

send_features(sample)

print("Input features:",sample)
print("Prediction from FPGA displayed on UART monitor")
