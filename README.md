# Onshape SpaceMouse Launcher for Linux

One-click desktop launcher for [Onshape](https://cad.onshape.com) with [SpaceMouse](https://3dconnexion.com) support on Linux, using [spacenav-ws](https://github.com/RmStorm/spacenav-ws) and [spacenavd](https://github.com/FreeSpacenav/spacenavd).

## Prerequisites

- [spacenavd](https://github.com/FreeSpacenav/spacenavd) and libspnav installed and running
- [uv](https://github.com/astral-sh/uv) (provides `uvx`)
- Firefox with [Tampermonkey](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/) or [Violentmonkey](https://addons.mozilla.org/en-US/firefox/addon/violentmonkey/)
- The [Onshape 3D-Mouse on Linux](https://greasyfork.org/en/scripts/533516-onshape-3d-mouse-on-linux-in-page-patch) userscript

### Arch / CachyOS

```bash
sudo pacman -S spacenavd libspnav spnavcfg
sudo systemctl enable --now spacenavd
```

## Install

```bash
git clone https://github.com/YatinJC/onshape-spacemouse-launcher.git
cd onshape-spacemouse-launcher
chmod +x install.sh
./install.sh
```

The install script will:
- Place the launcher script in `~/.local/bin/`
- Add a desktop entry with the Onshape icon to your app launcher
- Create a systemd service to set up the required loopback alias (`127.51.68.120`) at boot

## First Run

1. Open https://127.51.68.120:8181 in Firefox and accept the self-signed certificate
2. Launch Onshape from your app menu (or run `onshape-launch`)
3. Open a document and move your SpaceMouse

## How It Works

Onshape expects the 3Dconnexion driver at `127.51.68.120:8181`. On Windows/macOS, the proprietary driver handles this. On Linux, this launcher:

1. **spacenav-loopback.service** adds `127.51.68.120` as a loopback alias at boot
2. **onshape-launch** starts the [spacenav-ws](https://github.com/RmStorm/spacenav-ws) WebSocket bridge (which reads from spacenavd and serves the 3Dconnexion protocol) then opens Onshape in Firefox
3. The **userscript** patches Onshape's platform detection so it attempts to connect to the driver

## Uninstall

```bash
rm ~/.local/bin/onshape-launch
rm ~/.local/share/applications/onshape.desktop
rm ~/.local/share/icons/onshape.png
sudo systemctl disable --now spacenav-loopback.service
sudo rm /etc/systemd/system/spacenav-loopback.service
```
