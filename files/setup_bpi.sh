#!/bin/sh

# ========================================
# Banana Pi BPI-R4 Setup Script (Enhanced)
# For Quectel RM551E-GL Modem
# Version: 2.0
# Author: VNI
# ========================================

# === Color Codes for Output ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === Variables ===
TMP_DIR="/tmp/bpi_r4_setup"
IPK_DIR="$TMP_DIR/downloads/ipk"
MODEM_DIR="$TMP_DIR/downloads/modem-config"
LOG_FILE="/tmp/bpi_r4_setup.log"
REPO_RAW="https://raw.githubusercontent.com/ahmedalawysa-spec/bpi-r4-openwrt-setup/refs/heads/main/files/ipk"
MODEM_CONFIG_URL="https://raw.githubusercontent.com/ahmedalawysa-spec/bpi-r4-openwrt-setup/refs/heads/main/files/modem-config"
SCRIPT_VERSION="2.0"
TOTAL_STEPS=6
CURRENT_STEP=0

# بدء حساب الوقت
START_TIME=$(date +%s)

# === Functions ===

# Print colored output
print_status() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local status_icon=""
    local log_prefix=""
    
    case $1 in
        "info")    
            echo -e "${BLUE}ℹ️  $2${NC}"
            status_icon="[INFO]"
            log_prefix="┌─ INFO"
            ;;
        "success") 
            echo -e "${GREEN}✅ $2${NC}"
            status_icon="[SUCCESS]"
            log_prefix="┌─ SUCCESS"
            ;;
        "warning") 
            echo -e "${YELLOW}⚠️  $2${NC}"
            status_icon="[WARNING]"
            log_prefix="┌─ WARNING"
            ;;
        "error")   
            echo -e "${RED}❌ $2${NC}"
            status_icon="[ERROR]"
            log_prefix="┌─ ERROR"
            ;;
        "step")    
            echo -e "${CYAN}🔄 [$3/$TOTAL_STEPS] $2${NC}"
            status_icon="[STEP $3/$TOTAL_STEPS]"
            log_prefix="╔═ STEP $3/$TOTAL_STEPS"
            ;;
    esac
    
    # كتابة اللوج بتنسيق خرافي
    echo "╭────────────────────────────────────────────────────────────────╮" >> "$LOG_FILE"
    echo "│ $log_prefix" >> "$LOG_FILE"
    echo "│ Time: $timestamp" >> "$LOG_FILE"
    echo "│ Message: $2" >> "$LOG_FILE"
    echo "╰────────────────────────────────────────────────────────────────╯" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

# Progress indicator
next_step() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    print_status "step" "$1" "$CURRENT_STEP"
}

# Error handling function
handle_error() {
    print_status "error" "$1"
    print_status "error" "Check log file: $LOG_FILE"
    
    # إضافة error footer للوج
    cat >> "$LOG_FILE" << EOF

╔══════════════════════════════════════════════════════════════════════════════╗
║                            ❌ SETUP FAILED ❌                               ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ ⚠️  Setup process terminated due to error                                   ║
║ 📅 Failed at: $(date '+%Y-%m-%d %H:%M:%S')                                            ║
║                                                                              ║
║ 🔍 Troubleshooting:                                                         ║
║    • Check internet connection                                              ║
║    • Verify sufficient disk space                                           ║
║    • Review error messages above                                            ║
║                                                                              ║
║ 🔗 Support: github.com/ahmedalawysa-spec/bpi-r4-openwrt-setup              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    
    rm -rf "$TMP_DIR" 2>/dev/null
    exit 1
}

# Cleanup function
cleanup() {
    if [ "$1" != "keep" ]; then
        print_status "info" "Cleaning up temporary files..."
        rm -rf "$TMP_DIR"
    fi
}

# Check system requirements
check_requirements() {
    # فحص المساحة المتاحة (على الأقل 100 ميجابايت)
    AVAILABLE_SPACE=$(df /tmp | awk 'NR==2 {print $4}')
    if [ "$AVAILABLE_SPACE" -lt 100000 ]; then
        handle_error "Insufficient space in /tmp. At least 100MB required"
    fi
    
    # فحص الاتصال بالإنترنت
    if ! ping -c 1 github.com >/dev/null 2>&1; then
        handle_error "No internet connection available"
    fi
    
    # فحص وجود opkg
    if ! command -v opkg >/dev/null 2>&1; then
        handle_error "opkg not found. Make sure system supports OpenWrt"
    fi
    
    print_status "success" "All requirements satisfied"
}

# Download file with verification
download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    
    if wget -q --timeout=30 --tries=3 -O "$output" "$url" 2>>"$LOG_FILE"; then
        # التحقق من أن الملف تم تحميله وليس فارغ
        if [ -f "$output" ] && [ -s "$output" ]; then
            return 0
        else
            handle_error "Downloaded file is empty or corrupted: $description"
        fi
    else
        handle_error "Failed to download $description from $url"
    fi
}

# Install package with verification
install_package() {
    local package="$1"
    local description="$2"
    
    if opkg install "$package" >>"$LOG_FILE" 2>&1; then
        return 0
    else
        return 1
    fi
}

# تنظيف عند الخروج أو المقاطعة (بدون رسالة)
trap 'rm -rf "$TMP_DIR" 2>/dev/null' EXIT INT TERM

# === Main Script ===

# Print header
echo -e "${CYAN}"
echo "======================================================="
echo "   📡 Banana Pi BPI-R4 Setup Script v$SCRIPT_VERSION"
echo "      For Quectel RM551E-GL Modem"
echo "======================================================="
echo -e "${BLUE}🏗️  Author: VNI${NC}"
echo -e "${BLUE}🌍 GitHub: github.com/ahmedalawysa-spec/bpi-r4-openwrt-setup${NC}"
echo -e "${CYAN}=======================================================${NC}"
echo ""

# إنشاء المجلدات المؤقتة وملف السجل
mkdir -p "$IPK_DIR" "$MODEM_DIR" || handle_error "Failed to create temporary directories"

# إنشاء ملف اللوج مع header خرافي
cat > "$LOG_FILE" << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    📡 BANANA PI BPI-R4 SETUP SCRIPT LOG 📡                  ║
║                        For Quectel RM551E-GL Modem                          ║
║                              Version 2.0                                    ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ 📅 Started: $(date '+%Y-%m-%d %H:%M:%S')                                              ║
║ 🏗️  Author: VNI                                                             ║
║ 🌍 GitHub: github.com/ahmedalawysa-spec/bpi-r4-openwrt-setup               ║
║ 📂 Workspace: /tmp/bpi_r4_setup                                             ║
║ 📋 Log File: /tmp/bpi_r4_setup.log                                          ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF

print_status "info" "Starting setup process..."
print_status "info" "Log file: $LOG_FILE"

# Step 1: Check system requirements
next_step "Checking system requirements"
check_requirements

# Step 2: Add Repositories and Keys
next_step "Setting up custom repositories"

# إضافة مستودع IceG
if ! grep -q "IceG_repo" /etc/opkg/customfeeds.conf 2>/dev/null; then
    echo 'src/gz IceG_repo https://github.com/4IceG/Modem-extras/raw/main/myrepo' >> /etc/opkg/customfeeds.conf
fi

# إضافة مستودعات Fantastic Packages
if ! grep -q "fantastic_packages_luci" /etc/opkg/customfeeds.conf 2>/dev/null; then
    cat << "EOF" >> /etc/opkg/customfeeds.conf
src/gz fantastic_packages_luci     https://fantastic-packages.github.io/releases/24.10/packages/aarch64_cortex-a53/luci
src/gz fantastic_packages_packages https://fantastic-packages.github.io/releases/24.10/packages/aarch64_cortex-a53/packages
src/gz fantastic_packages_special  https://fantastic-packages.github.io/releases/24.10/packages/aarch64_cortex-a53/special
EOF
fi

mkdir -p /etc/opkg/keys 2>/dev/null

download_file "https://github.com/4IceG/Modem-extras/raw/main/myrepo/IceG-repo.pub" \
              "/etc/opkg/keys/d5c31f428b01f2e9" \
              "IceG public key" >/dev/null 2>&1

download_file "https://fantastic-packages.github.io/releases/24.10/53ff2b6672243d28.pub" \
              "/etc/opkg/keys/53ff2b6672243d28" \
              "Fantastic Packages public key" >/dev/null 2>&1
print_status "success" "All repositories and keys configured successfully"

# Step 3: Update package lists
next_step "Updating package lists"
if opkg update >>"$LOG_FILE" 2>&1; then
    print_status "success" "Package lists updated successfully"
else
    handle_error "Failed to update package lists"
fi

# Step 4: Install core packages
next_step "Installing core packages"

CORE_PACKAGES="luci-app-sms-tool-js luci-app-at-socat luci-app-tinyfilemanager luci-app-ipinfo luci-app-cpu-perf luci-app-cpu-status luci-app-interfaces-statistics luci-app-log-viewer luci-app-temp-status"

for package in $CORE_PACKAGES; do
    install_package "$package" "$package" >/dev/null 2>&1
done
print_status "success" "All core packages (9 packages) installed successfully"

# Step 5: Install custom IPK packages
next_step "Installing custom IPK packages"

# تثبيت QFirehose
download_file "$REPO_RAW/qfirehose_1.5.1-r1_aarch64_cortex-a53.ipk" \
              "$IPK_DIR/qfirehose_1.5.1-r1_aarch64_cortex-a53.ipk" \
              "QFirehose" >/dev/null 2>&1
install_package "$IPK_DIR/qfirehose_1.5.1-r1_aarch64_cortex-a53.ipk" "QFirehose" >/dev/null 2>&1

download_file "$REPO_RAW/luci-app-qfirehose_1.0.0-r1_all.ipk" \
              "$IPK_DIR/luci-app-qfirehose_1.0.0-r1_all.ipk" \
              "LuCI QFirehose" >/dev/null 2>&1
install_package "$IPK_DIR/luci-app-qfirehose_1.0.0-r1_all.ipk" "LuCI QFirehose" >/dev/null 2>&1

# تثبيت باقي حزم المودم
MOD_PKG_LIST="luci-app-modemdata_1.0.15-r20250919_all.ipk modemdata_20250919-r1_all.ipk luci-app-modemband_1.0.29-r20250919_all.ipk modemband_20250409_all.ipk"

for pkg in $MOD_PKG_LIST; do
    download_file "$REPO_RAW/$pkg" "$IPK_DIR/$pkg" "$pkg" >/dev/null 2>&1
    install_package "$IPK_DIR/$pkg" "$pkg" >/dev/null 2>&1
done
print_status "success" "All modem packages (6 packages) installed successfully"

# تثبيت الثيمات
THEME_LIST="luci-theme-alpha4_4.0.1-beta-12_all.ipk luci-theme-aurora_0.4.0_alpha-r20250919_all.ipk luci-theme-carbonpx_1.0.4-01_all.ipk luci-theme-peditx_1.2.3-01_all.ipk"

for pkg in $THEME_LIST; do
    download_file "$REPO_RAW/$pkg" "$IPK_DIR/$pkg" "$pkg" >/dev/null 2>&1
    install_package "$IPK_DIR/$pkg" "$pkg" >/dev/null 2>&1
done

# إضافة ثيم Argon والإعدادات
download_file "$REPO_RAW/luci-theme-argon_2.4.2-r20250207_all.ipk" \
              "$IPK_DIR/luci-theme-argon_2.4.2-r20250207_all.ipk" \
              "Argon Theme" >/dev/null 2>&1
install_package "$IPK_DIR/luci-theme-argon_2.4.2-r20250207_all.ipk" "Argon Theme" >/dev/null 2>&1

download_file "$REPO_RAW/luci-app-argon-config_1.0-r20230608_all.ipk" \
              "$IPK_DIR/luci-app-argon-config_1.0-r20230608_all.ipk" \
              "Argon Config" >/dev/null 2>&1
install_package "$IPK_DIR/luci-app-argon-config_1.0-r20230608_all.ipk" "Argon Config" >/dev/null 2>&1

print_status "success" "All UI themes (5 themes) installed successfully"

# Step 6: Restore modem backup
next_step "Restoring custom modem configuration"

download_file "$MODEM_CONFIG_URL/rm551e_modem_config.tar.gz" \
              "$MODEM_DIR/rm551e_modem_config.tar.gz" \
              "custom modem configuration" >/dev/null 2>&1

if [ -f "$MODEM_DIR/rm551e_modem_config.tar.gz" ]; then
    if tar xzf "$MODEM_DIR/rm551e_modem_config.tar.gz" -C / 2>>"$LOG_FILE"; then
        print_status "success" "Custom modem configuration restored successfully"
    else
        print_status "warning" "Failed to restore custom modem configuration"
    fi
fi

# Final message
echo ""
echo -e "${GREEN}=======================================================${NC}"
echo -e "${GREEN}       🎉 Setup completed successfully! 🎉${NC}"
echo -e "${GREEN}=======================================================${NC}"
echo ""

# حساب وعرض الوقت المستغرق
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

print_status "success" "All steps completed successfully"
print_status "info" "You can now reboot the system to apply all changes"
print_status "info" "Log file saved at: $LOG_FILE"

if [ $MINUTES -gt 0 ]; then
    print_status "info" "Total execution time: ${MINUTES}m ${SECONDS}s"
else
    print_status "info" "Total execution time: ${SECONDS}s"
fi

# إضافة footer للوج
cat >> "$LOG_FILE" << EOF

╔══════════════════════════════════════════════════════════════════════════════╗
║                           🎉 SETUP COMPLETED SUCCESSFULLY 🎉                ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ ✅ All packages installed successfully                                       ║
║ ✅ Custom modem configuration restored                                       ║
║ ✅ Themes and tools ready                                                    ║
║ 📅 Finished: $(date '+%Y-%m-%d %H:%M:%S')                                             ║
║ ⏱️  Duration: ${MINUTES}m ${SECONDS}s                                        ║
║                                                                              ║
║ 💡 Next Steps:                                                              ║
║    • Reboot the system to apply all changes                                 ║
║    • Access LuCI interface to configure                                     ║
║    • Check modem functionality                                              ║
║                                                                              ║
║ 🔗 Support: github.com/ahmedalawysa-spec/bpi-r4-openwrt-setup              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF

# حذف مجلد الإعداد مع الاحتفاظ باللوج (بدون رسالة)
rm -rf "$TMP_DIR" 2>/dev/null

echo ""
echo -e "${YELLOW}=== 💡 Important tips ===${NC}"
echo -e "${YELLOW}•${NC} Reboot the system to apply all changes"
echo -e "${YELLOW}•${NC} Check modem functionality through LuCI interface"
echo -e "${YELLOW}•${NC} You can change theme from System → System"
echo ""
echo -e "${CYAN}=== 📁 Files management ===${NC}"
echo -e "${CYAN}•${NC} Log file: $LOG_FILE (saved)"
echo -e "${CYAN}•${NC} Setup files cleaned up automatically"
echo -e "${CYAN}•${NC} For complete details, check the log file"
echo -e "${CYAN}•${NC} Note: /tmp files are deleted after reboot"

exit 0