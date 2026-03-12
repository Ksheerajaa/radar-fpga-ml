import torch
import os
import numpy as np

# Get project root directory
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../"))

# Paths
MODEL_PATH = os.path.join(PROJECT_ROOT, "model", "trained_model", "model.pth")
WEIGHTS_DIR = os.path.join(PROJECT_ROOT, "weights")

# Make sure weights directory exists
os.makedirs(WEIGHTS_DIR, exist_ok=True)

# Load model
model = torch.load(MODEL_PATH, map_location="cpu")


def export_weights(tensor, filename):

    weights = tensor.detach().numpy().flatten()

    filepath = os.path.join(WEIGHTS_DIR, filename)

    with open(filepath, "w") as f:
        for w in weights:
            f.write(f"{w}\n")


export_weights(model["conv1.weight"], "W1.txt")
export_weights(model["conv1.bias"], "B1.txt")
export_weights(model["fc.weight"], "W2.txt")
export_weights(model["fc.bias"], "B2.txt")

print("Weights exported")