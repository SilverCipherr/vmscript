# Arch Linux VirtualBox Automated Installer

An intelligent, safety-first Bash script to automate the installation and configuration of **VirtualBox** on Arch Linux. 

It automatically detects your running Linux kernel variant (`linux`, `linux-zen`, `linux-lts`, `linux-hardened`, or `linux-rt`), installs the matching kernel header packages along with `virtualbox` and DKMS host modules, configures auto-loading on boot, manages user group privileges, and activates permissions instantly.

---

## ⚡ Features

- **Automated Kernel Detection**: Automatically detects active kernel flavor via `uname -r` and resolves matching header package (`linux-headers`, `linux-zen-headers`, etc.).
- **Dry-Run by Default**: Runs in safe `--dry-run` mode by default to preview commands before making system changes.
- **DKMS Support**: Installs `virtualbox-host-dkms` and loads the `vboxdrv` module seamlessly.
- **Boot Persistence**: Writes configuration to `/etc/modules-load.d/virtualbox.conf` for automatic module loading across reboots.
- **Group Management**: Automatically adds your user to the `vboxusers` group and applies group membership (`newgrp vboxusers`) without requiring a full logout/reboot.
- **Safety Checks**: Blocks direct execution via `sudo ./install_virtualbox.sh` to prevent root environment pollution.

---

## 📋 Prerequisites

- **OS**: Arch Linux (or Arch-based distribution using `pacman`).
- **Permissions**: Standard user with `sudo` privileges.

---

### ⚡ Perform Full Installation
```bash
 git clone https://github.com/SilverCipherr/vmscript.git && cd vmscript && ./install_virtualbox.sh --real
```

### 🔍 Dry-Run Mode (Preview Only)
```bash
 git clone https://github.com/SilverCipherr/vmscript.git && cd vmscript && ./install_virtualbox.sh --dry-run
```

> ⚠️ **Note**: Do **not** run with `sudo` directly (`sudo git ...`). The script will prompt for `sudo` authorization when needed to preserve `$USER` environment variables properly.

---

## 🛠️ How It Works

1. **Kernel Header Resolution**:
   ```bash
   KERNEL -> HEADER_PKG
   linux-zen      -> linux-zen-headers
   linux-lts      -> linux-lts-headers
   linux-hardened -> linux-hardened-headers
   linux-rt       -> linux-rt-headers
   linux          -> linux-headers
   ```

2. **Package Installation**:
   ```bash
   sudo pacman -Syyu --needed --noconfirm dkms <HEADER_PKG> virtualbox virtualbox-host-dkms
   ```

3. **Module Loading & Boot Persistence**:
   ```bash
   sudo modprobe vboxdrv
   echo "vboxdrv" | sudo tee /etc/modules-load.d/virtualbox.conf
   ```

4. **Group Assignment & Session Activation**:
   ```bash
   sudo gpasswd -a $USER vboxusers
   exec newgrp vboxusers
   ```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE.md).
