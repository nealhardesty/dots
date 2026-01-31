#!/bin/bash

# Install Google Cloud CLI (gcloud)
# https://docs.cloud.google.com/sdk/docs/install-sdk#deb

set -e

# Add the gcloud CLI distribution URI as a package source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Update and install the gcloud CLI
sudo apt-get update && sudo apt-get install -y google-cloud-cli

echo "Installation complete!"
echo "Run 'gcloud init' to initialize and authorize the CLI."
