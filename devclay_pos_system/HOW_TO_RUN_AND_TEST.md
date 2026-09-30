# How to run & test — DevClay POS (LAN + Restaurant)

**Employee Pass/Fail handbook (every module):**  
[`EMPLOYEE_QA_TEST_SCENARIOS.md`](EMPLOYEE_QA_TEST_SCENARIOS.md) — give this to staff for full shop QA.

This guide covers:
1. Running the app
2. Testing **Shop Host + Counter** (LAN multi-device)
3. Testing **Restaurant floor, kitchen, and guest/web order-taking**

Related checklist: [`lib/core/lan_api/LAN_E2E_CHECKLIST.md`](lib/core/lan_api/LAN_E2E_CHECKLIST.md)

---

## 1. How to run

From the Flutter app folder:

```bash
cd devclay_pos_system
flutter pub get
flutter run -d macos          # or windows / chrome / your device id
```

List devices:

```bash
flutter devices
```

### First launch

1. Activate / license the machine as usual (license flow is unchanged).
2. Pick a **store type** on setup (or later in Settings → Store type).
3. Sign in with a staff user (seeded users if you use default seed data).

### Automated tests

```bash
cd devclay_pos_system
flutter test test/lan_api/
flutter test test/restaurant/
```

---

## 2. LAN multi-device (Host + Client)

You need **two PCs** (or two app instances on different machines) on the **same Wi‑Fi**.

| Role | What it does |
|------|----------------|
| **Solo** | Local Isar only — no LAN |
| **Shop Host** | Owns the database; runs HTTP API on `0.0.0.0:port` |
| **Counter (Client)** | Thin till — sells / lists sales via host API |

### Host PC

1. Open **Settings → Devices (LAN)**.
2. Choose **Shop Host**.
3. Set bind port (default **8080**).
4. Press **Start host** / **Save device mode**.
5. Copy a LAN IP chip (e.g. `192.168.1.42`).
6. Allow the port through the OS firewall if asked.

Sanity check in a browser on another device:

```text
http://HOST_IP:8080/api/v1/health
```

You should see JSON with `"ok": true`.

### Client / Counter PC

1. Settings → Devices → **Counter**.
2. Enter host IP + port → **Test connection** (Connected + latency).
3. Save. Store type becomes **read-only** from host.
4. Sign out → sign in with a **host staff** username/password.
5. Sidebar should hide Products / Inventory / Purchases / Users / etc.
6. Sell on POS — invoices and stock live on the host.

### What to verify (short)

- Both tills can sell; stock and invoice sequence stay consistent on host.
- Client Sales screen shows host invoices.
- Stop host → client cannot complete sale; shell chip shows **Host offline**.
- Switch back to **Solo** → local catalog still works.

Full steps: `lib/core/lan_api/LAN_E2E_CHECKLIST.md`.

---

## 3. Restaurant & order-taking — how to test

Restaurant features appear when store type is **Restaurant**.

### A. One-time setup (Host or Solo)

1. **Settings → Store type** → choose **Restaurant** (reset defaults if you want Starters/Mains/Drinks categories).
2. Confirm sidebar shows:
   - **Floor** (`/restaurant/floor`)
   - **Kitchen** (`/restaurant/kitchen`)
3. Add menu products under categories like `Starters`, `Mains`, `Drinks`, `Desserts` (or any category if profile is restaurant).
4. Open **Floor**:
   - Sample floor/tables seed on first open if empty.
   - Or add a floor + tables yourself.

### B. Staff order-taking (inside the app)

**Path 1 — Floor map**

1. Open **Floor**.
2. Tap a free table → seat / open check (status colors: free → seated → ordered → bill).
3. Send items to kitchen as your UI flow allows.
4. Open **Kitchen** on another screen/window if available — tickets should show.
5. Pay/close from POS when the check is ready (POS checkout closes linked restaurant checks).

**Path 2 — POS tables panel**

1. Open **Quick Sale / POS**.
2. If restaurant mode is on, switch to the **tables** view (tables grid).
3. Tap a table / open check → add lines → complete sale to close the check.
4. Pending **web** orders show a banner: **Accept all** (accepts + fires kitchen ticket).

### C. Guest web-to-table (phone orders on LAN)

This is the “customer scans QR / opens link and orders” flow. It needs **Shop Host** running.

1. On the **Host** machine:
   - Settings → Devices → **Shop Host** → Start host.
   - Scroll to **Web-to-table (LAN)** (only visible when store type is Restaurant).
   - Turn **Enable guest ordering** ON.
   - Optional: set a **Staff accept PIN** (empty = auto-accept web orders).
   - Save. Note the guest URL shown, e.g.  
     `http://192.168.1.42:8080/guest/`
2. On **Floor**, open a table’s **QR** action:
   - Copy guest path like `/guest/#/t/<tableToken>`.
3. On a **phone / laptop on the same Wi‑Fi**, open:

```text
http://HOST_IP:8080/guest/#/t/TABLE_TOKEN
```

Example:

```text
http://192.168.1.42:8080/guest/#/t/abc123token
```

4. Guest picks menu items → submit order.
5. On Host POS / Floor:
   - If PIN is set: accept pending web order.
   - If PIN empty: order is accepted automatically.
6. Open **Kitchen** — ticket should appear.
7. Staff completes service → bill/pay on POS.

### Quick API checks (optional)

With host running and web-to-table enabled:

```bash
# Menu (no login)
curl http://HOST_IP:8080/guest/api/menu

# Table by token
curl http://HOST_IP:8080/guest/api/table/TABLE_TOKEN
```

Automated coverage:

```bash
flutter test test/lan_api/lan_guest_web_test.dart
flutter test test/restaurant/
```

---

## 4. Who / what can you use to test restaurant + orders?

| Tester | Device | What they do |
|--------|--------|----------------|
| **You (staff)** | Host PC app | Floor, kitchen, POS tables, accept web orders, take payment |
| **Second staff / counter** | Client PC on same Wi‑Fi | Floor + Kitchen + POS tables against **host** APIs (after Counter mode + login). Guest QR URLs still use the **Host** IP. |
| **Guest / diner** | Phone browser on shop Wi‑Fi | Open `http://HOST_IP:8080/guest/#/t/TOKEN` and place an order |
| **Kitchen display** | Host or Counter app | Sidebar → **Kitchen** (data from host when Counter) |
| **CI / you offline** | Terminal | `flutter test test/lan_api/` and `test/restaurant/` |

### Counter restaurant check

1. Host: Restaurant profile + Shop Host running.
2. Counter: Devices → Counter → host IP → Test → Save → login with host staff user.
3. On Counter open **Floor** / **Kitchen** — tables and tickets should match the host.
4. Seat a table / accept web order / bump kitchen on Counter; confirm Host Kitchen updates.

### Recommended minimal demo (15 minutes)

1. One Mac/PC → store type **Restaurant** → **Shop Host** started → web-to-table **ON**.
2. Floor → open QR for table T1 → copy full URL with host IP.
3. Phone on same Wi‑Fi → open guest URL → order a Main.
4. Host or Counter POS → Accept web order (if needed) → Kitchen shows ticket → pay on POS.

---

## 5. Common pitfalls

- Guest page returns **403 / disabled** → Web-to-table switch is off, or host not started.
- Phone cannot open host IP → different Wi‑Fi, firewall blocking port, or wrong IP (use the IP chip from Devices settings).
- Floor / Kitchen missing in sidebar → store type is not **Restaurant** (or permissions lack `restaurantManage` / `kitchenView`). Sync profile on Counter after connecting.
- Client deep-links to Products / Inventory / etc. redirect back to POS — manage catalog on the host.
- Empty guest menu → add active products (restaurant categories help filtering).

---

## 6. Architecture reminder (one line)

**Host PC = database + LAN API + restaurant checks.** Counters and guest phones only talk HTTP to the host on the shop LAN.
