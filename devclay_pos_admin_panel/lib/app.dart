import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'modules/auth/presentation/bloc/admin_auth_bloc.dart';

class DevClayAdminApp extends StatelessWidget {
  const DevClayAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F4C5C),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'SourceSans3',
    );

    return BlocProvider.value(
      value: sl<AdminAuthBloc>()..add(const AdminAuthStarted()),
      child: MaterialApp.router(
        title: 'DevClayPOS Admin',
        debugShowCheckedModeBanner: false,
        theme: base.copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: base.colorScheme.surface,
            foregroundColor: base.colorScheme.onSurface,
            elevation: 0,
          ),
        ),
        routerConfig: sl<GoRouter>(),
      ),
    );
  }
}
