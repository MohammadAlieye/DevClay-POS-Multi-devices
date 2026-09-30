import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/admin_auth_bloc.dart';
import '../../../licenses/data/admin_license_repository.dart';
import '../../../../widgets/app_toast.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  AppSettings? _settings;
  var _loading = true;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final settings = await sl<AdminLicenseRepository>().getSettings();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final auth = context.read<AdminAuthBloc>().state;
    if (auth is! AdminAuthAuthenticated || _settings == null) return;
    setState(() => _saving = true);
    await sl<AdminLicenseRepository>().saveSettings(
      actor: auth.user,
      settings: _settings!,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    AppToast.show(context, 'Settings saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trial & App Settings'),
        actions: [
          IconButton(
            onPressed: _saving || _settings == null ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
        ],
      ),
      body: _loading || _settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SwitchListTile(
                  title: const Text('Enable trial'),
                  subtitle: const Text(
                    'When disabled, POS requires a license key immediately',
                  ),
                  value: _settings!.trialEnabled,
                  onChanged: (v) => setState(() {
                    _settings = _settings!.copyWith(trialEnabled: v);
                  }),
                ),
                ListTile(
                  title: const Text('Default trial days'),
                  subtitle: Text('${_settings!.defaultTrialDays} days'),
                  trailing: SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: '${_settings!.defaultTrialDays}',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (v) {
                        final days = int.tryParse(v);
                        if (days != null && days > 0) {
                          setState(() {
                            _settings =
                                _settings!.copyWith(defaultTrialDays: days);
                          });
                        }
                      },
                    ),
                  ),
                ),
                const Divider(),
                TextFormField(
                  initialValue: _settings!.appVersion,
                  decoration: const InputDecoration(
                    labelText: 'App version',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() {
                    _settings = _settings!.copyWith(appVersion: v);
                  }),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _settings!.minimumSupportedVersion,
                  decoration: const InputDecoration(
                    labelText: 'Minimum supported version',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() {
                    _settings =
                        _settings!.copyWith(minimumSupportedVersion: v);
                  }),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Maintenance mode'),
                  subtitle: const Text('Blocks POS access while enabled'),
                  value: _settings!.maintenanceMode,
                  onChanged: (v) => setState(() {
                    _settings = _settings!.copyWith(maintenanceMode: v);
                  }),
                ),
              ],
            ),
    );
  }
}
