import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../licenses/data/admin_license_repository.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final _controller = TextEditingController();
  List<License> _licenses = [];
  List<LicenseCustomer> _customers = [];
  var _searched = false;

  Future<void> _search() async {
    final q = _controller.text;
    final repo = sl<AdminLicenseRepository>();
    final licenses = await repo.listLicenses(query: q);
    final customers = await repo.listCustomers(query: q);
    if (!mounted) return;
    setState(() {
      _licenses = licenses;
      _customers = customers;
      _searched = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Business, phone, owner, license key…',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: !_searched
                ? const Center(child: Text('Enter a query to search'))
                : ListView(
                    children: [
                      const ListTile(title: Text('Licenses')),
                      if (_licenses.isEmpty)
                        const ListTile(title: Text('No license matches')),
                      for (final l in _licenses)
                        ListTile(
                          title: Text(l.businessName),
                          subtitle: Text(
                            '${l.licenseKey} · ${l.status.firestoreValue}',
                          ),
                        ),
                      const ListTile(title: Text('Customers')),
                      if (_customers.isEmpty)
                        const ListTile(title: Text('No customer matches')),
                      for (final c in _customers)
                        ListTile(
                          title: Text(c.businessName),
                          subtitle: Text('${c.ownerName} · ${c.phone}'),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
