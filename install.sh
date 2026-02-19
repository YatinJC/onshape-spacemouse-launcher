#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check dependencies
for cmd in uvx spacenavd; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# Install launcher script
install -Dm755 "$SCRIPT_DIR/onshape-launch" "$HOME/.local/bin/onshape-launch"

# Install icon
install -Dm644 "$SCRIPT_DIR/onshape.png" "$HOME/.local/share/icons/onshape.png"

# Install desktop entry (expand $HOME)
sed "s|\$HOME|$HOME|g" "$SCRIPT_DIR/onshape.desktop" > "$HOME/.local/share/applications/onshape.desktop"
chmod 644 "$HOME/.local/share/applications/onshape.desktop"

# Install systemd loopback service
echo "Installing systemd service (requires sudo)..."
sudo install -Dm644 "$SCRIPT_DIR/spacenav-loopback.service" /etc/systemd/system/spacenav-loopback.service
sudo systemctl daemon-reload
sudo systemctl enable --now spacenav-loopback.service

echo ""
echo "Installed! Before first use:"
echo "  1. Install Tampermonkey or Violentmonkey in your browser"
echo "  2. Install the userscript: https://greasyfork.org/en/scripts/533516"
echo "  3. Run 'onshape-launch' or find Onshape in your app launcher"
echo "  4. On first run, open https://127.51.68.120:8181 and accept the certificate"
