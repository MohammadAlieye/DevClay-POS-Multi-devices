# DevClayPOS License Management (Firebase)

Firebase-only license system shared by:

- `devclay_pos_system` — POS with trial + activation gate
- `devclay_pos_admin_panel` — Admin desktop/web panel
- `packages/devclay_license_core` — shared models + AES encryption helpers

No Cloud Functions. Sensitive license ciphertext lives on the POS device; Firestore holds license records and admin audit history.

## 1. Configure Firebase

1. Create / open your Firebase project.
2. Enable **Authentication → Email/Password**.
3. Create Firestore database (production mode), then deploy rules:

```bash
# From POS-system root
# Edit .firebaserc → set your project id
firebase deploy --only firestore:rules,firestore:indexes
```

4. Configure Flutter apps (replace placeholders):

```bash
cd devclay_pos_system
flutterfire configure

cd ../devclay_pos_admin_panel
flutterfire configure
```

Or paste keys into each app’s `lib/firebase_options.dart`.

## 2. Credentials (dev)

### Admin panel — Super Admin (Firebase Auth)

| Field | Value |
| ----- | ----- |
| Email | `superadmin@devclaypos.internal` |
| Password | `12345678` |

Create this user in Firebase Console → Authentication → Users → **Add user**.  
**Do not** create a document under `admins/{uid}` for this user.

Super Admin is detected only by email match in app code + Firestore rules. It never appears in the Admin Users list.

To change the email, update both:

- `packages/devclay_license_core/lib/src/constants/super_admin.dart`
- `firestore.rules` (`isSuperAdmin()`)

### Admin panel — normal Admin (optional)

1. Add the user in Firebase Authentication (choose any password).
2. Create Firestore doc `admins/{uid}`:

```json
{
  "email": "admin@example.com",
  "displayName": "Shop Admin",
  "role": "admin",
  "locked": false,
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

| Field | Example |
| ----- | ------- |
| Email | `admin@example.com` |
| Password | whatever you set in Firebase Auth |

### POS app — local demo logins (Isar seed, not Firebase)

| Username | Password | Role |
| -------- | -------- | ---- |
| `admin` | `admin123` | Owner |
| `manager` | `manager123` | Manager |
| `cashier` | `cashier123` | Cashier |

## 3. Seed global settings

Create document `settings/global`:

```json
{
  "defaultTrialDays": 15,
  "trialEnabled": true,
  "appVersion": "1.0.0",
  "minimumSupportedVersion": "1.0.0",
  "maintenanceMode": false
}
```

Or sign in to the Admin panel and save Trial Settings once.

## 4. Install deps

From repo root:

```bash
cd packages/devclay_license_core && dart pub get
cd ../../devclay_pos_system && flutter pub get
cd ../devclay_pos_admin_panel && flutter pub get
```

## 5. Run

```bash
# Admin panel — Chrome (recommended first)
cd devclay_pos_admin_panel
flutter run -d chrome

# Admin panel — Windows desktop
flutter run -d windows

# Admin panel — macOS desktop
flutter run -d macos

# POS — Windows
cd ../devclay_pos_system
flutter run -d windows

# POS — macOS
flutter run -d macos
```

List devices: `flutter devices`

## 6. Build (release)

```bash
# Admin panel
cd devclay_pos_admin_panel
flutter build web --release
flutter build windows --release
flutter build macos --release

# POS
cd ../devclay_pos_system
flutter build windows --release
flutter build macos --release
```

Release outputs:

| Target | Path |
| ------ | ---- |
| Admin web | `devclay_pos_admin_panel/build/web/` |
| Admin Windows | `devclay_pos_admin_panel/build/windows/x64/runner/Release/` |
| Admin macOS | `devclay_pos_admin_panel/build/macos/Build/Products/Release/` |
| POS Windows | `devclay_pos_system/build/windows/x64/runner/Release/` |
| POS macOS | `devclay_pos_system/build/macos/Build/Products/Release/devclay_pos_system.app` |

## Flows

### First launch (POS) — license key always required

There is **no automatic silent trial**. On first launch the user must enter a
license key created in the Admin panel (Trial, Monthly, Yearly, or Lifetime).

### Trial via Admin key

1. Admin → **Licenses → Create** → type **Trial** (days from form / settings).
2. Copy the generated `DCP-XXXX-XXXX-XXXX` key.
3. On POS, enter that key and tap **Activate license**.
4. POS binds the machine and stores an encrypted local license.
5. After the trial expiry date, POS blocks until a renewed/paid key is activated.

### Activation (POS)

1. Customer enters `DCP-XXXX-XXXX-XXXX`.
2. POS `get()`s `licenses/{KEY}` from Firestore.
3. Verifies `licenseKeyHash` (SHA-256 with app salt).
4. Binds `machineId` + `deviceName` if unbound.
5. Saves encrypted local license payload (AES-CBC).

### Startup verification (POS)

1. Require a local license that includes a license key.
2. If online, refresh status from Firestore (suspend / expire blocks access).
3. If offline, allow access using the last valid encrypted license.

### Admin

- Dashboard counts, customers CRUD, licenses CRUD, renew / suspend / expire / manual activate, trial settings, global search, audit logs.
- Super Admin can unlock locked admins and send password resets.

## Testing / reset local license

Local files live under the app support directory:

| OS | Path |
| -- | ---- |
| macOS | `~/Library/Application Support/com.example.devclayPosSystem/` |
| Windows | `%APPDATA%\com.example\devclay_pos_system\` |

| File | Purpose |
|------|---------|
| `license.enc` | Encrypted local license |
| `machine.id` | Machine binding ID |
| `device.secret` | AES key material |

### From Terminal (testing only)

```bash
# macOS — wipe local license only
rm -f "$HOME/Library/Application Support/com.example.devclayPosSystem/license.enc"

# macOS — full local wipe (new machine ID next launch)
rm -f "$HOME/Library/Application Support/com.example.devclayPosSystem/license.enc" \
      "$HOME/Library/Application Support/com.example.devclayPosSystem/machine.id"
```

```powershell
# Windows — wipe local license only
Remove-Item "$env:APPDATA\com.example\devclay_pos_system\license.enc" -ErrorAction SilentlyContinue

# Windows — full local wipe (new machine ID next launch)
Remove-Item "$env:APPDATA\com.example\devclay_pos_system\license.enc","$env:APPDATA\com.example\devclay_pos_system\machine.id" -ErrorAction SilentlyContinue
```

### Unbind a license in Firebase (reuse on another machine)

In Firestore → `licenses/{KEY}` set:

- `machineId` → delete / null  
- `deviceName` → delete / null  

Or Admin → delete license and create a new one.

### Suggested test matrix

1. Create Trial license in Admin → activate on POS → app opens.  
2. Clear local license (long-press) → must enter key again.  
3. Suspend license in Admin → restart POS → blocked.  
4. Renew / set Active again → restart → allowed.  
5. Expire license → blocked.  
6. Activate Monthly/Yearly/Lifetime key → allowed.

## Security notes

- License document ID = normalized license key (allows POS `get` without listing).
- Clients cannot `list` licenses without admin auth.
- Local license files are AES-encrypted with a device secret.
- `licenseKeyHash` supports integrity checks without storing a second secret server-side.
- Without Cloud Functions, a determined client with the license key can still call Firestore; protect further later with App Check + Functions if needed.
