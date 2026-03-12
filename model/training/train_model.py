import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.utils.prune as prune
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import LabelEncoder


import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from architecture.cnn1d_model import RF_CNN
from preprocessing.dataset_loader import load_dataset
from optimization.quantization import quantize_model


def prune_model(model):

    prune.l1_unstructured(model.conv1,name="weight",amount=0.4)
    prune.l1_unstructured(model.conv2,name="weight",amount=0.4)
    prune.l1_unstructured(model.fc1,name="weight",amount=0.4)

    prune.remove(model.conv1,"weight")
    prune.remove(model.conv2,"weight")
    prune.remove(model.fc1,"weight")


def train():

    X, y = load_dataset("dataset")

    # encode string labels into integers
    encoder = LabelEncoder()
    y = encoder.fit_transform(y)

    scaler = StandardScaler()
    X = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
    )

    X_train = torch.tensor(X_train, dtype=torch.float32).unsqueeze(1)
    X_test = torch.tensor(X_test, dtype=torch.float32).unsqueeze(1)

    y_train = torch.tensor(y_train, dtype=torch.long)
    y_test = torch.tensor(y_test, dtype=torch.long)

    dataset = torch.utils.data.TensorDataset(X_train,y_train)
    loader = torch.utils.data.DataLoader(dataset,batch_size=64,shuffle=True)

    model = RF_CNN()

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(),lr=0.001)

    for epoch in range(20):

        for data,label in loader:

            optimizer.zero_grad()

            output = model(data)

            loss = criterion(output,label)

            loss.backward()

            optimizer.step()

        print("Epoch",epoch,"Loss",loss.item())

    print("Pruning model...")
    prune_model(model)

    print("Quantizing model...")
    model = quantize_model(model)

    save_dir = os.path.join(os.path.dirname(__file__), "..", "trained_model")
    os.makedirs(save_dir, exist_ok=True)

    torch.save(model.state_dict(), os.path.join(save_dir, "model.pth"))

    print("Training complete")


if __name__ == "__main__":
    train()