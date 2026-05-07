#!/bin/bash

set -e

# 1. Install system dependencies, kernel headers, and the missing Python module
# We add python-colorama and python-setuptools to fix the build error you saw
sudo pacman -S --noconfirm --needed \
    acpi_call-dkms \
    linux-cachyos-headers \
    base-devel \
    python-colorama \
    python-setuptools \
    python-pip

# 2. Setup Persistence for acpi_call
sudo modprobe acpi_call
echo "acpi_call" | sudo tee /etc/modules-load.d/acpi_call.conf

# 3. Non-interactive installation of ryzenadj and the most stable GUI
# We use ryzenadj-git for 7000/8000 series support
# We switch to ryzen-controller-bin to avoid the Python 3.14 build-from-source bugs
paru -S --noconfirm --skipreview --provides=no ryzenadj-git ryzen-controller-bin

echo "----------------------------------------------------"
echo "Setup Complete! Your GPD Win Mini 4 is ready."
echo "Launch 'Ryzen Controller' from your application menu."
