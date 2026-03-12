import torch
import torch.nn as nn

class RF_CNN(nn.Module):

    def __init__(self):

        super(RF_CNN, self).__init__()

        self.conv1 = nn.Conv1d(
            in_channels=1,
            out_channels=8,
            kernel_size=3
        )

        self.conv2 = nn.Conv1d(
            in_channels=8,
            out_channels=16,
            kernel_size=3
        )

        self.relu = nn.ReLU()

        self.flatten = nn.Flatten()

        # 16 channels × 8 length = 128
        self.fc1 = nn.Linear(128,32)

        self.fc2 = nn.Linear(32,4)

    def forward(self, x):
        print("Input:", x.shape)

        x = self.relu(self.conv1(x))
        print("After conv1:", x.shape)

        x = self.relu(self.conv2(x))
        print("After conv2:", x.shape)

        x = self.flatten(x)

        x = self.relu(self.fc1(x))

        x = self.fc2(x)

        return x