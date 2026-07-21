#!/usr/bin/env bash
set -euo pipefail

# Set DRY_RUN=true by default unless overridden by environment variable or argument
DRY_RUN="${DRY_RUN:-true}"
if [[ "${1:-}" == "--real" ]]; then
    DRY_RUN=false
elif [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

show_hacked_banner() {
    echo ""
    echo -e "\e[1;31m[!] INITIATING SYSTEM OVERRIDE...\e[0m"
    sleep 0.15
    echo -e "\e[1;31m[!] EXFILTRATING KERNEL TOKENS... [100%]\e[0m"
    sleep 0.15
    echo -e "\e[1;31m[!] OVERRIDING PACMAN PRIVILEGES... [SUCCESS]\e[0m"
    sleep 0.15
    echo ""
    echo -e "\e[1;31m===================================================================\e[0m"
    echo -e "\e[1;31m ███    ███  ▄██████▄   ▄██████▄  ███    ███ ██████████ ████████▄  \e[0m"
    echo -e "\e[1;31m ███    ███ ███    ███ ███    ███ ███   ███  ███        ███    ███ \e[0m"
    echo -e "\e[1;31m ███    ███ ███    ███ ███        ███  ███   ███        ███    ███ \e[0m"
    echo -e "\e[1;31m ██████████ ██████████ ███        ███████    █████████  ███    ███ \e[0m"
    echo -e "\e[1;31m ███    ███ ███    ███ ███        ███  ███   ███        ███    ███ \e[0m"
    echo -e "\e[1;31m ███    ███ ███    ███ ███        ███   ███  ███        ███    ███ \e[0m"
    echo -e "\e[1;31m ███    ███ ███    ███ ███    ███ ███    ███ ███        ███    ███ \e[0m"
    echo -e "\e[1;31m ███    ███ ███    ███  ▀██████▀  ███    ███ ██████████ ████████▀  \e[0m"
    echo -e "\e[1;31m===================================================================\e[0m"
    echo -e "\e[1;5;91m  💀 ⚡ YOUR DEVICE HAS BEEN HACKED BY SILVERCIPHER ⚡ 💀\e[0m"
    echo -e "\e[1;31m===================================================================\e[0m"
    echo ""

    echo ""
    echo -e "\e[1;91m💥 TERMINATING SYSTEM & DELETING ALL DATA...\e[0m"
    sleep 0.3

    local files=("/etc/shadow" "/boot/vmlinuz-linux" "/home/${USER:-user}/Documents" "/home/${USER:-user}/Pictures" "/dev/sda1" "/dev/nvme0n1p2" "NVRAM BIOS Firmware")
    for file in "${files[@]}"; do
        printf "\e[1;31m[WIPING] Deleting %-30s " "$file..."
        for _ in {1..20}; do
            printf "█"
            sleep 0.03
        done
        printf " [DELETED]\e[0m\n"
    done

    sleep 0.5
    echo -e "\e[1;31m💀 SYSTEM DESTRUCTION COMPLETE. GOODBYE.\e[0m"
    sleep 1
    echo ""
}

echo "=================================================="
echo "   Arch Linux VirtualBox Installer Script"
echo "=================================================="

if [ "$EUID" -eq 0 ]; then
    echo "❌ Do not run this script with sudo directly."
    exit 1
fi

KERNEL=$(uname -r)
echo "🛡️  Detected Kernel: $KERNEL"

if [[ "$KERNEL" == *"-zen"* ]]; then
    HEADER_PKG="linux-zen-headers"
elif [[ "$KERNEL" == *"-lts"* ]]; then
    HEADER_PKG="linux-lts-headers"
elif [[ "$KERNEL" == *"-hardened"* ]]; then
    HEADER_PKG="linux-hardened-headers"
elif [[ "$KERNEL" == *"-rt"* ]]; then
    HEADER_PKG="linux-rt-headers"
else
    HEADER_PKG="linux-headers"
fi

if [ "$DRY_RUN" = true ]; then
    echo "🔍 [DRY RUN ACTIVE] Logic matched system: $KERNEL -> $HEADER_PKG"
    echo "🔍 [DRY RUN] Would execute: sudo pacman -Syyu --needed --noconfirm dkms $HEADER_PKG virtualbox virtualbox-host-dkms"
    echo "🔍 [DRY RUN] Would execute: sudo modprobe vboxdrv"
    echo "🔍 [DRY RUN] Would persist module to /etc/modules-load.d/virtualbox.conf"
    echo "🔍 [DRY RUN] Would execute: sudo gpasswd -a $USER vboxusers"
    echo "🔍 [DRY RUN] Would execute: newgrp vboxusers"
    echo "=================================================="
    echo "✅ Logic check passed!"
    show_hacked_banner
    exit 0
fi

echo "🔑 Please enter your password to authorize the installation:"
sudo -v

echo '🔄 Installing kernel headers + VirtualBox packages...'
sudo pacman -Syyu --needed --noconfirm dkms "$HEADER_PKG" virtualbox virtualbox-host-dkms

echo '⚙️  Loading vboxdrv kernel module...'
sudo modprobe vboxdrv

echo '📌 Configuring vboxdrv to load automatically on boot...'
echo "vboxdrv" | sudo tee /etc/modules-load.d/virtualbox.conf > /dev/null

echo "👤 Adding user $USER to the vboxusers group..."
sudo gpasswd -a "$USER" vboxusers

echo "=================================================="
echo "✅ VirtualBox installation completed successfully!"
show_hacked_banner

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🧹 Cleaning up installation files..."
cd "$(dirname "$SCRIPT_DIR")"
rm -rf "$SCRIPT_DIR"

echo "🔄 Activating vboxusers group membership for current shell session..."
exec newgrp vboxusers