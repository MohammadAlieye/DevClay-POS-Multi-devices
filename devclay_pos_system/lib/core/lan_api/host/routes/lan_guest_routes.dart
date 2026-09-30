import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/isar_service.dart';
import '../../../../modules/restaurant/data/datasources/restaurant_local_datasource.dart';

/// Public LAN guest web-to-table routes (no staff bearer).
void mountLanGuestRoutes(
  Router router, {
  required IsarService isarService,
  required RestaurantLocalDataSource restaurant,
}) {
  final isar = isarService.instance;

  router.get('/guest/', (Request request) async {
    return Response.ok(
      _guestHtml,
      headers: {'Content-Type': 'text/html; charset=utf-8'},
    );
  });

  router.get('/guest', (Request request) async {
    return Response.movedPermanently('/guest/');
  });

  router.get('/guest/api/menu', (Request request) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null || !settings.enableWebToTable) {
      return _json({'error': 'Web-to-table disabled', 'code': 'disabled'}, 403);
    }
    final products = await isar.products
        .filter()
        .deletedAtIsNull()
        .isActiveEqualTo(true)
        .findAll();
    final restaurantCats = {
      'starters',
      'mains',
      'drinks',
      'desserts',
      'combos',
      'other',
    };
    final items = products
        .where((p) {
          final cat = p.category.toLowerCase();
          return restaurantCats.contains(cat) ||
              settings.storeProfile.toLowerCase() == 'restaurant';
        })
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'sku': p.sku,
            'category': p.category,
            'price': p.sellingPrice,
            'unit': p.unit ?? 'portion',
          },
        )
        .toList();
    return _json({'items': items});
  });

  router.get('/guest/api/table/<token>', (Request request, String token) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null || !settings.enableWebToTable) {
      return _json({'error': 'Web-to-table disabled', 'code': 'disabled'}, 403);
    }
    final table = await restaurant.getTableByToken(token);
    if (table == null) {
      return _json({'error': 'Invalid table token', 'code': 'bad_token'}, 404);
    }
    return _json({
      'tableId': table.id,
      'code': table.code,
      'name': table.name,
      'capacity': table.capacity,
      'status': table.status,
    });
  });

  router.post('/guest/api/orders', (Request request) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null || !settings.enableWebToTable) {
      return _json({'error': 'Web-to-table disabled', 'code': 'disabled'}, 403);
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      return _json({'error': 'Invalid JSON', 'code': 'bad_json'}, 400);
    }

    final token = '${body['tableToken'] ?? ''}'.trim();
    if (token.isEmpty) {
      return _json({'error': 'tableToken required', 'code': 'bad_token'}, 400);
    }
    final table = await restaurant.getTableByToken(token);
    if (table == null) {
      return _json({'error': 'Invalid table token', 'code': 'bad_token'}, 404);
    }

    final rawLines = body['lines'];
    if (rawLines is! List || rawLines.isEmpty) {
      return _json({'error': 'lines required', 'code': 'invalid_lines'}, 400);
    }

    final products = await isar.products.filter().deletedAtIsNull().findAll();
    final byId = {for (final p in products) p.id: p};
    final lines = <Map<String, dynamic>>[];
    for (final raw in rawLines) {
      if (raw is! Map) continue;
      final map = Map<String, dynamic>.from(raw);
      final productId = (map['productId'] as num?)?.toInt() ?? 0;
      final qty = (map['quantity'] as num?)?.toDouble() ?? 0;
      final product = byId[productId];
      if (product == null || qty <= 0) continue;
      final lineTotal = product.sellingPrice * qty;
      lines.add({
        'productId': product.id,
        'productName': product.name,
        'productSku': product.sku,
        'quantity': qty,
        'unitPrice': product.sellingPrice,
        'lineDiscount': 0,
        'lineTotal': lineTotal,
        'unit': product.unit,
      });
    }
    if (lines.isEmpty) {
      return _json({'error': 'No valid lines', 'code': 'invalid_lines'}, 400);
    }

    final guests = (body['guests'] as num?)?.toInt() ?? 1;
    final check = await restaurant.openOrGetCheck(
      tableId: table.id,
      guests: guests,
      source: 'web',
    );
    final updated = await restaurant.appendWebLines(
      checkId: check.id,
      newLines: lines,
    );
    if (updated.webAcceptStatus == 'accepted' ||
        updated.webAcceptStatus.isEmpty) {
      await restaurant.fireKitchenTicket(checkId: updated.id);
    }

    return _json({
      'ok': true,
      'checkId': updated.id,
      'status': updated.status,
      'webAcceptStatus': updated.webAcceptStatus,
      'total': updated.total,
      'message': updated.webAcceptStatus == 'pending'
          ? 'Order submitted — waiting for staff accept'
          : 'Order sent to kitchen',
    });
  });
}

Response _json(Map<String, dynamic> body, [int status = 200]) {
  return Response(
    status,
    body: jsonEncode(body),
    headers: const {'Content-Type': 'application/json'},
  );
}

const _guestHtml = r'''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Order · Table</title>
<style>
  :root { color-scheme: light; --bg:#f6f3ee; --ink:#1c1917; --accent:#c2410c; --card:#fff; }
  * { box-sizing: border-box; }
  body { margin:0; font-family: system-ui, sans-serif; background:var(--bg); color:var(--ink); }
  header { padding:16px 18px; background:#1c1917; color:#fff; }
  header h1 { margin:0; font-size:1.1rem; font-weight:650; }
  header p { margin:4px 0 0; opacity:.75; font-size:.85rem; }
  main { padding:14px; max-width:520px; margin:0 auto 96px; }
  .cat { font-size:.75rem; text-transform:uppercase; letter-spacing:.06em; margin:18px 0 8px; opacity:.6; }
  .item { display:flex; gap:12px; align-items:center; background:var(--card); border-radius:12px; padding:12px; margin-bottom:8px; box-shadow:0 1px 2px rgba(0,0,0,.06); }
  .item button { margin-left:auto; border:0; background:var(--accent); color:#fff; border-radius:999px; width:36px; height:36px; font-size:1.2rem; }
  .bar { position:fixed; left:0; right:0; bottom:0; background:#1c1917; color:#fff; padding:12px 16px; display:flex; align-items:center; gap:12px; }
  .bar button { flex:1; border:0; background:var(--accent); color:#fff; padding:12px; border-radius:10px; font-weight:600; }
  .err { color:#b91c1c; padding:12px; }
  .ok { color:#15803d; padding:12px; }
</style>
</head>
<body>
<header>
  <h1 id="title">Table menu</h1>
  <p id="sub">Scan QR to load your table</p>
</header>
<main id="main"><p>Loading…</p></main>
<div class="bar" id="bar" style="display:none">
  <div><div id="cartCount">0 items</div><strong id="cartTotal">0</strong></div>
  <button id="submit">Submit order</button>
</div>
<script>
const token = (location.hash.match(/[#/]t\/([^/?#]+)/)||[])[1] || new URLSearchParams(location.search).get('t') || '';
const cart = new Map();
let menu = [];
let table = null;

function money(n){ return Number(n||0).toFixed(0); }
function render(){
  const main = document.getElementById('main');
  if(!token){ main.innerHTML = '<p class="err">Missing table token. Scan the QR on your table.</p>'; return; }
  const byCat = {};
  for(const it of menu){ (byCat[it.category] ||= []).push(it); }
  let html = '';
  for(const [cat, items] of Object.entries(byCat)){
    html += `<div class="cat">${cat}</div>`;
    for(const it of items){
      html += `<div class="item"><div><strong>${it.name}</strong><div>${money(it.price)}</div></div>
        <button onclick="add(${it.id})">+</button></div>`;
    }
  }
  main.innerHTML = html || '<p>No menu items</p>';
  let qty=0, total=0;
  for(const [id,q] of cart){ const it=menu.find(x=>x.id===id); if(!it) continue; qty+=q; total+=it.price*q; }
  document.getElementById('cartCount').textContent = qty+' items';
  document.getElementById('cartTotal').textContent = money(total);
  document.getElementById('bar').style.display = qty? 'flex':'none';
}
function add(id){ cart.set(id, (cart.get(id)||0)+1); render(); }
async function boot(){
  if(!token){ render(); return; }
  try{
    const tRes = await fetch('/guest/api/table/'+encodeURIComponent(token));
    table = await tRes.json();
    if(!tRes.ok) throw new Error(table.error||'Bad table');
    document.getElementById('title').textContent = table.name || table.code;
    document.getElementById('sub').textContent = 'Order to this table · pay at counter';
    const mRes = await fetch('/guest/api/menu');
    const m = await mRes.json();
    if(!mRes.ok) throw new Error(m.error||'Menu unavailable');
    menu = m.items||[];
    render();
  }catch(e){
    document.getElementById('main').innerHTML = `<p class="err">${e.message||e}</p>`;
  }
}
document.getElementById('submit').onclick = async ()=>{
  const lines=[...cart.entries()].map(([productId,quantity])=>({productId,quantity}));
  const res = await fetch('/guest/api/orders',{method:'POST',headers:{'Content-Type':'application/json'},
    body: JSON.stringify({tableToken:token, lines, guests:1})});
  const data = await res.json();
  const main=document.getElementById('main');
  if(!res.ok){ main.innerHTML=`<p class="err">${data.error||'Failed'}</p>`; return; }
  cart.clear(); render();
  main.innerHTML = `<p class="ok">${data.message||'Order placed'}. Total ${money(data.total)}</p>` + main.innerHTML;
};
boot();
</script>
</body>
</html>
''';
