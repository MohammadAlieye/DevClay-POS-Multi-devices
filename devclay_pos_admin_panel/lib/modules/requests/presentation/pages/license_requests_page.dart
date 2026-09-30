import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../widgets/admin_info_section.dart';
import '../../../auth/domain/entities/admin_user.dart';
import '../../../auth/presentation/bloc/admin_auth_bloc.dart';
import '../../../licenses/data/admin_license_repository.dart';
import '../../../../widgets/app_toast.dart';

class LicenseRequestsPage extends StatefulWidget {
  const LicenseRequestsPage({super.key});

  @override
  State<LicenseRequestsPage> createState() => _LicenseRequestsPageState();
}

class _LicenseRequestsPageState extends State<LicenseRequestsPage> {
  late Future<List<LicenseRequest>> _future;
  LicenseRequestStatus? _filter;
  final _fmt = DateFormat('MMM d, yyyy · h:mm a');

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = sl<AdminLicenseRepository>().listLicenseRequests(status: _filter);
  }

  AdminUser? get _actor {
    final state = context.read<AdminAuthBloc>().state;
    return state is AdminAuthAuthenticated ? state.user : null;
  }

  Color _statusColor(LicenseRequestStatus status) {
    return switch (status) {
      LicenseRequestStatus.pending => Colors.orange.shade800,
      LicenseRequestStatus.inProgress => Colors.blue.shade700,
      LicenseRequestStatus.resolved => Colors.green.shade700,
      LicenseRequestStatus.rejected => Colors.red.shade700,
    };
  }

  Future<void> _copy(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    AppToast.show(context, '$label copied');
  }

  Future<void> _updateStatus(LicenseRequest request) async {
    final actor = _actor;
    if (actor == null) return;

    var status = request.status;
    final note = TextEditingController(text: request.adminNote ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Update request'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<LicenseRequestStatus>(
                      initialValue: status,
                      items: LicenseRequestStatus.values
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.firestoreValue),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setLocal(() => status = v ?? status),
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: note,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Admin note',
                        border: OutlineInputBorder(),
                      ),
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
            );
          },
        );
      },
    );

    if (ok != true) return;
    await sl<AdminLicenseRepository>().updateLicenseRequestStatus(
      actor: actor,
      request: request,
      status: status,
      adminNote: note.text.trim().isEmpty ? null : note.text.trim(),
    );
    note.dispose();
    if (!mounted) return;
    setState(_reload);
  }

  Future<void> _showDetails(LicenseRequest request) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(request.type.firestoreValue)),
            AdminStatusChip(
              label: request.status.firestoreValue,
              color: _statusColor(request.status),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminInfoSection(
                  title: 'Request',
                  rows: [
                    AdminInfoRowData(
                      label: 'Created',
                      value: _fmt.format(request.createdAt.toLocal()),
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Updated',
                      value: _fmt.format(request.updatedAt.toLocal()),
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Type',
                      value: request.type.firestoreValue,
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Message',
                      value: request.message ?? '',
                      copyable: false,
                    ),
                    AdminInfoRowData(
                      label: 'Admin note',
                      value: request.adminNote ?? '',
                      copyable: false,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AdminInfoSection(
                  title: 'Customer',
                  rows: [
                    AdminInfoRowData(
                      label: 'Business',
                      value: request.businessName ?? '',
                    ),
                    AdminInfoRowData(
                      label: 'Owner',
                      value: request.ownerName ?? '',
                    ),
                    AdminInfoRowData(
                      label: 'Customer ID',
                      value: request.customerId ?? '',
                      monospace: true,
                    ),
                    AdminInfoRowData(
                      label: 'Email',
                      value: request.contactEmail ?? '',
                    ),
                    AdminInfoRowData(
                      label: 'Mobile & WhatsApp',
                      value: request.contactPhone ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AdminInfoSection(
                  title: 'License & device',
                  rows: [
                    AdminInfoRowData(
                      label: 'License key',
                      value: request.licenseKey ?? '',
                      monospace: true,
                    ),
                    AdminInfoRowData(
                      label: 'Device ID',
                      value: request.machineId,
                      monospace: true,
                    ),
                    AdminInfoRowData(
                      label: 'Device name',
                      value: request.deviceName ?? '',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          if ((request.licenseKey ?? '').isNotEmpty)
            TextButton(
              onPressed: () => _copy(request.licenseKey!, 'License key'),
              child: const Text('Copy key'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(request);
            },
            child: const Text('Update status'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Requests'),
        actions: [
          IconButton(
            onPressed: () => setState(_reload),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() {
                    _filter = null;
                    _reload();
                  }),
                ),
                for (final status in LicenseRequestStatus.values)
                  FilterChip(
                    label: Text(status.firestoreValue),
                    selected: _filter == status,
                    onSelected: (_) => setState(() {
                      _filter = status;
                      _reload();
                    }),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LicenseRequest>>(
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
                  return const Center(child: Text('No license requests yet'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = items[i];
                    final color = _statusColor(r.status);
                    return ListTile(
                      onTap: () => _showDetails(r),
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        child: Icon(Icons.mail_outline, color: color, size: 20),
                      ),
                      title: Text(
                        r.businessName?.isNotEmpty == true
                            ? r.businessName!
                            : (r.licenseKey ?? 'Unknown business'),
                      ),
                      subtitle: Text(
                        '${r.type.firestoreValue} · ${r.status.firestoreValue}\n'
                        '${(r.contactPhone ?? '').isEmpty ? 'No mobile' : r.contactPhone} · '
                        '${_fmt.format(r.createdAt.toLocal())}',
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'details') {
                            await _showDetails(r);
                          } else if (value == 'update') {
                            await _updateStatus(r);
                          } else if (value == 'copy' &&
                              (r.licenseKey ?? '').isNotEmpty) {
                            await _copy(r.licenseKey!, 'License key');
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'details',
                            child: Text('View details'),
                          ),
                          const PopupMenuItem(
                            value: 'update',
                            child: Text('Update status'),
                          ),
                          if ((r.licenseKey ?? '').isNotEmpty)
                            const PopupMenuItem(
                              value: 'copy',
                              child: Text('Copy license key'),
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
