# RTL88x2BU Driver Installer

A simple Bash script to automate the build and installation of the out‑of‑tree Realtek RTL88x2BU (“AC1200 Techkey”) USB Wi‑Fi driver on Ubuntu. The script uses DKMS so the driver is rebuilt automatically whenever your kernel is updated.

## Features

- Installs all build dependencies (`build-essential`, `DKMS`, `Git`, kernel headers)  
- Clones (or updates) the [`morrownr/88x2bu`](https://github.com/morrownr/88x2bu-20210702) driver repository  
- Registers, builds, and installs the driver via DKMS  
- Loads the module immediately  
- Prints verification tips and a reboot reminder  

## Prerequisites

- Ubuntu 22.04, 23.10, 24.04 (or derivative)  
- Internet access to clone GitHub and fetch packages  
- Sudo privileges  

## Installation

1. **Download the script**  
   ```bash
   git clone https://github.com/torjan0/rtl88x2bu-ez-installer.git
   ```

2. **Make it executable**  
   ```bash
   chmod +x install-rtl88x2bu.sh
   ```

3. **Run with sudo**  
   ```bash
   sudo ./install-rtl88x2bu.sh
   ```

4. **Reboot (recommended)**  
   ```bash
   sudo reboot
   ```

## Usage & Verification

After reboot, your new adapter should appear as a wireless interface. You can verify with:

```bash
lsmod | grep 88x2bu      # Shows the loaded module
ip link show             # Lists network interfaces
```

## Script Breakdown

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
REPO_URL="https://github.com/morrownr/88x2bu-20210702.git"
DEST_DIR="$HOME/src/88x2bu"
KEY_PACKAGES=( build-essential dkms git )
KERNEL_HEADERS="linux-headers-$(uname -r)"

# 1. Update & install prerequisites
sudo apt update
sudo apt install -y "${KEY_PACKAGES[@]}" "$KERNEL_HEADERS"

# 2. Clone or update the driver repo
if [ -d "$DEST_DIR" ]; then
  git -C "$DEST_DIR" fetch --quiet && git -C "$DEST_DIR" reset --hard origin/main
else
  git clone "$REPO_URL" "$DEST_DIR"
fi

# 3. Build & install via DKMS
cd "$DEST_DIR"
sudo ./install-driver.sh

# 4. Final instructions
echo "✅ Driver installed. Please reboot when convenient."
```

## Credits

- **Driver Source:** [morrownr/88x2bu](https://github.com/morrownr/88x2bu-20210702) by morrownr  
- **Chipset:** Realtek RTL88x2BU (AC1200 Techkey)  
- **Script Author:** Maks (torjan0)  

