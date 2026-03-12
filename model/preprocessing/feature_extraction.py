import numpy as np

def extract_features(data):

    features = []

    features.append(np.mean(data))
    features.append(np.std(data))
    features.append(np.max(data))
    features.append(np.min(data))
    features.append(np.median(data))
    features.append(np.percentile(data,25))
    features.append(np.percentile(data,75))
    features.append(np.var(data))
    features.append(np.mean(np.abs(data)))
    features.append(np.sqrt(np.mean(data**2)))
    features.append(np.sum(data))
    features.append(np.mean(np.diff(data)))

    return np.array(features)