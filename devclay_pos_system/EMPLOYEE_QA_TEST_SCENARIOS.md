# Employee QA Test Scenarios — DevClay POS

**Purpose:** Full Pass / Fail checklist for shop staff testing every part of the software.  
**Language:** English (shop floor).  
**Related:** [HOW_TO_RUN_AND_TEST.md](HOW_TO_RUN_AND_TEST.md) · [LAN_E2E_CHECKLIST.md](lib/core/lan_api/LAN_E2E_CHECKLIST.md)

---

## How to use this checklist

1. Mark each scenario **Pass**, **Fail**, or **Blocked** (cannot run — missing printer, phone, second PC, etc.).
2. Write a short note on Fail / Blocked (what happened).
3. **Who runs what**
   - **Owner** runs everything (A–T).
   - **Manager** runs operations except Users / Settings admin / Recycle Bin (unless given permission).
   - **Cashier** runs B (cashier login), C (if allowed), D (POS), I (view sales), J (customers), Q Kitchen, and role checks in B/N.
4. **Order**
   - Single-device retail shop: finish **A → P**, then optional **T**.
   - Restaurant: also do **Q** and **R**.
   - Multi-device: also do **S**.
5. Do **Prep** below once before POS / Sales / Khata tests.

**Tester:** _________________ **Date:** _____________ **App version / PC:** _________________

---

## Prep (do once)

### Seeded logins (fresh database)

| Username | Password | Role |
|----------|----------|------|
| `admin` | `admin123` | Owner |
| `manager` | `manager123` | Manager |
| `cashier` | `cashier123` | Cashier |

If your shop changed these passwords, use your real accounts and note them here:

| Role | Username | Password |
|------|----------|----------|
| Owner | | |
| Manager | | |
| Cashier | | |

### Sample data to create (as Owner)

- [ ] Product **A**: name `QA Tea`, SKU `QA-TEA`, barcode `880001`, sell price set, stock ≥ 20  
- [ ] Product **B**: name `QA Soap`, SKU `QA-SOAP`, barcode `880002`, wholesale price lower than sell price, stock ≥ 10  
- [ ] Customer **Ali QA**: phone filled, credit limit e.g. `5000`  
- [ ] At least one **Cash** and one **Bank** account (Accounts module)  
- [ ] One **Supplier** named `QA Supplier`

---

## A. License & first launch

### A-01 — License gate
- **Role:** Anyone (first open)
- **Steps:** 1) Launch app. 2) If not licensed, stay on license screen.
- **Expected:** Cannot reach login until trial/license allows.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### A-02 — Activate license (if required)
- **Role:** Owner
- **Steps:** 1) Enter valid license key. 2) Confirm. 3) Open Settings → License later and check status.
- **Expected:** Activation succeeds; Settings shows licensed / trial info. Invalid key is rejected clearly.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### A-03 — Store type wizard
- **Role:** Owner (first run or new DB)
- **Steps:** 1) After license/login path, open store-type setup if shown. 2) Read all options: Pharmacy, Clothing, Milk, Super store, General retail, Restaurant. 3) Pick **General retail** for core tests (or Restaurant if you will do Q/R today).
- **Expected:** Profile saves; app opens home. Categories/units match the chosen type.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## B. Login & roles

### B-01 — Wrong password
- **Role:** —
- **Steps:** 1) Enter `admin` + wrong password. 2) Try login.
- **Expected:** Error message; stay on login.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### B-02 — Owner login
- **Role:** Owner
- **Steps:** 1) Login as `admin` / `admin123`. 2) Check sidebar.
- **Expected:** Sees Dashboard, POS, Products, Inventory, Purchases, Labels, Sales, Customers, Finance, Reports, Accounts, Users, Recycle Bin, Settings. (Floor/Kitchen only if Restaurant profile.)
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### B-03 — Cashier login sidebar
- **Role:** Cashier
- **Steps:** 1) Sign out. 2) Login as `cashier` / `cashier123`. 3) Check sidebar.
- **Expected:** Sees Quick Sale / POS, usually Dashboard, Sales, Customers; **no** Products, Inventory, Purchases, Accounts, Finance, Reports, Users, Settings, Recycle Bin. Kitchen may show if Restaurant.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### B-04 — Manager login
- **Role:** Manager
- **Steps:** Login as `manager` / `manager123`. Check sidebar.
- **Expected:** Broad ops (products, sales, etc.); **Users** usually hidden; Settings may be allowed.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### B-05 — Sign out
- **Role:** Owner
- **Steps:** Settings (or account menu) → Sign out → confirm.
- **Expected:** Returns to login; protected screens not reachable without login.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### B-06 — Remember me / restore session (if shown)
- **Role:** Owner
- **Steps:** 1) Enable Remember me if available. 2) Login. 3) Close and reopen app.
- **Expected:** Session restores or login is pre-filled per product behavior; no crash.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## C. Dashboard

**Role:** Owner or Manager (Cashier if permission allows)

### C-01 — KPI strip loads
- **Steps:** Open Dashboard.
- **Expected:** Compact tiles for today sales, today profit, avg ticket, receipts, month sales, cash on hand (and restaurant tiles if Restaurant).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### C-02 — Chart toggles
- **Steps:** On chart, switch **Sales**, **Profit**, **Hourly**.
- **Expected:** Chart updates; no freeze/crash.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### C-03 — Attention chips
- **Steps:** Note chips for held bills, low stock, expiry, backup, khata, voids (if any data).
- **Expected:** Chips match reality (or “All clear” when nothing pending).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### C-04 — Top products are today
- **Steps:** 1) Note top products. 2) Sell product A on POS. 3) Refresh Dashboard.
- **Expected:** Product A appears / rises in **Top products** (subtitle today).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### C-05 — Recent sales
- **Steps:** After a sale, open Dashboard → Recent sales.
- **Expected:** Latest invoice shows with amount and time.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## D. Quick Sale (POS)

**Role:** Cashier or Owner

### D-01 — Search & add product
- **Steps:** 1) Open Quick Sale. 2) Search `QA Tea`. 3) Add to cart. 4) Change quantity to 2.
- **Expected:** Line total updates; cart count correct.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-02 — Barcode scan / type
- **Steps:** Focus POS. Scan or type barcode `880001` + Enter (as designed).
- **Expected:** QA Tea added (or qty increases).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-03 — Remove line & clear cart
- **Steps:** Remove one line; then Clear cart (confirm if asked).
- **Expected:** Cart empty.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-04 — Line / cart discount
- **Steps:** Add product. Apply a small discount (Rs or %). Cashier: if blocked, request manager approve if UI offers it.
- **Expected:** Totals reduce correctly; unauthorized cashier cannot approve restricted discounts without permission.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-05 — Wholesale price
- **Steps:** Add QA Soap. Enable wholesale (if toggle exists). Compare unit price to normal sell price.
- **Expected:** Wholesale price used when enabled; reverts when disabled.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-06 — Select / create customer
- **Steps:** Attach customer Ali QA (or create new from POS).
- **Expected:** Customer name shows on cart / payment.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-07 — Hold & resume
- **Steps:** 1) Add 2 items. 2) Hold bill. 3) Open held list. 4) Resume. 5) Complete or clear.
- **Expected:** Hold saves; resume restores lines; held count on Dashboard attention if any remain.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-08 — Cash payment + change
- **Steps:** Sell one item. Pay **Cash** with amount above total. Confirm change.
- **Expected:** Sale completes; receipt/preview; stock decreases.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-09 — Card payment
- **Steps:** Sell; pay **Card** (select bank account if asked).
- **Expected:** Sale completes; bank/cash accounts behave as designed.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-10 — Wallet payment
- **Steps:** Sell; pay **Wallet** / JazzCash / EasyPaisa style option if listed.
- **Expected:** Sale completes without crash.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-11 — Split payment
- **Steps:** Sell; choose **Split**; enter part cash + part card.
- **Expected:** Portions sum to total; sale completes.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-12 — Khata / Udhar sale
- **Steps:** 1) Select Ali QA. 2) Pay **Khata**. 3) Open Customers → Ali balance.
- **Expected:** Khata without customer is rejected. With customer, balance increases; ledger entry exists.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-13 — Cashier shift (if Settings requires shift)
- **Steps:** Enable cashier shift required (Owner). Login as cashier. Try sell before opening shift; then open shift and sell.
- **Expected:** Blocked until shift open; sale works after open.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### D-14 — Receipt after sale
- **Steps:** Complete a sale. View receipt preview / print if printer connected.
- **Expected:** Invoice number, lines, totals, shop name visible.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## E. Products

**Role:** Owner / Manager

### E-01 — Create product
- **Steps:** Products → Add. Fill name, SKU, barcode, prices, category, unit, stock/threshold. Save.
- **Expected:** Appears in list and POS.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### E-02 — Duplicate SKU rejected
- **Steps:** Create another product with same SKU as QA Tea.
- **Expected:** Clear error; original product unchanged.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### E-03 — Duplicate barcode rejected
- **Steps:** Try same barcode `880001` on a new product.
- **Expected:** Rejected with message.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### E-04 — Edit product
- **Steps:** Change sell price of QA Tea. Save. Check POS price.
- **Expected:** New price used on new sales.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### E-05 — Soft delete → Recycle Bin
- **Steps:** Delete a test product. Open Recycle Bin.
- **Expected:** Product gone from POS catalog; appears in Recycle Bin.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### E-06 — Clothing variants (only if Clothing profile)
- **Steps:** Create product with size/color variants. Sell a variant on POS.
- **Expected:** Variant stock decrements correctly.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### E-07 — Pharmacy batches (only if Pharmacy / batches enabled)
- **Steps:** Receive/add batch with expiry. Sell so FEFO uses nearer expiry.
- **Expected:** Batch allocation on sale; expiry warnings if near.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## F. Inventory

**Role:** Owner / Manager

### F-01 — Stock list & filters
- **Steps:** Open Inventory. Filter low stock / search product.
- **Expected:** List matches products; filters work.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### F-02 — Adjust stock up
- **Steps:** Adjust QA Tea +5 (reason/note if asked).
- **Expected:** On-hand increases by 5; history shows adjustment.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### F-03 — Adjust stock down
- **Steps:** Adjust −2.
- **Expected:** Stock decreases; cannot go wildly negative if guarded.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### F-04 — Opening stock / batch (if shown)
- **Steps:** Add opening or batch with code/expiry where UI allows.
- **Expected:** Stock and history update.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## G. Purchases & suppliers

**Role:** Owner / Manager

### G-01 — Create supplier
- **Steps:** Purchases → Suppliers → Add `QA Supplier` with phone.
- **Expected:** Saved and selectable.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### G-02 — New purchase receives stock
- **Steps:** 1) Note QA Tea stock. 2) New purchase: supplier QA Supplier, product QA Tea, qty 10, costs. 3) Save.
- **Expected:** Stock +10; purchase listed.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### G-03 — Pieces per box
- **Steps:** On purchase editor, select product, switch Unit to **Box**. Check **Pcs / box**.
- **Expected:** Defaults to **1** (editable). Saving boxes increases stock by boxes × pcs.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### G-04 — Supplier due payment
- **Steps:** Create purchase with partial pay (due remaining). Open Due tab → pay remaining.
- **Expected:** Due decreases; supplier balance correct.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## H. Labels

**Role:** Owner / Manager (labels permission)

### H-01 — Select products & template
- **Steps:** Labels → pick product(s) → choose template → set copies.
- **Expected:** Preview/list ready to print.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### H-02 — Print or export
- **Steps:** Print to installed printer or export/PDF if offered.
- **Expected:** Job succeeds or clear error; history records job.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### H-03 — Bad barcode handling
- **Steps:** Product with empty/invalid barcode if UI validates.
- **Expected:** Clear rejection, no crash.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## I. Sales history, returns, voids

**Role:** Owner/Manager for return/void; Cashier may view only

### I-01 — Search sales
- **Steps:** Sales → search by invoice or customer. Use today filter.
- **Expected:** Matching sales listed.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### I-02 — Sale detail & reprint
- **Steps:** Open a sale → Reprint / preview receipt.
- **Expected:** Same invoice content as original sale.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### I-03 — Partial return
- **Steps:** Return 1 line from a multi-item sale (permission required).
- **Expected:** Refund amount correct; stock restored for returned qty; return listed.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### I-04 — Cashier cannot return (permission check)
- **Role:** Cashier
- **Steps:** Login cashier → try process return.
- **Expected:** Action hidden or denied.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### I-05 — Void sale
- **Role:** Owner/Manager with void permission
- **Steps:** Void a completed test sale (confirm).
- **Expected:** Marked voided; stock restored; cannot return again meaningfully.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## J. Customers & khata

**Role:** Owner / Cashier (customers)

### J-01 — Create / edit customer
- **Steps:** Customers → Add/Edit Ali QA (phone, credit limit).
- **Expected:** Saved; searchable.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### J-02 — Take payment (customer pays shop)
- **Steps:** Open Ali balance → Take payment for part of khata.
- **Expected:** Balance decreases; ledger entry.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### J-03 — Credit limit signal
- **Steps:** Attempt khata sale that would exceed credit limit (if enforced).
- **Expected:** Warning or block per product rules; no silent over-limit if blocked.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### J-04 — Ledger matches POS
- **Steps:** Compare last POS khata sale amount to customer ledger.
- **Expected:** Same amount and roughly same time.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## K. Accounts

**Role:** Owner / Manager

### K-01 — Create cash & bank accounts
- **Steps:** Accounts → add Cash drawer and Bank account with opening balances.
- **Expected:** Listed; totals look right.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### K-02 — Ledger after POS cash sale
- **Steps:** Do cash sale → open Cash account ledger.
- **Expected:** Deposit / in movement for sale amount (or net as designed).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### K-03 — Hidden on LAN client
- **Steps:** On Counter (client) mode, check sidebar.
- **Expected:** Accounts module not available.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## L. Finance

**Role:** Owner / Manager

### L-01 — Create employee
- **Steps:** Finance → Employees → add staff with salary.
- **Expected:** Employee saved.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### L-02 — Attendance
- **Steps:** Mark attendance for today if tab exists.
- **Expected:** Record saved.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### L-03 — Expense
- **Steps:** Record expense from an account (category + amount).
- **Expected:** Account balance drops; expense listed; Dashboard today expenses may rise.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### L-04 — Salary / advance
- **Steps:** Pay salary or record advance against account.
- **Expected:** History shows payment; account moves.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### L-05 — Cash in / out / withdrawal
- **Steps:** Record cash in and cash out (small amounts).
- **Expected:** Balances update; no crash.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## M. Reports

**Role:** Owner / Manager

### M-01 — Open sales report
- **Steps:** Reports → Sales (or equivalent) → Today.
- **Expected:** Loads without error; figures roughly match today's POS.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### M-02 — Date range
- **Steps:** Switch This week / This month / custom if available.
- **Expected:** Data refreshes; no freeze.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### M-03 — Profit / expenses / stock reports
- **Steps:** Open at least one of Profit, Expenses, Stock.
- **Expected:** Each opens or shows clear “unavailable” message.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### M-04 — Export / share
- **Steps:** Export or share if button exists.
- **Expected:** File/share sheet opens successfully.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## N. Users & permissions

**Role:** Owner

### N-01 — Create cashier user
- **Steps:** Users → Add cashier with username/password. Leave modules limited.
- **Expected:** User saves; can login.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### N-02 — Cashier cannot open Settings/Users
- **Steps:** Login as that cashier. Try Settings / Users / Products.
- **Expected:** Hidden or access denied.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### N-03 — Soft-delete user
- **Steps:** Soft-delete a test user. Check Recycle Bin.
- **Expected:** Cannot login as deleted; appears in Recycle Bin if supported.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## O. Settings

**Role:** Owner

### O-01 — Business profile fields
- **Steps:** Settings → set business name, phone, address, NTN. Save.
- **Expected:** Receipt later shows updated shop name/info.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-02 — Tax & receipt
- **Steps:** Toggle tax on/off; set default rate; edit receipt footer/title. Save. Make a sale.
- **Expected:** Receipt reflects tax/footer settings.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-03 — Printer / scanner / drawer tests
- **Steps:** Devices section → Test print / scanner / cash drawer if hardware present.
- **Expected:** Success feedback or clear “not found” message — no crash.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-04 — Units & categories
- **Steps:** Add a custom unit and category. Use on a new product.
- **Expected:** Options appear in product editor.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-05 — Theme
- **Steps:** Change theme / accent. Navigate a few screens.
- **Expected:** Colors update; readable; no broken UI.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-06 — Backup export
- **Steps:** Create backup / export. Note file path.
- **Expected:** Backup succeeds; Dashboard “backup due” attention improves if it uses last backup time.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-07 — Store type change
- **Steps:** Settings → Business profile → switch type (e.g. General retail ↔ Restaurant). Choose keep vs reset catalog if asked.
- **Expected:** Flags update; Restaurant shows Floor/Kitchen; non-restaurant hides them.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### O-08 — Sign out from Settings
- **Steps:** Sign out.
- **Expected:** Login screen.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## P. Recycle Bin

**Role:** Owner

### P-01 — Restore product
- **Steps:** Recycle Bin → restore previously deleted product.
- **Expected:** Product back in Products and POS.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### P-02 — Purge permanently
- **Steps:** Delete another test item → Recycle Bin → Purge (confirm).
- **Expected:** Gone forever; not restorable.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## Q. Restaurant floor, POS tables, kitchen

**Only if store profile = Restaurant.**  
**Role:** Owner/Manager for Floor; Cashier ok for Kitchen/POS Tables.

### Q-01 — Floor / Tables visible
- **Steps:** Check sidebar for **Floor / Tables** and **Kitchen**.
- **Expected:** Both visible only for Restaurant profile.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-02 — Seeded Main floor
- **Steps:** Open Floor / Tables.
- **Expected:** Floor **Main** with multiple tables (about 8–12) and statuses.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-03 — Open check from table
- **Steps:** Live mode → tap a **free** table.
- **Expected:** Table becomes seated/open check; toast or status change.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-04 — Edit mode: move / add table
- **Steps:** Switch to Editing → drag a table → Add table → Save positions.
- **Expected:** Position persists after leaving and returning.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-05 — QR / guest token
- **Steps:** Long-press table → copy token / view guest path `/guest/#/t/...`.
- **Expected:** Token shown; copy works.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-06 — POS Quick Sale | Tables
- **Steps:** POS → **Tables** → tap table → returns to catalog with Check chip / notes.
- **Expected:** Ordering linked to that table check.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-07 — Send kitchen
- **Steps:** With active check, add items → **Send kitchen**.
- **Expected:** Kitchen page shows new ticket for table code.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-08 — Kitchen bump flow
- **Steps:** Kitchen → Start → Ready → Bump.
- **Expected:** Status advances; bumped ticket leaves open list.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-09 — Close check via payment
- **Steps:** Complete POS payment for table check. Open Floor.
- **Expected:** Table becomes **dirty** (or equivalent). Tap dirty table to clear → **free**.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### Q-10 — Dashboard restaurant KPIs
- **Steps:** With open tables / kitchen tickets, refresh Dashboard.
- **Expected:** Open tables / kitchen counts look right.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## R. Web-to-table (LAN guest ordering)

**Needs:** Restaurant profile + Shop Host running + phone on same Wi‑Fi.

### R-01 — Enable web-to-table
- **Role:** Owner
- **Steps:** Settings → Devices (LAN) → Host mode → start host. Web-to-table card → Enable → Save. Note guest URL `http://HOST_IP:PORT/guest/`.
- **Expected:** Settings save; host running.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### R-02 — Health check
- **Steps:** On phone browser open `http://HOST_IP:PORT/api/v1/health`.
- **Expected:** JSON with `"ok": true`.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### R-03 — Guest menu + order
- **Steps:** 1) Copy table token from Floor. 2) Open `http://HOST_IP:PORT/guest/#/t/TOKEN`. 3) Add items → Submit order.
- **Expected:** Table name shows; menu loads; success message; no payment on guest web.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### R-04 — Staff sees order
- **Steps:** POS Tables / Kitchen / Floor after guest order.
- **Expected:** Web order on table; kitchen ticket if auto-accepted.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### R-05 — Accept PIN (optional)
- **Steps:** Set Web-to-table PIN in Settings. Place another guest order. Accept from POS Tables.
- **Expected:** Order stays pending until Accept; then kitchen fires.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### R-06 — Bad token
- **Steps:** Open guest URL with wrong token.
- **Expected:** Clear error; no order created.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## S. LAN multi-device (Host + Counter)

**Needs:** Two PCs (or two machines) on same Wi‑Fi.

### S-01 — Start Shop Host
- **Steps:** Host PC → Settings → Devices → **Shop Host** → port (e.g. 8080) → Start/Save. Note LAN IP.
- **Expected:** Status “Running on port …”.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### S-02 — Client connect
- **Steps:** Counter PC → **Counter** mode → enter host IP/port → Test connection → Save.
- **Expected:** Connected + latency; store type read-only from host.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### S-03 — Client login
- **Steps:** On client, login with host staff user (e.g. admin).
- **Expected:** Login works; sidebar hides Products / Inventory / Purchases / Accounts / Users / Recycle Bin.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### S-04 — Client sale appears on host
- **Steps:** Sell on client POS. On host open Sales / Dashboard.
- **Expected:** Same invoice on host; stock reduced on host DB.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### S-05 — Client cannot manage products
- **Steps:** On client try open Products (if reachable).
- **Expected:** Hidden or error “manage on shop host”.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### S-06 — Host offline
- **Steps:** Stop host. On client try sell or refresh dashboard.
- **Expected:** Clear offline / unreachable message; no silent corrupt sale.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### S-07 — Client dashboard fullness
- **Steps:** With host online, open Dashboard on client.
- **Expected:** Sales, profit, series, top products etc. (not empty shell).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## T. Smoke finale (one full day path)

**Role:** Owner **Time:** ~20–30 minutes

### T-01 — End-to-end retail day
- **Steps:**
  1. Purchase stock for QA Tea.
  2. Check Inventory stock.
  3. POS cash sale.
  4. POS khata sale to Ali QA.
  5. Partial return on cash sale.
  6. Open Sales report for today.
  7. Create backup.
  8. Check Dashboard KPIs look sane.
- **Expected:** Each step succeeds; numbers consistent (stock, balances, reports).
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

### T-02 — End-to-end restaurant day (if Restaurant)
- **Steps:** Seat table → order on POS Tables → Send kitchen → bump → pay → clear dirty table → one guest web order.
- **Expected:** Full path works without stuck table/check.
- **Result:** [ ] Pass [ ] Fail [ ] Blocked Notes: ___________

---

## Sign-off

| Item | Value |
|------|--------|
| Overall result | [ ] Ready for shop use [ ] Needs fixes |
| Critical fails (IDs) | |
| Blocked by hardware | |
| Tester signature | |
| Owner reviewed | [ ] Yes [ ] No Date: |

---

## Quick module index

| ID prefix | Module |
|-----------|--------|
| A | License & first launch |
| B | Login & roles |
| C | Dashboard |
| D | Quick Sale / POS |
| E | Products |
| F | Inventory |
| G | Purchases & suppliers |
| H | Labels |
| I | Sales / returns / voids |
| J | Customers & khata |
| K | Accounts |
| L | Finance |
| M | Reports |
| N | Users |
| O | Settings |
| P | Recycle Bin |
| Q | Restaurant floor / kitchen |
| R | Web-to-table |
| S | LAN host / client |
| T | Smoke finale |
