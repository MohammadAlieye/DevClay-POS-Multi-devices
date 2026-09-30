import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../widgets/admin_info_section.dart';
import '../../../auth/domain/entities/admin_user.dart';
import '../../../auth/presentation/bloc/admin_auth_bloc.dart';
import '../../data/admin_license_repository.dart';
import '../../../../widgets/app_toast.dart';

class LicensesPage extends StatefulWidget {
  const LicensesPage({super.key});

  @override
  State<LicensesPage> createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  final _search = TextEditingController();
  final _dateTimeFormat = DateFormat('MMM d, yyyy · h:mm a');
  late Future<List<License>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = sl<AdminLicenseRepository>().listLicenses(query: _search.text);
  }

  AdminUser? get _actor {
    final state = context.read<AdminAuthBloc>().state;
    return state is AdminAuthAuthenticated ? state.user : null;
  }

  Future<void> _openLicenseForm({License? existing}) async {
    final actor = _actor;
    if (actor == null) return;

    final result = await showDialog<License>(
      context: context,
      builder: (context) => _LicenseFormDialog(
        actor: actor,
        existing: existing,
      ),
    );

    if (result != null && mounted) {
      if (existing == null) {
        await Clipboard.setData(ClipboardData(text: result.licenseKey));
        if (!mounted) return;
        AppToast.success(
          context,
          'Created ${result.licenseKey} (copied)',
        );
      } else {
        AppToast.show(context, 'License updated');
      }
      setState(_reload);
    }
  }

  Future<void> _showDetails(License license) async {
    final history =
        await sl<AdminLicenseRepository>().getActivationHistory(license.id);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(license.businessName)),
            AdminStatusChip(
              label: license.status.firestoreValue,
              color: _statusColor(license.status),
            ),
          ],
        ),
        content: SizedBox(
          width: 540,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminInfoSection(
                  title: 'License',
                  rows: [
                    AdminInfoRowData(
                      label: 'License key',
                      value: license.licenseKey,
                      monospace: true,
                    ),
                    AdminInfoRowData(
                      label: 'Plan',
                      value: license.licenseType.firestoreValue,
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Duration days',
                      value: '${license.trialDays}',
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Activated',
                      value: license.activationDate == null
                          ? ''
                          : _dateTimeFormat
                              .format(license.activationDate!.toLocal()),
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Expires',
                      value: license.expiryDate == null
                          ? (license.licenseType == LicenseType.lifetime
                              ? 'Lifetime'
                              : '')
                          : _dateTimeFormat
                              .format(license.expiryDate!.toLocal()),
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Notes',
                      value: license.notes ?? '',
                      copyable: false,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _LicenseExpiryBanner(
                  license: license,
                  dateTimeFormat: _dateTimeFormat,
                ),
                const SizedBox(height: 14),
                AdminInfoSection(
                  title: 'Customer',
                  rows: [
                    AdminInfoRowData(
                      label: 'Business',
                      value: license.businessName,
                    ),
                    AdminInfoRowData(
                      label: 'Owner',
                      value: license.ownerName,
                    ),
                    AdminInfoRowData(
                      label: 'Customer ID',
                      value: license.customerId ?? '',
                      monospace: true,
                    ),
                    AdminInfoRowData(
                      label: 'Email',
                      value: license.email,
                    ),
                    AdminInfoRowData(
                      label: 'Mobile & WhatsApp',
                      value: license.phoneNumber,
                    ),
                    AdminInfoRowData(
                      label: 'Address',
                      value: license.businessAddress,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AdminInfoSection(
                  title: 'Device',
                  rows: [
                    AdminInfoRowData(
                      label: 'Device ID',
                      value: license.machineId ?? '',
                      monospace: true,
                    ),
                    AdminInfoRowData(
                      label: 'Device name',
                      value: license.deviceName ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Activation history',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                if (history.isEmpty)
                  const Text('No activations yet')
                else
                  for (final h in history)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(h.deviceName),
                      subtitle: Text(
                        '${h.machineId}\n${_dateTimeFormat.format(h.activatedAt.toLocal())}',
                      ),
                      isThreeLine: true,
                    ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _copyKey(license.licenseKey),
            child: const Text('Copy key'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openLicenseForm(existing: license);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyKey(String key) async {
    await Clipboard.setData(ClipboardData(text: key));
    if (!mounted) return;
    AppToast.show(context, 'License key copied: $key');
  }

  Color _statusColor(LicenseStatus status) {
    return switch (status) {
      LicenseStatus.active => Colors.green.shade700,
      LicenseStatus.trial => Colors.orange.shade800,
      LicenseStatus.suspended => Colors.red.shade700,
      LicenseStatus.expired => Colors.grey.shade700,
    };
  }

  Future<void> _action(String action, License license) async {
    final actor = _actor;
    if (actor == null) return;
    final repo = sl<AdminLicenseRepository>();

    switch (action) {
      case 'copy':
        await _copyKey(license.licenseKey);
        return;
      case 'edit':
        await _openLicenseForm(existing: license);
        return;
      case 'renew':
        await repo.renewLicense(
          actor: actor,
          license: license,
          newType: license.licenseType == LicenseType.trial ||
                  license.licenseType == LicenseType.custom
              ? LicenseType.yearly
              : license.licenseType,
        );
      case 'suspend':
        await repo.suspendLicense(actor: actor, license: license);
      case 'expire':
        await repo.expireLicense(actor: actor, license: license);
      case 'activate':
        final machine = TextEditingController();
        final device = TextEditingController(text: 'On-site activation');
        final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Activate on machine'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: machine,
                  decoration: const InputDecoration(labelText: 'Machine ID'),
                ),
                TextField(
                  controller: device,
                  decoration: const InputDecoration(labelText: 'Device name'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Activate'),
              ),
            ],
          ),
        );
        if (ok == true) {
          await repo.activateLicenseManually(
            actor: actor,
            license: license,
            machineId: machine.text.trim(),
            deviceName: device.text.trim(),
          );
        }
      case 'delete':
        await repo.deleteLicense(actor: actor, license: license);
      case 'details':
        await _showDetails(license);
        return;
    }
    if (mounted) setState(_reload);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Licenses'),
        actions: [
          IconButton(
            onPressed: () => _openLicenseForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Create license',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by business, phone, owner, key…',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => setState(_reload),
                  icon: const Icon(Icons.refresh),
                ),
              ),
              onSubmitted: (_) => setState(_reload),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<License>>(
              future: _future,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snap.data!;
                if (items.isEmpty) {
                  return const Center(child: Text('No licenses yet'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final l = items[i];
                    final expiryInfo = _LicenseExpiryInfo.from(l);
                    return ListTile(
                      onTap: () => _showDetails(l),
                      title: Row(
                        children: [
                          Expanded(child: Text(l.businessName)),
                          _StatusChip(
                            label: l.status.firestoreValue,
                            color: _statusColor(l.status),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            l.licenseKey,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l.licenseType.firestoreValue}'
                            '${l.machineId != null ? ' · ${l.deviceName}' : ''}',
                          ),
                          const SizedBox(height: 8),
                          _LicenseExpiryBanner(
                            license: l,
                            dateTimeFormat: _dateTimeFormat,
                            compact: true,
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            expiryInfo.icon,
                            color: expiryInfo.color,
                            size: 20,
                          ),
                          IconButton(
                            tooltip: 'Copy license key',
                            onPressed: () => _copyKey(l.licenseKey),
                            icon: const Icon(Icons.copy),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (v) => _action(v, l),
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'details',
                                child: Text('Details / History'),
                              ),
                              PopupMenuItem(
                                value: 'copy',
                                child: Text('Copy license key'),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit details'),
                              ),
                              PopupMenuItem(
                                value: 'activate',
                                child: Text('Activate'),
                              ),
                              PopupMenuItem(
                                value: 'renew',
                                child: Text('Renew'),
                              ),
                              PopupMenuItem(
                                value: 'suspend',
                                child: Text('Suspend'),
                              ),
                              PopupMenuItem(
                                value: 'expire',
                                child: Text('Expire'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LicenseFormDialog extends StatefulWidget {
  const _LicenseFormDialog({
    required this.actor,
    this.existing,
  });

  final AdminUser actor;
  final License? existing;

  @override
  State<_LicenseFormDialog> createState() => _LicenseFormDialogState();
}

class _LicenseFormDialogState extends State<_LicenseFormDialog> {
  late final TextEditingController _business;
  late final TextEditingController _owner;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _notes;
  late final TextEditingController _durationDays;
  late String _key;
  late LicenseType _type;
  late LicenseStatus _status;
  var _clearMachine = false;
  var _saving = false;
  var _loadingCustomers = true;
  List<LicenseCustomer> _customers = [];
  String? _selectedCustomerId;
  var _manualEntry = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _business = TextEditingController(text: e?.businessName ?? '');
    _owner = TextEditingController(text: e?.ownerName ?? '');
    _phone = TextEditingController(text: e?.phoneNumber ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _address = TextEditingController(text: e?.businessAddress ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _type = e?.licenseType ?? LicenseType.yearly;
    _status = e?.status ?? LicenseStatus.active;
    _key = e?.licenseKey ?? LicenseKeyGenerator.generate();
    _selectedCustomerId = e?.customerId;
    _manualEntry = _isEdit;
    final days = e?.trialDays ??
        (_type == LicenseType.trial
            ? LicenseConstants.defaultTrialDays
            : 90);
    _durationDays = TextEditingController(text: '$days');
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await sl<AdminLicenseRepository>().listCustomers();
      if (!mounted) return;
      setState(() {
        _customers = customers;
        _loadingCustomers = false;
        if (!_isEdit && customers.isEmpty) {
          _manualEntry = true;
        }
        if (_selectedCustomerId != null) {
          final match = customers.where((c) => c.id == _selectedCustomerId);
          if (match.isNotEmpty) {
            _applyCustomer(match.first);
          }
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingCustomers = false;
        _manualEntry = true;
      });
    }
  }

  void _applyCustomer(LicenseCustomer customer) {
    _selectedCustomerId = customer.id;
    _business.text = customer.businessName;
    _owner.text = customer.ownerName;
    _phone.text = customer.phone;
    _email.text = customer.email;
    _address.text = customer.address;
  }

  void _clearCustomerFields() {
    _selectedCustomerId = null;
    _business.clear();
    _owner.clear();
    _phone.clear();
    _email.clear();
    _address.clear();
  }

  @override
  void dispose() {
    _business.dispose();
    _owner.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _notes.dispose();
    _durationDays.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_manualEntry && _selectedCustomerId == null && !_isEdit) {
      AppToast.show(context, 'Select a customer or switch to manual entry');
      return;
    }
    if (_business.text.trim().isEmpty) {
      AppToast.show(context, 'Business name is required');
      return;
    }

    final days = int.tryParse(_durationDays.text.trim()) ?? 0;
    if (_type.requiresCustomDays && days <= 0) {
      AppToast.show(context, 
            _type == LicenseType.custom
                ? 'Enter custom duration in days'
                : 'Enter trial days',
          );
      return;
    }

    setState(() => _saving = true);
    final repo = sl<AdminLicenseRepository>();
    try {
      final License license;
      if (_isEdit) {
        license = await repo.updateLicense(
          actor: widget.actor,
          license: widget.existing!,
          businessName: _business.text,
          ownerName: _owner.text,
          phoneNumber: _phone.text,
          email: _email.text,
          businessAddress: _address.text,
          licenseType: _type,
          status: _status,
          durationDays: days > 0 ? days : widget.existing!.trialDays,
          notes: _notes.text,
          clearMachineBinding: _clearMachine,
        );
      } else {
        license = await repo.createLicense(
          actor: widget.actor,
          businessName: _business.text,
          ownerName: _owner.text,
          phoneNumber: _phone.text,
          email: _email.text,
          businessAddress: _address.text,
          licenseType: _type,
          trialDays: days > 0 ? days : LicenseConstants.defaultTrialDays,
          customDays: days > 0 ? days : null,
          notes: _notes.text,
          licenseKey: _key,
          customerId: _selectedCustomerId,
        );
      }
      if (mounted) Navigator.pop(context, license);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppToast.show(context, '$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit License' : 'Create License'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isEdit)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Key: $_key',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Generate',
                      onPressed: () => setState(() {
                        _key = LicenseKeyGenerator.generate();
                      }),
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      tooltip: 'Copy',
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: _key)),
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(
                    'Key: $_key',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              const SizedBox(height: 8),
              DropdownButtonFormField<LicenseType>(
                initialValue: _type,
                items: LicenseType.values
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.firestoreValue),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _type = v ?? _type;
                  if (_type == LicenseType.trial &&
                      _durationDays.text.trim().isEmpty) {
                    _durationDays.text =
                        '${LicenseConstants.defaultTrialDays}';
                  }
                }),
                decoration: const InputDecoration(labelText: 'License type'),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<LicenseStatus>(
                  initialValue: _status,
                  items: LicenseStatus.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.firestoreValue),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _status = v ?? _status),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ],
              if (_type.requiresCustomDays) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _durationDays,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _type == LicenseType.custom
                        ? 'Custom duration (days)'
                        : 'Trial days',
                    hintText: _type == LicenseType.custom ? 'e.g. 45' : '15',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Customer',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              if (_loadingCustomers)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (!_isEdit) ...[
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: false,
                        label: Text('Select customer'),
                        icon: Icon(Icons.person_search, size: 18),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text('Enter manually'),
                        icon: Icon(Icons.edit, size: 18),
                      ),
                    ],
                    selected: {_manualEntry},
                    onSelectionChanged: (value) {
                      setState(() {
                        _manualEntry = value.first;
                        if (!_manualEntry) {
                          // Keep selected customer fill; if none, clear.
                          if (_selectedCustomerId == null) {
                            _clearCustomerFields();
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                if (!_manualEntry) ...[
                  if (_customers.isEmpty)
                    const Text(
                      'No customers yet. Add one under Customers, or switch to Enter manually.',
                    )
                  else
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCustomerId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Select customer',
                        border: OutlineInputBorder(),
                      ),
                      items: _customers
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(
                                '${c.businessName} · ${c.ownerName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (id) {
                        if (id == null) return;
                        final customer =
                            _customers.firstWhere((c) => c.id == id);
                        setState(() => _applyCustomer(customer));
                      },
                    ),
                  if (_selectedCustomerId != null) ...[
                    const SizedBox(height: 12),
                    _CustomerPreview(
                      business: _business.text,
                      owner: _owner.text,
                      phone: _phone.text,
                      email: _email.text,
                      address: _address.text,
                    ),
                  ],
                ] else ...[
                  TextField(
                    controller: _business,
                    decoration:
                        const InputDecoration(labelText: 'Business name'),
                  ),
                  TextField(
                    controller: _owner,
                    decoration: const InputDecoration(labelText: 'Owner name'),
                  ),
                  TextField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile & WhatsApp',
                    ),
                  ),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _address,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                ],
              ],
              TextField(
                controller: _notes,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              if (_isEdit && widget.existing?.isBound == true)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _clearMachine,
                  onChanged: (v) =>
                      setState(() => _clearMachine = v ?? false),
                  title: const Text('Unbind machine'),
                  subtitle: Text(
                    'Current: ${widget.existing!.deviceName ?? widget.existing!.machineId}',
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}

class _CustomerPreview extends StatelessWidget {
  const _CustomerPreview({
    required this.business,
    required this.owner,
    required this.phone,
    required this.email,
    required this.address,
  });

  final String business;
  final String owner;
  final String phone;
  final String email;
  final String address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(business, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text('$owner · $phone'),
          if (email.isNotEmpty) Text(email),
          if (address.isNotEmpty) Text(address),
        ],
      ),
    );
  }
}

class _LicenseExpiryInfo {
  const _LicenseExpiryInfo({
    required this.label,
    required this.color,
    required this.icon,
    this.dateTimeText,
    this.subtitle,
  });

  final String label;
  final Color color;
  final IconData icon;
  final String? dateTimeText;
  final String? subtitle;

  static _LicenseExpiryInfo from(License license) {
    if (license.status == LicenseStatus.suspended) {
      return _LicenseExpiryInfo(
        label: 'Suspended',
        color: Colors.red.shade700,
        icon: Icons.block,
        subtitle: 'License access is suspended',
      );
    }

    if (license.licenseType == LicenseType.lifetime) {
      return _LicenseExpiryInfo(
        label: 'Lifetime',
        color: Colors.teal.shade700,
        icon: Icons.all_inclusive,
        subtitle: 'No expiry date',
      );
    }

    final expiry = license.expiryDate;
    if (expiry == null) {
      return _LicenseExpiryInfo(
        label: 'No expiry set',
        color: Colors.blueGrey.shade600,
        icon: Icons.event,
        subtitle: 'Expiry date not configured',
      );
    }

    final localExpiry = expiry.toLocal();
    final daysLeft = expiry.toUtc().difference(DateTime.now().toUtc()).inDays;
    final dateTimeText = DateFormat('MMM d, yyyy · h:mm a').format(localExpiry);

    if (license.status == LicenseStatus.expired || license.isExpired) {
      return _LicenseExpiryInfo(
        label: 'Expired',
        color: Colors.red.shade700,
        icon: Icons.event_busy,
        dateTimeText: dateTimeText,
        subtitle: daysLeft < 0
            ? 'Expired ${-daysLeft} day${-daysLeft == 1 ? '' : 's'} ago'
            : 'Expired on',
      );
    }

    if (license.isExpiringSoon) {
      return _LicenseExpiryInfo(
        label: 'Expiring soon',
        color: Colors.orange.shade800,
        icon: Icons.warning_amber_rounded,
        dateTimeText: dateTimeText,
        subtitle: daysLeft == 0
            ? 'Expires today'
            : 'Expires in $daysLeft day${daysLeft == 1 ? '' : 's'}',
      );
    }

    return _LicenseExpiryInfo(
      label: 'Active',
      color: Colors.green.shade700,
      icon: Icons.event_available,
      dateTimeText: dateTimeText,
      subtitle: daysLeft == 0
          ? 'Expires today'
          : 'Expires in $daysLeft day${daysLeft == 1 ? '' : 's'}',
    );
  }
}

class _LicenseExpiryBanner extends StatelessWidget {
  const _LicenseExpiryBanner({
    required this.license,
    required this.dateTimeFormat,
    this.compact = false,
  });

  final License license;
  final DateFormat dateTimeFormat;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final info = _LicenseExpiryInfo.from(license);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: info.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, size: compact ? 18 : 20, color: info.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: info.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (info.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    info.subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: info.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (info.dateTimeText != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    info.dateTimeText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
