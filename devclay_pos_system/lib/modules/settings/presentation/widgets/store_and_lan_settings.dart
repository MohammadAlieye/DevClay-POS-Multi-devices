import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/client/lan_api_client.dart';
import '../../../../core/lan_api/client/lan_connection_monitor.dart';
import '../../../../core/lan_api/host/shop_host_server.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../core/store_profile/store_profile_service.dart';
import '../../../../core/store_profile/store_profiles.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/section_header.dart';

/// Store type picker + optional reset of categories/units.
class StoreTypeSettingsCard extends StatefulWidget {
  const StoreTypeSettingsCard({super.key});

  @override
  State<StoreTypeSettingsCard> createState() => _StoreTypeSettingsCardState();
}

class _StoreTypeSettingsCardState extends State<StoreTypeSettingsCard> {
  StoreProfileId? _current;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = await sl<StoreProfileService>().currentProfileId();
    if (!mounted) return;
    setState(() {
      _current = id;
      _loading = false;
    });
  }

  Future<void> _apply(StoreProfileId id, {required bool resetCatalog}) async {
    setState(() => _busy = true);
    try {
      await sl<StoreProfileService>().applyProfile(
        id,
        resetCatalogDefaults: resetCatalog,
        markConfigured: true,
      );
      if (!mounted) return;
      setState(() {
        _current = id;
        _busy = false;
      });
      AppToast.show(
        context,
        resetCatalog
            ? 'Store type updated and defaults reset.'
            : 'Store type updated. Categories unchanged.',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      AppToast.show(context, e.toString(), tone: AppToastTone.error);
    }
  }

  Future<void> _onChanged(StoreProfileId? id) async {
    if (id == null || id == _current || _busy) return;
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change store type?'),
        content: Text(
          'Switch to ${id.displayName}. Categories and units will not be wiped '
          'unless you choose reset.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep categories'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset to profile defaults'),
          ),
        ],
      ),
    );
    if (reset == null) return;
    await _apply(id, resetCatalog: reset);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: LinearProgressIndicator(),
      );
    }
    final isClient = sl<LanModeService>().isClient;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Store type',
          subtitle:
              'Controls categories, units, batches/expiry, and clothing variants',
        ),
        const SizedBox(height: AppSpacing.sm),
        if (isClient) ...[
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Business profile (from host)',
              border: OutlineInputBorder(),
            ),
            child: Text(_current?.displayName ?? 'Unknown'),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Store type is managed on the shop host PC.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ] else
          DropdownButtonFormField<StoreProfileId>(
            value: _current,
            decoration: const InputDecoration(
              labelText: 'Business profile',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final id in StoreProfiles.allIds)
                DropdownMenuItem(value: id, child: Text(id.displayName)),
            ],
            onChanged: _busy ? null : _onChanged,
          ),
      ],
    );
  }
}

/// LAN multi-device host / client settings.
class LanMultiDeviceSettingsCard extends StatefulWidget {
  const LanMultiDeviceSettingsCard({super.key});

  @override
  State<LanMultiDeviceSettingsCard> createState() =>
      _LanMultiDeviceSettingsCardState();
}

class _LanMultiDeviceSettingsCardState
    extends State<LanMultiDeviceSettingsCard> {
  late LanDeviceMode _mode;
  late final TextEditingController _hostIp;
  late final TextEditingController _hostPort;
  late final TextEditingController _bindPort;
  String? _status;
  String? _latency;
  bool _busy = false;
  List<String> _localIps = const [];

  @override
  void initState() {
    super.initState();
    final lan = sl<LanModeService>();
    _mode = lan.mode;
    _hostIp = TextEditingController(text: lan.hostIp);
    _hostPort = TextEditingController(text: '${lan.hostPort}');
    _bindPort = TextEditingController(text: '${lan.bindPort}');
    _loadIps();
    _refreshStatus();
  }

  @override
  void dispose() {
    _hostIp.dispose();
    _hostPort.dispose();
    _bindPort.dispose();
    super.dispose();
  }

  Future<void> _loadIps() async {
    final ips = await _localIpList();
    if (!mounted) return;
    setState(() => _localIps = ips);
  }

  Future<void> _refreshStatus() async {
    final host = sl<ShopHostServer>();
    if (_mode == LanDeviceMode.host) {
      setState(() {
        _status = host.isRunning
            ? 'Running on port ${host.boundPort ?? sl<LanModeService>().bindPort}'
            : 'Stopped';
        _latency = null;
      });
      return;
    }
    if (_mode == LanDeviceMode.client) {
      final sw = Stopwatch()..start();
      try {
        final health = await sl<LanApiClient>().health();
        sw.stop();
        await sl<LanConnectionMonitor>().refresh();
        if (!mounted) return;
        setState(() {
          _status =
              'Connected · ${health.businessName} · ${health.storeProfile}';
          _latency = '${sw.elapsedMilliseconds} ms';
        });
      } catch (e) {
        sw.stop();
        if (!mounted) return;
        setState(() {
          _status = 'Unreachable — check Host PC / Wi‑Fi / firewall';
          _latency = null;
        });
      }
      return;
    }
    setState(() {
      _status = 'Local database only — multi-device off';
      _latency = null;
    });
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final lan = sl<LanModeService>();
    final host = sl<ShopHostServer>();
    try {
      await lan.setMode(_mode);
      final bind = int.tryParse(_bindPort.text.trim()) ?? 8080;
      await lan.setBindPort(bind);
      final port = int.tryParse(_hostPort.text.trim()) ?? 8080;
      await lan.setHostAddress(ip: _hostIp.text.trim(), port: port);

      if (_mode == LanDeviceMode.host) {
        await host.stop();
        await host.start();
      } else {
        await host.stop();
      }

      if (_mode == LanDeviceMode.client) {
        final online = await sl<LanConnectionMonitor>().refresh();
        if (online) {
          await sl<StoreProfileService>().syncFromHostProfile();
        }
      }

      await _refreshStatus();
      if (!mounted) return;
      AppToast.show(context, 'Multi-device settings saved');
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context, e.toString(), tone: AppToastTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startHost() async {
    setState(() => _busy = true);
    try {
      final lan = sl<LanModeService>();
      await lan.setMode(LanDeviceMode.host);
      await lan.setBindPort(int.tryParse(_bindPort.text.trim()) ?? 8080);
      await sl<ShopHostServer>().start();
      setState(() => _mode = LanDeviceMode.host);
      await _refreshStatus();
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context, e.toString(), tone: AppToastTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _stopHost() async {
    setState(() => _busy = true);
    try {
      await sl<ShopHostServer>().stop();
      await _refreshStatus();
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context, e.toString(), tone: AppToastTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _testClient() async {
    setState(() => _busy = true);
    final lan = sl<LanModeService>();
    try {
      await lan.setHostAddress(
        ip: _hostIp.text.trim(),
        port: int.tryParse(_hostPort.text.trim()) ?? 8080,
      );
      await _refreshStatus();
      if (_status?.startsWith('Connected') == true) {
        await sl<StoreProfileService>().syncFromHostProfile();
        if (!mounted) return;
        AppToast.show(context, 'Host reachable — profile synced');
      } else {
        if (!mounted) return;
        AppToast.show(
          context,
          'Shop host offline — check Host PC and Wi‑Fi',
          tone: AppToastTone.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context, e.toString(), tone: AppToastTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<List<String>> _localIpList() async {
    final out = <String>[];
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) out.add(addr.address);
        }
      }
    } catch (_) {}
    return out;
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    AppToast.show(context, 'Copied $value');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hostRunning = sl<ShopHostServer>().isRunning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Devices (LAN)',
          subtitle:
              'One PC as shop host; other counters connect on the same Wi‑Fi',
        ),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<LanDeviceMode>(
          segments: const [
            ButtonSegment(
              value: LanDeviceMode.solo,
              label: Text('Solo'),
              icon: Icon(Symbols.computer),
            ),
            ButtonSegment(
              value: LanDeviceMode.host,
              label: Text('Shop Host'),
              icon: Icon(Symbols.dns),
            ),
            ButtonSegment(
              value: LanDeviceMode.client,
              label: Text('Counter'),
              icon: Icon(Symbols.devices),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: _busy
              ? null
              : (s) => setState(() => _mode = s.first),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_mode == LanDeviceMode.solo)
          Text(
            'This device uses its own local database. Multi-device is off.',
            style: theme.textTheme.bodyMedium,
          ),
        if (_mode == LanDeviceMode.host) ...[
          Row(
            children: [
              Chip(
                avatar: Icon(
                  hostRunning ? Symbols.check_circle : Symbols.pause_circle,
                  size: 18,
                ),
                label: Text(hostRunning ? 'Running' : 'Stopped'),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (_status != null)
                Expanded(child: Text(_status!, style: theme.textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _bindPort,
            decoration: const InputDecoration(
              labelText: 'Bind port',
              border: OutlineInputBorder(),
              helperText: 'Allow this port through the firewall on this PC',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('LAN IP addresses — other counters enter one of these:',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          if (_localIps.isEmpty)
            const Text('No IPv4 address found')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final ip in _localIps)
                  ActionChip(
                    label: Text(ip),
                    avatar: const Icon(Symbols.content_copy, size: 16),
                    onPressed: () => _copy(ip),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppButton(
                label: hostRunning ? 'Restart host' : 'Start host',
                onPressed: _busy ? null : _startHost,
              ),
              if (hostRunning)
                AppButton(
                  label: 'Stop host',
                  variant: AppButtonVariant.secondary,
                  onPressed: _busy ? null : _stopHost,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Catalog, inventory, and store type stay on this PC.',
            style: theme.textTheme.bodySmall,
          ),
        ],
        if (_mode == LanDeviceMode.client) ...[
          TextField(
            controller: _hostIp,
            decoration: const InputDecoration(
              labelText: 'Shop host IP',
              border: OutlineInputBorder(),
              helperText: 'Ask the Host PC operator for their LAN IP',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _hostPort,
            decoration: const InputDecoration(
              labelText: 'Host port',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Chip(
                avatar: Icon(
                  _status?.startsWith('Connected') == true
                      ? Symbols.wifi
                      : Symbols.wifi_off,
                  size: 18,
                ),
                label: Text(
                  _status?.startsWith('Connected') == true
                      ? 'Connected'
                      : 'Unreachable',
                ),
              ),
              if (_latency != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(_latency!, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
          if (_status != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(_status!, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: _busy ? 'Testing…' : 'Test connection',
            onPressed: _busy ? null : _testClient,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Products and stock live on the host. This counter sells and views sales only.',
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            label: _busy ? 'Saving…' : 'Save device mode',
            onPressed: _busy ? null : _save,
          ),
        ),
      ],
    );
  }
}
