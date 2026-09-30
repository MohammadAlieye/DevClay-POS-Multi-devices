import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../widgets/admin_info_section.dart';
import '../../../auth/domain/entities/admin_user.dart';
import '../../../auth/presentation/bloc/admin_auth_bloc.dart';
import '../../../licenses/data/admin_license_repository.dart';
import '../../../../widgets/app_toast.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _search = TextEditingController();
  late Future<List<CustomerWithLicense>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = sl<AdminLicenseRepository>().listCustomersWithLicenses(
      query: _search.text,
    );
  }

  AdminUser? get _actor {
    final state = context.read<AdminAuthBloc>().state;
    return state is AdminAuthAuthenticated ? state.user : null;
  }

  Future<void> _copyKey(String key) async {
    await Clipboard.setData(ClipboardData(text: key));
    if (!mounted) return;
    AppToast.show(context, 'License key copied: $key');
  }

  Future<void> _showEditor({LicenseCustomer? existing}) async {
    final actor = _actor;
    if (actor == null) return;

    final business = TextEditingController(text: existing?.businessName);
    final owner = TextEditingController(text: existing?.ownerName);
    final phone = TextEditingController(text: existing?.phone);
    final email = TextEditingController(text: existing?.email);
    final address = TextEditingController(text: existing?.address);

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Customer' : 'Edit Customer'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: business,
                decoration: const InputDecoration(labelText: 'Business name'),
              ),
              TextField(
                controller: owner,
                decoration: const InputDecoration(labelText: 'Owner name'),
              ),
              TextField(
                controller: phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile & WhatsApp',
                ),
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: address,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final repo = sl<AdminLicenseRepository>();
    if (existing == null) {
      await repo.createCustomer(
        actor: actor,
        businessName: business.text,
        ownerName: owner.text,
        phone: phone.text,
        email: email.text,
        address: address.text,
      );
    } else {
      await repo.updateCustomer(
        actor: actor,
        customer: existing.copyWith(
          businessName: business.text,
          ownerName: owner.text,
          phone: phone.text,
          email: email.text,
          address: address.text,
        ),
      );
    }
    if (!mounted) return;
    setState(_reload);
  }

  Future<void> _showDetails(CustomerWithLicense row) async {
    final c = row.customer;
    final license = row.license;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(c.businessName),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminInfoSection(
                  title: 'Customer',
                  rows: [
                    AdminInfoRowData(label: 'Business', value: c.businessName),
                    AdminInfoRowData(label: 'Owner', value: c.ownerName),
                    AdminInfoRowData(
                      label: 'Customer ID',
                      value: c.id,
                      monospace: true,
                    ),
                    AdminInfoRowData(label: 'Email', value: c.email),
                    AdminInfoRowData(
                      label: 'Mobile & WhatsApp',
                      value: c.phone,
                    ),
                    AdminInfoRowData(label: 'Address', value: c.address),
                  ],
                ),
                const SizedBox(height: 14),
                if (license == null)
                  Text(
                    'No license linked',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  AdminInfoSection(
                    title: 'License & device',
                    trailing: AdminStatusChip(
                      label: license.status.firestoreValue,
                      color: _statusColor(license.status),
                    ),
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
              ],
            ),
          ),
        ),
        actions: [
          if (license != null)
            TextButton(
              onPressed: () => _copyKey(license.licenseKey),
              child: const Text('Copy key'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditor(existing: c);
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

  Color _statusColor(LicenseStatus status) {
    return switch (status) {
      LicenseStatus.active => Colors.green.shade700,
      LicenseStatus.trial => Colors.orange.shade800,
      LicenseStatus.suspended => Colors.red.shade700,
      LicenseStatus.expired => Colors.grey.shade700,
    };
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
        title: const Text('Customers'),
        actions: [
          IconButton(
            onPressed: () => _showEditor(),
            icon: const Icon(Icons.add),
            tooltip: 'Add customer',
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
                hintText: 'Search business, owner, mobile…',
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
            child: FutureBuilder<List<CustomerWithLicense>>(
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
                  return const Center(child: Text('No customers yet'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final row = items[i];
                    final c = row.customer;
                    final license = row.license;
                    return ListTile(
                      onTap: () => _showDetails(row),
                      title: Text(c.businessName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${c.ownerName} · ${c.phone}'),
                          if (c.email.isNotEmpty) Text(c.email),
                          const SizedBox(height: 6),
                          if (license == null)
                            Text(
                              'No license linked',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                AdminStatusChip(
                                  label:
                                      '${license.status.firestoreValue} · ${license.licenseType.firestoreValue}',
                                  color: _statusColor(license.status),
                                ),
                                SelectableText(
                                  license.licenseKey,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Copy license key',
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.copy, size: 18),
                                  onPressed: () => _copyKey(license.licenseKey),
                                ),
                              ],
                            ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          final actor = _actor;
                          if (actor == null) return;
                          if (value == 'details') {
                            await _showDetails(row);
                          } else if (value == 'edit') {
                            await _showEditor(existing: c);
                          } else if (value == 'copy' && license != null) {
                            await _copyKey(license.licenseKey);
                          } else if (value == 'delete') {
                            await sl<AdminLicenseRepository>().deleteCustomer(
                              actor: actor,
                              customerId: c.id,
                            );
                            if (mounted) setState(_reload);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'details',
                            child: Text('View details'),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          if (license != null)
                            const PopupMenuItem(
                              value: 'copy',
                              child: Text('Copy license key'),
                            ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
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
