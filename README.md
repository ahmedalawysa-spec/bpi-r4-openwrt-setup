# 📡 Banana Pi BPI-R4 Setup Script

## 📋 Description
This repository contains an automated setup script for **Banana Pi BPI-R4** running OpenWrt with **Quectel RM551E-GL modem**. The script streamlines the installation process by automatically installing essential packages, adding custom repositories, importing public keys, and restoring modem settings.

All temporary files are stored in `/tmp/bpi_r4_setup/` during the process to maintain system cleanliness.

---

## 📂 Repository Contents

| File | Description |
|------|-------------|
| `setup_bpi.sh` | Main automated setup script for installing packages and restoring modem settings |
| `rm551e_modem_config.tar.gz` | Custom modem configuration and settings to be restored by the script |
| `ipk/` | Directory containing all required `.ipk` packages for the setup |

---

## 🚀 Quick Start

### Prerequisites
- Banana Pi BPI-R4 running OpenWrt with Opkg
- **Quectel RM551E-GL modem** installed
- Active internet connection
- Terminal or SSH access

### Installation Methods

Choose one of the following installation methods:

---

#### 🔧 Option 1: Step-by-Step Installation
*Recommended for beginners or if you want to see each step*

**Step 1: Create directory and download script**
```bash
mkdir -p /tmp/bpi_r4_setup
wget -O /tmp/bpi_r4_setup/setup_bpi.sh https://raw.githubusercontent.com/ahmedalawysa-spec/bpi-r4-openwrt-setup/refs/heads/main/files/setup_bpi.sh
```

**Step 2: Make script executable**
```bash
chmod +x /tmp/bpi_r4_setup/setup_bpi.sh
```

**Step 3: Run the setup script**
```bash
/tmp/bpi_r4_setup/setup_bpi.sh
```

---

#### ⚡ Option 2: One-Line Installation
*Quick installation with a single command*

```bash
mkdir -p /tmp/bpi_r4_setup && wget -O /tmp/bpi_r4_setup/setup_bpi.sh https://raw.githubusercontent.com/ahmedalawysa-spec/bpi-r4-openwrt-setup/refs/heads/main/files/setup_bpi.sh && chmod +x /tmp/bpi_r4_setup/setup_bpi.sh && /tmp/bpi_r4_setup/setup_bpi.sh
```

---

**📝 Note:** Both methods do exactly the same thing. The script will automatically handle cleanup and configuration.

---

## ⚙️ What the Script Does

The automated setup script performs the following operations:

- ✅ **System Check**: Verifies requirements and internet connectivity
- ✅ **Repository Setup**: Adds custom repositories with security keys (IceG, Fantastic Packages)
- ✅ **Package Management**: Updates package lists and installs core utilities
- ✅ **Essential Installations**: Installs LuCI apps, modem tools, and system monitoring utilities
- ✅ **Custom Packages**: Downloads and installs specialized packages including:
  - 🎨 **UI Themes (5 themes)**: Alpha4, Aurora, Carbon PX, Pedit X, Argon with config
  - 🔥 **Quectel Firehose**: QFirehose packages for RM551E-GL firmware updates  
  - 📡 **Modem Packages (6 packages)**: Tools for frequency band control, tower monitoring, and signal analysis
- ✅ **Configuration Restore**: Restores optimized RM551E-GL modem configuration

---

## 📌 Important Notes

- ⚠️ This repository does **not** include the iamromulan repo
- 🔧 Designed specifically for Banana Pi BPI-R4 with **Quectel RM551E-GL modem**
- 🌐 Ensure your board has an active internet connection during setup
- 📄 Detailed logs saved to `/tmp/bpi_setup.log` for troubleshooting
- 🗂️ All temporary files are automatically cleaned up after installation

---

## 👨‍💻 Author & License

**Owner:** VNI  
**GitHub:** [github.com/ahmedalawysa-spec](https://github.com/ahmedalawysa-spec)  
**License:** © 2025 VNI X. All rights reserved.

---

## 🆘 Support

If you encounter any issues or need assistance, please:
1. Check that all prerequisites are met
2. Ensure stable internet connection  
3. Review the detailed logs in `/tmp/bpi_r4_setup.log`
4. Create an issue on the GitHub repository

---

*Made with ❤️ for the Banana Pi community*