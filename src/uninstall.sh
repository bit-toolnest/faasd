#!/bin/bash
set -e

echo "=== FAASD Server Uninstaller Script ==="

# 1) Stop faasd services
echo "➡ Stopping faasd services..."
sudo systemctl stop faasd || true
sudo systemctl disable faasd || true

# 2) Remove faasd binary
echo "➡ Removing faasd binary..."
sudo rm -f /usr/local/bin/faasd || true

# 3) Remove faasd configs
echo "➡ Removing faasd configs..."
sudo rm -rf /etc/faasd || true

# 4) Remove containerd + runc
echo "➡ Removing containerd and runc..."
sudo systemctl stop containerd || true
sudo systemctl disable containerd || true
sudo apt remove --purge containerd runc -y || true

# 5) Remove CNI plugins
echo "➡ Removing CNI plugins..."
sudo rm -rf /opt/cni/bin || true

# 6) Cleanup containerd state
echo "➡ Cleaning containerd state..."
sudo rm -rf /var/lib/containerd || true

# 7) Final apt cleanup
echo "➡ Running apt cleanup..."
sudo apt autoremove -y
sudo apt clean

echo "🎯 faasd server uninstall process finished!"
