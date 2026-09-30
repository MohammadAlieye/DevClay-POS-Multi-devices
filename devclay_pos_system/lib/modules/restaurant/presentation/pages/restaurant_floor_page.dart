import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../database/collections/dining_floor.dart';
import '../../../../database/collections/dining_table.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../data/datasources/restaurant_local_datasource.dart';

class RestaurantFloorPage extends StatefulWidget {
  const RestaurantFloorPage({super.key});

  @override
  State<RestaurantFloorPage> createState() => _RestaurantFloorPageState();
}

class _RestaurantFloorPageState extends State<RestaurantFloorPage> {
  final _ds = sl<RestaurantLocalDataSource>();
  List<DiningFloor> _floors = const [];
  List<DiningTable> _tables = const [];
  int? _floorId;
  bool _loading = true;
  String? _error;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _ds.ensureSeededIfNeeded();
      final floors = await _ds.listFloors();
      final floorId = _floorId ?? (floors.isEmpty ? null : floors.first.id);
      final tables =
          floorId == null ? <DiningTable>[] : await _ds.listTables(floorId: floorId);
      if (!mounted) return;
      setState(() {
        _floors = floors;
        _floorId = floorId;
        _tables = tables;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Color _statusColor(String status) => switch (status) {
        'seated' => AppColors.accent,
        'ordered' || 'sent' => AppColors.warning,
        'bill' => AppColors.primary,
        'dirty' => AppColors.danger,
        _ => AppColors.success,
      };

  Future<void> _addFloor() async {
    final name = await _prompt(context, title: 'New floor', hint: 'Main');
    if (name == null || name.trim().isEmpty) return;
    await _ds.createFloor(name);
    await _reload();
  }

  Future<void> _addTable() async {
    final floorId = _floorId;
    if (floorId == null) return;
    final code = await _prompt(context, title: 'Table code', hint: 'T13');
    if (code == null || code.trim().isEmpty) return;
    await _ds.upsertTable(
      floorId: floorId,
      code: code,
      name: 'Table ${code.trim().toUpperCase()}',
      capacity: 4,
      posX: 20 + (_tables.length % 4) * 18.0,
      posY: 20 + (_tables.length ~/ 4) * 22.0,
    );
    await _reload();
  }

  Future<void> _onTableTap(DiningTable table) async {
    if (_editMode) {
      await _editTable(table);
      return;
    }
    if (table.status == 'dirty') {
      await _ds.clearTable(table.id);
      if (!mounted) return;
      AppToast.show(context, 'Table ${table.code} cleared');
      await _reload();
      return;
    }
    final guests = table.guests > 0 ? table.guests : 2;
    final check = await _ds.openOrGetCheck(tableId: table.id, guests: guests);
    if (!mounted) return;
    AppToast.show(
      context,
      'Check #${check.id} on ${table.code} · tap POS Tables to order',
    );
    await _reload();
  }

  Future<void> _editTable(DiningTable table) async {
    final capacityCtrl = TextEditingController(text: '${table.capacity}');
    final nameCtrl = TextEditingController(text: table.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${table.code}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(
              controller: capacityCtrl,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          TextButton(
            onPressed: () async {
              await _ds.regenerateTableToken(table.id);
              if (ctx.mounted) Navigator.pop(ctx, false);
              if (mounted) {
                AppToast.show(context, 'QR token regenerated for ${table.code}');
                await _reload();
              }
            },
            child: const Text('New QR token'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _ds.upsertTable(
      id: table.id,
      floorId: table.floorId,
      code: table.code,
      name: nameCtrl.text,
      capacity: int.tryParse(capacityCtrl.text) ?? table.capacity,
      posX: table.posX,
      posY: table.posY,
      shape: table.shape,
    );
    await _reload();
  }

  Future<void> _showQr(DiningTable table) async {
    final path = '/guest/#/t/${table.guestToken}';
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('QR · ${table.code}'),
        content: SelectableText(
          'Guest path:\n$path\n\nToken:\n${table.guestToken}\n\n'
          'Open Shop Host, enable Web-to-table, then print this path with host IP.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: table.guestToken));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Copy token'),
          ),
          FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return EmptyState(
        title: 'Floor unavailable',
        message: _error!,
        icon: Symbols.table_restaurant,
        action: AppButton(label: 'Retry', onPressed: _reload),
      );
    }
    if (_floors.isEmpty) {
      return EmptyState(
        title: 'No floors yet',
        message: 'Add a floor to place tables.',
        icon: Symbols.table_restaurant,
        action: AppButton(label: 'Add floor', onPressed: _addFloor),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final f in _floors)
                      ChoiceChip(
                        label: Text(f.name),
                        selected: f.id == _floorId,
                        onSelected: (_) async {
                          setState(() => _floorId = f.id);
                          await _reload();
                        },
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Add floor',
                onPressed: _addFloor,
                icon: const Icon(Symbols.add_home),
              ),
              IconButton(
                tooltip: 'Add table',
                onPressed: _addTable,
                icon: const Icon(Symbols.add),
              ),
              FilterChip(
                label: Text(_editMode ? 'Editing' : 'Live'),
                selected: _editMode,
                onSelected: (v) => setState(() => _editMode = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                margin: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  borderRadius: AppRadii.mdAll,
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Stack(
                  children: [
                    for (final table in _tables)
                      Positioned(
                        left: constraints.maxWidth * (table.posX / 100) - 36,
                        top: constraints.maxHeight * (table.posY / 100) - 36,
                        child: GestureDetector(
                          onTap: () => _onTableTap(table),
                          onLongPress: () => _showQr(table),
                          onPanUpdate: _editMode
                              ? (d) {
                                  setState(() {
                                    table.posX = (table.posX +
                                            d.delta.dx /
                                                constraints.maxWidth *
                                                100)
                                        .clamp(5, 95);
                                    table.posY = (table.posY +
                                            d.delta.dy /
                                                constraints.maxHeight *
                                                100)
                                        .clamp(5, 95);
                                  });
                                }
                              : null,
                          onPanEnd: _editMode
                              ? (_) async {
                                  await _ds.upsertTable(
                                    id: table.id,
                                    floorId: table.floorId,
                                    code: table.code,
                                    name: table.name,
                                    capacity: table.capacity,
                                    posX: table.posX,
                                    posY: table.posY,
                                    shape: table.shape,
                                  );
                                }
                              : null,
                          child: _TableChip(
                            table: table,
                            color: _statusColor(table.status),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TableChip extends StatelessWidget {
  const _TableChip({required this.table, required this.color});

  final DiningTable table;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final round = table.shape == 'round';
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color, width: 2),
        borderRadius: round ? BorderRadius.circular(36) : AppRadii.smAll,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            table.code,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            '${table.capacity} · ${table.status}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

Future<String?> _prompt(
  BuildContext context, {
  required String title,
  required String hint,
}) async {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        decoration: InputDecoration(hintText: hint),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
