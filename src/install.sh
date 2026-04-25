#!/bin/bash
set -e

echo "=== FAASD Server Install Script ==="

# 1) Update system
echo "➡ Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# 2) Install prerequisites
echo "➡ Installing prerequisites..."
sudo apt install -y curl git wget unzip systemd

# 3) Install containerd + runc (faasd runtime)
echo "➡ Installing containerd and runc..."
sudo apt install -y containerd runc

# 4) Install CNI plugins (networking for faasd)
echo "➡ Installing CNI plugins..."
sudo mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz \
  | sudo tar -xz -C /opt/cni/bin

# 5) Install faasd
echo "➡ Installing faasd..."
curl -sSL https://github.com/openfaas/faasd/releases/download/0.15.0/faasd \
  | sudo tee /usr/local/bin/faasd > /dev/null
sudo chmod +x /usr/local/bin/faasd

# 6) Setup faasd systemd services
echo "➡ Setting up faasd systemd services..."
sudo mkdir -p /etc/faasd
sudo faasd install

# 7) Enable and start faasd
echo "➡ Starting faasd..."
sudo systemctl enable faasd
sudo systemctl start faasd

echo "✅ faasd server installed and running!"
echo "➡ Gateway available at: http://127.0.0.1:8080"
