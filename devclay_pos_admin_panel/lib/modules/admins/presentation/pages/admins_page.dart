import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/admin_user.dart';
import '../../../auth/domain/repositories/admin_auth_repository.dart';
import '../../../auth/presentation/bloc/admin_auth_bloc.dart';
import '../../../../widgets/app_toast.dart';

/// Lists normal admins only. Super Admin never appears here.
class AdminsPage extends StatefulWidget {
  const AdminsPage({super.key});

  @override
  State<AdminsPage> createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  late Future<List<AdminUser>> _future;

  @override
  void initState() {
    super.initState();
    _future = sl<AdminAuthRepository>().listAdmins();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AdminAuthBloc>().state;
    final isSuper =
        auth is AdminAuthAuthenticated && auth.user.isSuperAdmin;

    if (!isSuper) {
      return const Scaffold(
        body: Center(child: Text('Super Admin only')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Users'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _future = sl<AdminAuthRepository>().listAdmins();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<AdminUser>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Super Admin is hidden and never listed. '
                  'Create normal admins in Firebase Auth, then add a matching '
                  'document under the `admins/{uid}` collection.',
                ),
              ),
              if (items.isEmpty)
                const ListTile(title: Text('No normal admin users yet')),
              for (final a in items)
                ListTile(
                  title: Text(a.displayName),
                  subtitle: Text(
                    '${a.email}${a.locked ? ' · LOCKED' : ''}',
                  ),
                  trailing: a.locked
                      ? TextButton(
                          onPressed: () async {
                            await sl<AdminAuthRepository>().unlockAdmin(a.uid);
                            if (!context.mounted) return;
                            setState(() {
                              _future =
                                  sl<AdminAuthRepository>().listAdmins();
                            });
                          },
                          child: const Text('Unlock'),
                        )
                      : TextButton(
                          onPressed: () async {
                            await sl<AdminAuthRepository>()
                                .sendPasswordReset(a.email);
                            if (!context.mounted) return;
                            AppToast.show(context, 'Reset email sent to ${a.email}');
                          },
                          child: const Text('Reset password'),
                        ),
                ),
            ],
          );
        },
      ),
    );
  }
}
