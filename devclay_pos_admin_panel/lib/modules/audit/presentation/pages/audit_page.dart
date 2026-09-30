import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../licenses/data/admin_license_repository.dart';

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  late Future<List<AuditLog>> _future;

  @override
  void initState() {
    super.initState();
    _future = sl<AdminLicenseRepository>().listAuditLogs();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.yMMMd().add_jm();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _future = sl<AdminLicenseRepository>().listAuditLogs();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<AuditLog>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No audit events yet'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final log = items[i];
              return ListTile(
                leading: Icon(
                  log.isSuperAdmin
                      ? Icons.shield
                      : Icons.history,
                ),
                title: Text(log.action),
                subtitle: Text(
                  '${log.actorEmail}'
                  '${log.details != null ? ' · ${log.details}' : ''}\n'
                  '${fmt.format(log.createdAt.toLocal())}',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
