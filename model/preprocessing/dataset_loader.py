import os
import pandas as pd

def load_dataset(dataset_path):

    # Convert relative path to absolute path
    dataset_path = os.path.abspath(dataset_path)

    classes = ["benign", "constant", "random", "reactive"]

    dataframes = []

    for cls in classes:

        folder = os.path.join(dataset_path, cls)

        for file in os.listdir(folder):

            path = os.path.join(folder, file)

            df = pd.read_csv(path)

            df["label"] = cls

            dataframes.append(df)

    dataset = pd.concat(dataframes, ignore_index=True)

    selected_features = [
    "tx_total_pkts",
    "tx_failures",
    "tx_pkts_retries",
    "rx_data_pkts",
    "rx_total_pkts_retried",
    "tx_total_pkts_sent",
    "per_antenna_avg_rssi_rx_data_frames_1",
    "per_antenna_avg_rssi_rx_data_frames_2",
    "per_antenna_noise_floor_1",
    "per_antenna_noise_floor_2",
    "sinr_per_antenna_1",
    "sinr_per_antenna_2"
    ]

    X = dataset[selected_features]
    y = dataset["label"]

    # Encode labels → numbers
    encoder = LabelEncoder()
    y = encoder.fit_transform(y)

    return X, y