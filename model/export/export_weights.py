import numpy as np
from tensorflow.keras.models import load_model
import os

# Get absolute base directory
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../"))

MODEL_PATH = os.path.join(BASE_DIR, "model_versions/v1_current/jamshield_model.h5")
OUTPUT_DIR = os.path.join(BASE_DIR, "model_versions/v2_fpga/")



os.makedirs(OUTPUT_DIR, exist_ok=True)

print("Loading model from:", MODEL_PATH)

model = load_model(MODEL_PATH)
weights = model.get_weights()

print("Total weight tensors:", len(weights))

# Save numpy weights
np.save(os.path.join(OUTPUT_DIR, "model_weights.npy"),
        np.array(weights, dtype=object),
        allow_pickle=True)

# Save flattened weights
layer_id = 0

for i, w in enumerate(weights):
    filename = os.path.join(OUTPUT_DIR, f"W{i}.txt")

    if len(w.shape) == 1:
        # Bias
        np.savetxt(filename, w)
    else:
        # Weights (flatten)
        np.savetxt(filename, w.flatten())

    print(f"Saved: {filename}")

print("\n✅ All weights exported successfully!")