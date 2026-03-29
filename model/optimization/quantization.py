import numpy as np
import os

# Base path fix (IMPORTANT)
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../"))

INPUT_DIR = os.path.join(BASE_DIR, "model_versions/v2_fpga/")
OUTPUT_DIR = os.path.join(BASE_DIR, "weights/")
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "quantized_weights.mem")

# Create weights folder if not present
os.makedirs(OUTPUT_DIR, exist_ok=True)

SCALE = 256

files = sorted([f for f in os.listdir(INPUT_DIR) if f.endswith(".txt")])

quantized = []

print("Files found:", files)

for file in files:
    path = os.path.join(INPUT_DIR, file)

    data = np.loadtxt(path)

    # Ensure array
    data = np.array(data).flatten()

    # Quantize
    q = np.round(data * SCALE).astype(int)

    quantized.extend(q.tolist())

# ===== WRITE .mem FILE =====
os.makedirs("../weights", exist_ok=True)

with open(OUTPUT_FILE, "w") as f:
    for val in quantized:
        # 16-bit hex format
        f.write(f"{val & 0xFFFF:04x}\n")

print("\n✅ Quantized weights saved to:", OUTPUT_FILE)