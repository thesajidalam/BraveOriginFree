<div align="center">

# Brave Origin Free for Windows

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6.svg)]()
[![Brave Origin](https://img.shields.io/badge/Brave%20Origin-Latest-FB542B.svg)](https://github.com/brave/brave-browser/releases)
[![GitHub stars](https://img.shields.io/github/stars/thesajidalam/BraveOriginFree?style=social)](https://github.com/thesajidalam/BraveOriginFree/stargazers)
[![GitHub release](https://img.shields.io/github/v/release/thesajidalam/BraveOriginFree)](https://github.com/thesajidalam/BraveOriginFree/releases)

**Brave Origin costs $60 on Windows. On Linux it's free. This fixes that.**

[Download Latest](https://github.com/thesajidalam/BraveOriginFree/releases/latest) • [Live Demo](https://braveorigin.vercel.app) • [Report Bug](https://github.com/thesajidalam/BraveOriginFree/issues/new?template=bug_report.yml) • [Request Feature](https://github.com/thesajidalam/BraveOriginFree/issues/new?template=feature_request.yml)

</div>

---

## ✨ What's New in Latest Version

- ⚡ **Faster Launch** - `Launch.bat` for instant startup with no menu delays
- 🚀 **Improved run.bat** - Optimized for quicker browser launch
- 🌐 **Set as Default Browser** - New `MakeDefault.bat` + `make-default.ps1` to register Brave Origin as your default browser (works without admin)
- 📦 **Auto-Install Flow** - Smarter installer that launches automatically if not installed
- 📝 **Better Documentation** - Added Contributing, Code of Conduct, and Changelog

---

## 📖 About

Brave Origin is a stripped-down version of Brave — same privacy, same Shields, same speed — but without Rewards, Wallet, Leo AI, News, VPN, Tor, or telemetry. It's the browser you want when you want Brave's core without the extras.

On Linux, it's free. On Windows, Brave charges $60. This project removes that paywall by applying the same local activation configuration used by the Linux version. **No cracks. No modified binaries. Just configuration.**

---

## 🚀 Quick Start

### Installation (First Time)
1. [Download the latest release](https://github.com/thesajidalam/BraveOriginFree/releases/latest) or clone this repo
2. Extract the folder to any location (Works on USB drives too!)
3. Double-click `install.bat`
4. Done! A desktop shortcut will be created

### Launching
- **Instant Launch:** Double-click `Launch.bat` (Recommended)
- **Standard Launch:** Double-click `run.bat`
- **Desktop Shortcut:** Use "Brave Origin (Free)" shortcut

### Make it Default Browser
1. Run `MakeDefault.bat`
2. Follow the prompts
3. Also set via `Windows Settings → Apps → Default apps → Brave Origin Free` if needed

---

## 🔧 Features

| Feature | Status |
| --- | --- |
| Brave Shields | ✅ Enabled |
| Bookmarks & History | ✅ Enabled |
| Privacy Protection | ✅ Enabled |
| Rewards, Wallet, Leo AI | ❌ Disabled |
| Brave News, Talk, VPN, Tor | ❌ Disabled |
| P3A, Ads Telemetry | ❌ Disabled |
| Portable (No Installation) | ✅ Yes |
| No Admin Rights Required | ✅ Yes |
| Auto-Updates Support | ✅ Yes |
| Works from USB Drive | ✅ Yes |

---

## 🛠️ How It Works

Brave Origin reads activation from `Local State`. This project writes the same values used on Linux:
```json
{"brave":{"origin":{"purchase_validated":true}},"skus":{"state":{"67":"{\"credentials\":{\"items\":{\"6\":\"7\"}}}"}}}
```
The check is entirely local — no Brave servers contacted for validation.

---

## 📂 Project Structure

```
BraveOriginFree/
├── install.bat      # First-time installer
├── run.bat          # Standard launcher (optimized)
├── Launch.bat       # Instant launcher
├── MakeDefault.bat  # Set as default browser
├── make-default.ps1 # Default browser registration
├── src/
│   ├── bypass.ps1   # Standalone patcher
│   └── update.ps1   # Update checker
└── README.md
```

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

- [Report a Bug](https://github.com/thesajidalam/BraveOriginFree/issues/new?template=bug_report.yml)
- [Request a Feature](https://github.com/thesajidalam/BraveOriginFree/issues/new?template=feature_request.yml)
- [Submit a Pull Request](https://github.com/thesajidalam/BraveOriginFree/pulls)

---

## 📜 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

**Disclaimer:** This project is for educational purposes. Brave Origin is a product of [Brave Software](https://brave.com). We use only official signed builds from Brave's GitHub releases.
