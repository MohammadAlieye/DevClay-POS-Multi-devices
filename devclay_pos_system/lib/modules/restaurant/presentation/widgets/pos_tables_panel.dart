import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../database/collections/dining_table.dart';
import '../../../../database/collections/restaurant_check.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../data/datasources/restaurant_local_datasource.dart';

/// Compact tables panel for POS Restaurant mode.
class PosTablesPanel extends StatefulWidget {
  const PosTablesPanel({
    super.key,
    required this.onOpenCheck,
  });

  final void Function(RestaurantCheck check, DiningTable table) onOpenCheck;

  @override
  State<PosTablesPanel> createState() => _PosTablesPanelState();
}

class _PosTablesPanelState extends State<PosTablesPanel> {
  final _ds = sl<RestaurantLocalDataSource>();
  List<DiningTable> _tables = const [];
  List<RestaurantCheck> _pendingWeb = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    await _ds.ensureSeededIfNeeded();
    final tables = await _ds.listTables();
    final open = await _ds.listOpenChecks();
    if (!mounted) return;
    setState(() {
      _tables = tables;
      _pendingWeb = open
          .where((c) => c.source == 'web' && c.webAcceptStatus == 'pending')
          .toList();
      _loading = false;
    });
  }

  Color _color(String status) => switch (status) {
        'seated' => AppColors.accent,
        'ordered' => AppColors.warning,
        'bill' => AppColors.primary,
        'dirty' => AppColors.danger,
        _ => AppColors.success,
      };

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_pendingWeb.isNotEmpty)
          Material(
            color: AppColors.accent.withValues(alpha: 0.12),
            child: ListTile(
              leading: const Icon(Symbols.qr_code_2),
              title: Text('${_pendingWeb.length} web order(s) need accept'),
              trailing: TextButton(
                onPressed: () async {
                  for (final c in _pendingWeb) {
                    await _ds.acceptWebOrder(c.id);
                    await _ds.fireKitchenTicket(checkId: c.id);
                  }
                  await _reload();
                },
                child: const Text('Accept all'),
              ),
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: _tables.length,
            itemBuilder: (context, index) {
              final table = _tables[index];
              return InkWell(
                borderRadius: AppRadii.smAll,
                onTap: () async {
                  if (table.status == 'dirty') {
                    await _ds.clearTable(table.id);
                    await _reload();
                    return;
                  }
                  final check = await _ds.openOrGetCheck(tableId: table.id);
                  widget.onOpenCheck(check, table);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppRadii.smAll,
                    border: Border.all(color: _color(table.status), width: 2),
                    color: _color(table.status).withValues(alpha: 0.12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        table.code,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(table.status),
                      const Spacer(),
                      if (table.openCheckId != null)
                        FutureBuilder(
                          future: _ds.getCheck(table.openCheckId!),
                          builder: (context, snap) {
                            final c = snap.data;
                            if (c == null) return const SizedBox.shrink();
                            return Text(
                              CurrencyFormatter.format(c.total),
                              style: Theme.of(context).textTheme.labelLarge,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            'Tap table to open check · dirty tables clear on tap',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

List<Map<String, dynamic>> decodeCheckLines(String linesJson) {
  try {
    final decoded = jsonDecode(linesJson);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  } catch (_) {
    return const [];
  }
}
