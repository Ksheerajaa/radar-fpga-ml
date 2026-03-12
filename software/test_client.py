import numpy as np
from feature_sender import send_features


sample = [
10,
1,
2,
30,
5,
40,
-55,
-53,
-95,
-94,
20,
18
]

send_features(sample)

print("Features sent (software test)")