# LAN host + client — 2-PC verification checklist

Use two machines on the same Wi‑Fi/LAN. License each machine as usual.

## Host PC

1. Settings → Devices → **Shop Host** → set bind port (default 8080) → **Start host**.
2. Copy a LAN IP chip and note the port.
3. Allow the port through the OS firewall if prompted.
4. Confirm store type / products exist on this PC (source of truth).

## Client PC

1. Settings → Devices → **Counter** → enter host IP + port → **Test connection** (expect Connected + latency).
2. Save device mode. Store type should show read-only from host.
3. Sign out and sign in with a host staff username/password (login hits host).
4. Sidebar should hide Products / Inventory / Purchases / Users / Recycle Bin / Finance / Accounts.
5. Held-sales button should be hidden on POS.

## Sell both tills

1. On **host**, sell a stocked product; note invoice and remaining stock.
2. On **client**, open POS — catalog/stock should match host (refresh if needed).
3. Sell the same product on **client**; invoice should allocate on host.
4. On **host**, open Sales — both invoices visible; stock reduced by both sales.
5. On **client**, Sales list should show the same host invoices.

## Khata

1. Create a customer on client (or host).
2. Complete a Khata sale on client for that customer.
3. On host, customer balance / ledger should reflect the sale.

## Offline

1. Stop host server (or disconnect host Wi‑Fi).
2. Client top bar chip should show **Host offline** (tap to re-test).
3. Client POS complete sale / catalog load should fail with a clear host-offline message.
4. Restart host → Test connection / chip refresh → selling works again.

## Solo

1. Switch a machine to **Solo**, save, restart if needed.
2. Confirm local Isar catalog/sales still work without LAN.
