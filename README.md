# Brave Origin For Windows Free
# Brave Origin Free Download 
# Brave Origin
# Brave Origin Free
**Brave Origin costs $60 on Windows. On Linux it's free. This fixes that.**

[![Version](https://img.shields.io/badge/Brave_Origin-1.91.175-blue)](https://github.com/brave/brave-browser/releases)
[![Platform](https://img.shields.io/badge/Windows-10_11-green)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()

---

## What is this?

Brave Origin is a stripped-down version of Brave — same privacy, same Shields, same speed — but without Rewards, Wallet, AI, News, VPN, Tor, or telemetry. It's the browser you get when you want Brave's core without the extras.

On Linux, it's free. On Windows, Brave charges $60.

This project removes that paywall by doing exactly what the Linux version does — setting a configuration flag that tells the browser it's activated. No cracks. No modified binaries. Just a configuration that Brave themselves allow on other platforms.

---

## What you get

- **Brave Origin** — the official signed build from Brave, untouched and verified
- **Purchase bypass** — the same activation the Linux version uses
- **All bloat removed** — Rewards, Wallet, Leo AI, News, VPN, Tor, P3A all disabled
- **Zero installation** — runs from any folder, USB drive, anywhere
- **No admin rights** — works in user space, no registry changes
- **Auto-updates** — check for new versions with `src\update.ps1`

---

## How to use

### The 2-minute install

```batch
1. Download this repo (Code → Download ZIP, or clone it)
2. Extract the folder
3. Double-click install.bat
4. Done.
```

That's it. `install.bat` will:
- Download the latest Brave Origin from GitHub (~150 MB)
- Apply the free activation bypass
- Put a shortcut on your desktop
- Launch your new browser

### If you already ran install.bat

Just double-click `run.bat` any time to start the browser.

---

## How the bypass works

Brave Origin reads its activation state from a file called `Local State`. When you click "Proceed with Origin for free" on Linux, Brave writes two things:

```
purchase_validated = true
SKU credential = injected
```

This project writes those same values into `Local State` *before* the browser ever starts. Windows Origin sees them, thinks it's been purchased, and unlocks completely.

The browser checks this file on every launch. It does not contact Brave's servers for license validation. The entire check is local.

---

## What's disabled

Brave Origin is supposed to be minimal. This configuration makes sure none of the extras sneak through:

| Feature | Status |
|---------|--------|
| Brave Shields | ON |
| Bookmarks / History | ON |
| Password Manager | ON |
| Chrome Extensions | ON |
| Developer Tools | ON |
| Brave Rewards | OFF |
| Brave Wallet | OFF |
| Leo AI | OFF |
| Brave News | OFF |
| Brave Talk | OFF |
| Brave VPN | OFF |
| Brave Tor | OFF |
| Telemetry (P3A) | OFF |
| Background updates | OFF |
| Component updates | OFF |
| Sync | OFF |

Everything that's OFF is handled by CLI flags passed to the browser — same flags that Brave's Linux Origin build has compiled out by default.

#T.ME Link 🔗:
https://t.me/braveorigin/
---

## Requirements

- Windows 10 or 11
- 64-bit processor
- 2 GB RAM
- 500 MB free disk space
- Internet connection (for the initial download)

That's it. No .NET, no runtime, no dependencies.

---

## Project structure

```
BraveOriginFree/
├── install.bat          # One-click installer (downloads + sets up everything)
├── run.bat              # Launch the browser
├── src/
│   ├── bypass.ps1       # Patch any existing Brave Origin install
│   └── update.ps1       # Check for and apply updates
├── config/
│   └── policies.json    # Enterprise policies (disables all extras)
├── profile/
│   └── Local State      # Pre-seeded activation file
├── bin/                 # Brave Origin binary (auto-downloaded)
└── data/                # Your browser profile (bookmarks, passwords, etc.)
```

---

## Source code

```powershell
git clone https://github.com/thesajidalam/BraveOriginFree.git
cd BraveOriginFree
.\install.bat
```

---

## Legal / Disclaimer

*This project is for educational purposes. It demonstrates how a configuration flag that is freely available on one platform can be applied on another.*

*Brave Origin is developed by Brave Software Inc. All browser binaries are the official signed builds downloaded from Brave's public GitHub repository. No binaries have been modified, patched, or tampered with.*

*This project is not affiliated with Brave Software Inc.*

---

## Credits

Created and maintained by **Sajid Alam**.

- GitHub: [@thesajidalam](https://github.com/thesajidalam)
- Project: [github.com/thesajidalam/BraveOriginFree](https://github.com/thesajidalam/BraveOriginFree)

---

## Star this repo

If this saved you $60, consider starring the repo. It helps others find it.
