#!/bin/bash
set -ex

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=runfile_local

# cd /var/tmp
# wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
# sudo dpkg -i cuda-keyring_1.1-1_all.deb
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-12-3

# sudo docker run --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -benchmark -gpu


sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential dkms 

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.1-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.1-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8

# Set up environment variables if ~/.bashrc exists
if [ -f ~/.bashrc.local ]; then
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc.local
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc.local
    echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc.local
fi

# add the environment variables to ~/.zshrc if it exists
if [ -f ~/.zshrc.local ]; then
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.zshrc.local
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.zshrc.local
    echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.zshrc.local
fi

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Check if CUDA is installed correctly
nvcc --version
# Check if the GPU is recognized
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe nvidia-smi

# python3 -c "import torch; print(torch.cuda.is_available())"

# Check if the GPU is available in Docker
#docker run --gpus all nvidia/cuda:12.3.0-base nvidia-smi


# Install cuDNN
sudo apt install -y nvidia-cudnn