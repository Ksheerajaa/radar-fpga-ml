import torch
import numpy as np
import os
import sys

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../"))
sys.path.append(PROJECT_ROOT)


from model.architecture.cnn1d_model import RF_CNN

# Paths
MODEL_PATH = "model/trained_model/model.pth"
OUTPUT_DIR = "weights"

os.makedirs(OUTPUT_DIR, exist_ok=True)

print("Loading trained model...")

# Create model
model = RF_CNN()

# Load trained weights
model.load_state_dict(torch.load(MODEL_PATH, map_location="cpu"))
model.eval()

print("Model loaded successfully")


# -------- INT8 Quantization -------- #

def quantize_tensor(tensor):

    max_val = torch.max(torch.abs(tensor))

    scale = max_val / 127

    quantized = torch.round(tensor / scale).to(torch.int8)

    return quantized.numpy(), scale


print("Quantizing weights...")

quantized_weights = {}
scales = {}

for name, param in model.state_dict().items():

    q_weight, scale = quantize_tensor(param)

    quantized_weights[name] = q_weight
    scales[name] = scale

    print(f"Quantized {name} | shape {q_weight.shape}")


# -------- Save numpy weights -------- #

np.save(
    os.path.join(OUTPUT_DIR, "model_weights.npy"),
    quantized_weights
)

print("Saved model_weights.npy")


# -------- Save FPGA memory file -------- #

mem_file = os.path.join(OUTPUT_DIR, "quantized_weights.mem")

with open(mem_file, "w") as f:

    for layer in quantized_weights:

        weights = quantized_weights[layer].flatten()

        for w in weights:
            f.write(f"{int(w)}\n")

print("Saved quantized_weights.mem")

print("Quantization complete")