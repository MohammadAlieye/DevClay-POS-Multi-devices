import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../database/collections/kitchen_ticket.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/empty_state.dart';
import '../../data/datasources/restaurant_local_datasource.dart';

class KitchenDisplayPage extends StatefulWidget {
  const KitchenDisplayPage({super.key});

  @override
  State<KitchenDisplayPage> createState() => _KitchenDisplayPageState();
}

class _KitchenDisplayPageState extends State<KitchenDisplayPage> {
  final _ds = sl<RestaurantLocalDataSource>();
  List<KitchenTicket> _tickets = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    final tickets = await _ds.listKitchenTickets(openOnly: true);
    if (!mounted) return;
    setState(() {
      _tickets = tickets;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> _lines(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_tickets.isEmpty) {
      return EmptyState(
        title: 'Kitchen clear',
        message: 'No open tickets. Fire an order from a table check.',
        icon: Symbols.skillet,
        action: AppButton(label: 'Refresh', onPressed: _reload),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _tickets.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final t = _tickets[index];
          final lines = _lines(t.linesJson);
          final color = switch (t.status) {
            'preparing' => AppColors.warning,
            'ready' => AppColors.success,
            _ => AppColors.accent,
          };
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        t.tableCode,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(t.status),
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                      const Spacer(),
                      Text(
                        _ago(t.firedAt),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...lines.map(
                    (line) => Text(
                      '• ${line['productName'] ?? ''} × ${line['quantity'] ?? 1}',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (t.status == 'queued')
                        FilledButton(
                          onPressed: () async {
                            await _ds.bumpKitchenTicket(t.id, to: 'preparing');
                            await _reload();
                          },
                          child: const Text('Start'),
                        ),
                      if (t.status == 'queued' || t.status == 'preparing')
                        FilledButton.tonal(
                          onPressed: () async {
                            await _ds.bumpKitchenTicket(t.id, to: 'ready');
                            await _reload();
                          },
                          child: const Text('Ready'),
                        ),
                      if (t.status == 'ready')
                        OutlinedButton(
                          onPressed: () async {
                            await _ds.bumpKitchenTicket(t.id, to: 'bumped');
                            await _reload();
                          },
                          child: const Text('Bump'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _ago(DateTime at) {
    final m = DateTime.now().difference(at).inMinutes;
    if (m < 1) return 'now';
    return '${m}m';
  }
}
