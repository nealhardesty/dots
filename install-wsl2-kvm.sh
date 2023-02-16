#!/bin/sh

# https://boxofcables.dev/kvm-optimized-custom-kernel-wsl2-2022/


sudo sed -i.bak -e 's/# deb-src/deb-src/g' /etc/apt/sources.list

sudo apt update
sudo apt install -y libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm build-essential bc

sudo apt install -y linux-source aria2
sudo apt install -y virt-manager qemu-kvm

mkdir -p ~/src/ 
cd ~/src

curl -s https://api.github.com/repos/microsoft/WSL2-Linux-Kernel/releases/latest | jq -r '.name' | sed 's/$/.tar.gz/' | sed 's#^#https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/#' | aria2c -i -

tar -xf WSL2-*.tar.gz

cd WSL2*/

cp Microsoft/config-wsl .config

sed -i 's/# CONFIG_KVM_GUEST is not set/CONFIG_KVM_GUEST=y/g' .config

sed -i 's/# CONFIG_ARCH_CPUIDLE_HALTPOLL is not set/CONFIG_ARCH_CPUIDLE_HALTPOLL=y/g' .config

sed -i 's/# CONFIG_HYPERV_IOMMU is not set/CONFIG_HYPERV_IOMMU=y/g' .config

sed -i '/^# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set/a CONFIG_PARAVIRT_CLOCK=y' .config

sed -i '/^# CONFIG_CPU_IDLE_GOV_TEO is not set/a CONFIG_CPU_IDLE_GOV_HALTPOLL=y' .config

sed -i '/^CONFIG_CPU_IDLE_GOV_HALTPOLL=y/a CONFIG_HALTPOLL_CPUIDLE=y' .config

sed -i 's/CONFIG_HAVE_ARCH_KCSAN=y/CONFIG_HAVE_ARCH_KCSAN=n/g' .config

sed -i '/^CONFIG_HAVE_ARCH_KCSAN=n/a CONFIG_KCSAN=n' .config

sed -i '/^CONFIG_DEBUG_INFO_BTF=y/a CONFIG_DEBUG_INFO_BTF=n' .config

make -j 12

export PATH=$PATH:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/

powershell.exe /C 'Copy-Item .\arch\x86\boot\bzImage $env:USERPROFILE'

powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'

echo Now run from powershell:
echo wsl.exe --shutdown
