# DevClayPOS

Offline-first Point of Sale for Pakistan — Windows & macOS desktop.

## Demo logins


| Username | Password   | Role    |
| -------- | ---------- | ------- |
| admin    | admin123   | Owner   |
| manager  | manager123 | Manager |
| cashier  | cashier123 | Cashier |


## **Developer contact**

**Mohammad Ali · Lahore, Pakistan**

- **Email: [mohammadalieye@gmail.com](mailto:mohammadalieye@gmail.com)**
- **Mobile & WhatsApp: 03186056021**

**In the app: Settings → About (copy email, phone, or location).**

## Build

**macOS** (on Mac):

```bash
flutter pub get
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/devclay_pos_system.app`

**Windows** (on Windows with Visual Studio 2022 + Desktop C++):

```bash
flutter pub get
flutter build windows --release
```

Output: `build\windows\x64\runner\Release\` (copy the whole folder to the target PC).

## Stack

Flutter · Clean Architecture · BLoC · Isar · go_router

## Labels module

**Settings → sidebar: Labels** (`/labels`) — barcode & label printing with:

- Individual and bulk print (selected, category, low stock, all active)
- 6 built-in store templates: Retail, Grocery, Pharmacy, Clothing, Electronics, Warehouse
- Formats: **ZPL** (Windows/Zebra), **ESC/POS** thermal, **PDF** (cross-platform)
- Symbologies: Code 128, EAN-13, Code 39
- Template manager + print history

Hot restart required after update (new Isar collections).