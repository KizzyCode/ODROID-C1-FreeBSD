# Build a more modern U-boot version (this might help against U-boot boot-loops)

## Prerequisites
A working Fedora installation.

## Install our build-toolchain
```sh
# Add 32-bit support to your distro
sudo dnf install glibc.i686 libstdc++.i686 zlib.i686

# Download and extract it
wget https://releases.linaro.org/archive/14.04/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
sudo mkdir -p /opt/toolchains
sudo tar xJvf gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz -C /opt/toolchains/

# Add the path to the .bashrc
echo 'export PATH=/opt/toolchains/gcc-linaro-arm-none-eabi-4.8-2014.04_linux/bin:$PATH' >> $HOME/.bashrc
source ~/.bashrc

# Validate it (there should be sth. like `gcc version 4.8.3 20140401 (prerelease)` in the last line)
arm-none-eabi-gcc -v
```

## Checkout and compile
```sh
git clone https://github.com/hardkernel/u-boot.git -b odroidc-v2011.03
cd u-boot
make clean && make mrproper
make odroidc_config
make
```
