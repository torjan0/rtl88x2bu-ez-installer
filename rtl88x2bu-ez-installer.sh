#!/usr/bin/env bash
set -euo pipefail

#–– Configuration ––#
REPO_URL="https://github.com/morrownr/88x2bu-20210702.git"
DEST_DIR="$HOME/src/88x2bu"
KEY_PACKAGES=( build-essential dkms git )
KERNEL_HEADERS="linux-headers-$(uname -r)"

#–– 1. Update & install prerequisites ––#
echo "🔄  Updating apt and installing prerequisites..."
sudo apt update
sudo apt install -y "${KEY_PACKAGES[@]}" "$KERNEL_HEADERS"

#–– 2. Clone (or update) the driver repository ––#
if [ -d "$DEST_DIR" ]; then
  echo "🔄  Directory $DEST_DIR exists; pulling latest changes..."
  git -C "$DEST_DIR" fetch --quiet && git -C "$DEST_DIR" reset --hard origin/main
else
  echo "📥  Cloning driver into $DEST_DIR..."
  git clone "$REPO_URL" "$DEST_DIR"
fi

#–– 3. Build & install via the provided script ––#
echo "🛠️  Running the driver installer (DKMS build & load)..."
cd "$DEST_DIR"
sudo ./install-driver.sh

#–– 4. Final instructions ––#
echo
echo "✅  Driver installed and module loaded."
echo "   You can verify with: lsmod | grep 88x2bu"
echo "   To see your adapter: ip link show"
echo
echo "⚠️  It’s recommended to reboot now to finalize installation:"
echo "     sudo reboot"
