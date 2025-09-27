# 📡 OpenWrt 24.10.3 Firmware Images for Banana Pi BPI-R4

## 🔋 Firmware Description
This directory contains **OpenWrt 24.10.3** firmware images specifically for **Banana Pi BPI-R4** with **Quectel RM551E-GL modem** support. These are the **exact firmware images used and tested** with the automated setup script in this repository.

**Important:** These images include **many helpful packages** and ensure **modem detection and drivers** work perfectly with the setup script.

---

## 📦 Available Images

### 💾 SD Card Image (Fresh Installation)
**File:** `openwrt-24.10.3-d91500f2a086-mediatek-filogic-bananapi_bpi-r4-sdcard.img`
- **Purpose:** **Fresh installation** - Complete format and new setup
- **Use Case:** Clean installation on SD card or when you want to **format everything**
- **Target:** New installations or complete system rebuild
- **Installation:** Flash directly to SD card

### ⬆️ Sysupgrade Image (Updates)
**File:** `openwrt-24.10.3-d91500f2a086-mediatek-filogic-bananapi_bpi-r4-squashfs-sysupgrade`
- **Purpose:** **Update from within OpenWrt** - Preserves settings and data
- **Use Case:** When you want to **update existing OpenWrt** without losing configuration
- **Target:** System updates while keeping your current settings
- **Installation:** Upload via LuCI or command line

---

## 🚀 Quick Installation Guide

### SD Card Installation (Fresh Setup)


### Sysupgrade Installation (Updates)

**Via LuCI Web Interface:**
1. Access LuCI at `http://192.168.1.1`
2. Go to **System → Backup/Flash Firmware**
3. Upload `openwrt-24.10.3-d91500f2a086-mediatek-filogic-bananapi_bpi-r4-squashfs-sysupgrade`
4. **Check "Keep settings"** if you want to preserve configuration
5. Click **Flash image**

## 🔧 Firmware Features

### 🎯 Setup Script Compatibility
- ✅ **Tested and validated** with the automated setup script
- ✅ **Modem detection guaranteed** - RM551E-GL works out of the box
- ✅ **Pre-configured drivers** for optimal modem performance
- ✅ **Many helpful packages** already included for enhanced functionality

### Built-in Support
- ✅ **Quectel RM551E-GL modem** drivers and utilities
- ✅ **5G/4G/3G connectivity** with carrier aggregation
- ✅ **MediaTek MT7988A** SoC optimizations
- ✅ **Dual 10Gb Ethernet** ports
- ✅ **Wi-Fi 7 (802.11be)** support
- ✅ **USB 3.0** and **M.2** slots
- ✅ **Hardware NAT** acceleration

### Pre-installed Packages
- **LuCI web interface** with modern themes
- **OpenSSH** server and client
- **DHCP server** and **DNS resolver**
- **Firewall** with IPv4/IPv6 support
- **QoS** and **traffic shaping**
- **VPN support** (OpenVPN, WireGuard ready)
- **Modem management tools** and utilities

---

## 🛠️ Post-Installation Setup

### 1. First Boot Configuration
```bash
# Connect via Ethernet to LAN port
# Default IP: 192.168.1.1
# Default user: root (no password initially)

# Set root password
passwd

# Update package lists
opkg update
```

### 2. Run the Setup Script (Recommended)
After installing this firmware, run the automated setup script for **enhanced functionality**:

```bash
# Download and run the enhancement script
mkdir -p /tmp/bpi_setup
wget -O /tmp/bpi_setup/setup_bpi.sh https://raw.githubusercontent.com/[username]/bpi-setup/main/setup_bpi.sh
chmod +x /tmp/bpi_setup/setup_bpi.sh
/tmp/bpi_setup/setup_bpi.sh
```

**The script will add:**
- Additional UI themes and customizations
- Advanced modem monitoring tools
- Frequency band control utilities
- System performance enhancements

### 3. Modem Configuration
After running the setup script, the **RM551E-GL modem** will be automatically configured with:
- Optimized frequency bands for your region
- APN settings and carrier configurations
- ECM integration
- LuCI apps for modem monitoring and control

---

## 📋 Technical Specifications

| Component | Details |
|-----------|---------|
| **OpenWrt Version** | 24.10.3 (Stable) |
| **Kernel Version** | Linux 6.6.x |
| **Target** | mediatek/filogic |
| **Device Profile** | bananapi_bpi-r4 |
| **Architecture** | aarch64_cortex-a53 |
| **Flash Layout** | SD card support |
| **Memory Support** | Up to 4GB RAM |

---

## 🔐 Security & Verification

### File Integrity
```bash
# Verify checksums (files include SHA256 hashes)
sha256sum -c sha256sums.txt

# GPG signature verification (if available)
gpg --verify sha256sums.txt.asc sha256sums.txt
```

### Default Security
- **Root access** via SSH (secure after password set)
- **Firewall enabled** by default
- **WPS disabled** for security
- **Strong encryption** for wireless
- **Automatic security updates** available

---

## 🆘 Troubleshooting

### Common Issues

**Boot Problems:**
- Ensure SD card is properly flashed
- Check boot switches on BPI-R4
- Verify power supply (5V/3A minimum)

**Network Issues:**
- Reset network settings: `firstboot && reboot`
- Check Ethernet cable and port
- Verify DHCP client on your device

**Modem Issues:**
- Run the setup script if modem not detected
- Check SIM card insertion and PIN
- Verify antenna connections

---

## 🔄 Update Path

### Keeping Firmware Updated
1. **Check releases** in this repository regularly
2. **Use sysupgrade images** for seamless updates
3. **Backup settings** before major updates
4. **Re-run setup script** after updates if needed

### Version History
- **v24.10.3:** Current stable release with RM551E-GL support
- **v24.10.2:** Previous release (upgrade recommended)
- **v24.10.1:** Initial 24.x series release

---

## 📞 Support & Community

### Getting Help
- **Repository Issues:** [Create an issue](https://github.com/[username]/bpi-setup/issues)
- **OpenWrt Forum:** [BPI-R4 discussions](https://forum.openwrt.org)
- **Documentation:** Check `/docs` folder in this repository

### Contributing
- Report bugs and compatibility issues
- Share configuration improvements
- Submit patches for hardware support
- Help with documentation and translations

---

## ⚠️ Important Notes

- **Compatible only** with Banana Pi BPI-R4 hardware
- **Tested specifically** with Quectel RM551E-GL modem
- **Backup your current firmware** before flashing
- **Settings may be lost** during firmware updates
- **Use appropriate installation method** for your scenario

---

## 📄 License & Credits

**Firmware:** OpenWrt Project (GPL v2)  
**Customizations:** VNI (© 2025)  
**Hardware:** Banana Pi Foundation  
**Modem Support:** Quectel Wireless Solutions

*Built with ❤️ for the OpenWrt and Banana Pi communities*

---

**Last Updated:** January 2025  
**Firmware Build Date:** Check individual file timestamps
