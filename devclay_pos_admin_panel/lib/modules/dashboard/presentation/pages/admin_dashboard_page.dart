import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../licenses/data/admin_license_repository.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<DashboardStats> _future;

  @override
  void initState() {
    super.initState();
    _future = sl<AdminLicenseRepository>().getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _future = sl<AdminLicenseRepository>().getDashboardStats();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<DashboardStats>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snap.data!;
          final cards = [
            ('Total Customers', s.totalCustomers, Icons.store),
            ('Active Licenses', s.activeLicenses, Icons.check_circle),
            ('Trial Licenses', s.trialLicenses, Icons.timelapse),
            ('Expired Licenses', s.expiredLicenses, Icons.event_busy),
            ('Suspended Licenses', s.suspendedLicenses, Icons.block),
            ('Expiring Soon', s.expiringSoon, Icons.warning_amber),
          ];
          return GridView.count(
            padding: const EdgeInsets.all(24),
            crossAxisCount: MediaQuery.sizeOf(context).width > 1100 ? 3 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.2,
            children: [
              for (final c in cards)
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(c.$3, size: 36),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c.$1,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                '${c.$2}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
